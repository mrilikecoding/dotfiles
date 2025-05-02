-- ~/.config/nvim/lua/dap_projects.lua
---@brief [[
-- DAP Projects Configuration
-- This module manages Debug Adapter Protocol (DAP) configurations for different projects.
-- It automatically loads the appropriate configuration based on the current working directory.
--
-- Features:
-- - Project-specific debug configurations
-- - Default fallback configuration
-- - Keybindings for common debugging operations
-- - Automatic configuration loading
--
-- Usage:
--   require("dap_projects") -- Automatically loads config for current directory
--
-- Manual operations:
--   :DapAttachDebugger    - Attach to running debugger
--   :DapClearBreakpoints  - Clear all breakpoints
--
-- Keybindings:
--   <Leader>da - Attach to debugger
--   <Leader>db - Toggle breakpoint
--   <Leader>dc - Continue execution
--   <Leader>ds - Step over
--   <Leader>di - Step into
--   <Leader>do - Step out
--   <Leader>de - Evaluate expression under cursor
--   <Leader>du - Toggle debug UI
--   <Leader>dx - Clear all breakpoints
---@brief ]]

-- DAP Projects Module
-- A comprehensive debugger manager for Neovim with project-specific configs
local M = {
  -- Module state
  initialized = false,
  last_loaded_dir = nil,
  
  -- Submodules
  utils = {},    -- Utility functions
  adapters = {}, -- Adapter setup functions
  config = {},   -- Configuration functions
}

-- Setup commands and keybindings for DAP interaction
function M.config.setup_commands_and_keybindings()
  -- Create user commands
  vim.api.nvim_create_user_command("DapAttachDebugger", function()
    local dap = require("dap")
    
    -- First clean up any existing sessions to prevent conflicts
    for _, session in pairs(dap.sessions()) do
      session:close()
    end
    
    -- Small delay to ensure cleanup is complete
    vim.defer_fn(function()
      dap.continue()
      M.log("Attached to debugger", "success")
    end, 100)
  end, { desc = "Attach to running debugger" })

  vim.api.nvim_create_user_command("DapClearBreakpoints", function()
    require("dap").clear_breakpoints()
    M.log("All breakpoints cleared", "info")
  end, { desc = "Clear all breakpoints" })
  
  vim.api.nvim_create_user_command("DapResetState", function()
    -- Most aggressive cleanup possible
    local ok, dap = pcall(require, "dap")
    if not ok then
      M.log("DAP not available", "error")
      return
    end
    
    -- First try to close all sessions properly
    local sessions = dap.sessions()
    if #sessions > 0 then
      M.log("Terminating " .. #sessions .. " active debug sessions", "warn")
      for _, session in pairs(sessions) do
        pcall(function() session:close() end)
      end
    end
    
    -- Wait a bit for sessions to close
    vim.defer_fn(function()
      -- Reset adapters and other dap state if possible
      if type(dap.reset) == "function" then
        dap.reset()
      end
      
      -- Forcibly clear internal session tracking
      if type(dap.session) ~= "nil" then
        dap.session = nil
      end
      
      if dap.sessions and #dap.sessions() > 0 then
        -- If we can access the internal sessions table directly, clear it
        if type(dap._sessions) == "table" then
          for k in pairs(dap._sessions) do
            dap._sessions[k] = nil
          end
        end
        
        M.log("Forcibly reset all DAP sessions", "warn")
      end
      
      -- Try to clear any client connections by unloading and reloading DAP
      package.loaded["dap"] = nil
      require("dap")
      
      M.log("DAP state has been completely reset", "success")
    end, 300)
  end, { desc = "Reset DAP state completely (emergency use)" })
  
  vim.api.nvim_create_user_command("DapListSessions", function()
    local dap = require("dap")
    local sessions = dap.sessions()
    
    if #sessions == 0 then
      M.log("No active debug sessions", "info")
      return
    end
    
    local lines = {"Active debug sessions:"}
    for i, session in ipairs(sessions) do
      local config = session.config or {}
      local name = config.name or "Session " .. i
      local type = config.type or "unknown"
      table.insert(lines, i .. ": " .. name .. " (" .. type .. ")")
    end
    
    M.log(table.concat(lines, "\n"), "info")
  end, { desc = "List all active debug sessions" })
  
  vim.api.nvim_create_user_command("DapCloseAllSessions", function()
    -- More aggressive session cleanup
    local ok, dap = pcall(require, "dap")
    if not ok then
      M.log("DAP not available", "error")
      return
    end
    
    local sessions = dap.sessions()
    local session_count = #sessions
    
    if session_count == 0 then
      M.log("No active debug sessions", "info")
      return
    end
    
    -- Close all sessions
    for _, session in pairs(sessions) do
      pcall(function() session:close() end)
    end
    
    -- Force reinitialization of DAP session tracking
    vim.defer_fn(function()
      if #dap.sessions() > 0 then
        M.log("Warning: Some sessions did not close cleanly", "warn")
      else
        M.log("Closed all debug sessions", "success")
      end
    end, 200)
  end, { desc = "Close all active debug sessions" })

  -- Define keybindings with consistent descriptions
  local keybindings = {
    -- Basic debugging operations
    {
      mode = "n",
      lhs = "<Leader>da",
      rhs = function()
        vim.cmd("DapAttachDebugger")
      end,
      desc = "debug: attach to debugger",
    },
    {
      mode = "n",
      lhs = "<Leader>dl",
      rhs = function()
        vim.cmd("DapListSessions")
      end,
      desc = "debug: list sessions",
    },
    {
      mode = "n",
      lhs = "<Leader>dC",
      rhs = function()
        vim.cmd("DapCloseAllSessions")
      end,
      desc = "debug: close all sessions",
    },
    {
      mode = "n",
      lhs = "<Leader>dR",
      rhs = function()
        vim.cmd("DapResetState")
      end,
      desc = "debug: reset DAP state completely",
    },
    {
      mode = "n",
      lhs = "<Leader>dc",
      rhs = function()
        require("dap").continue()
      end,
      desc = "debug: continue",
    },

    -- Stepping
    {
      mode = "n",
      lhs = "<Leader>ds",
      rhs = function()
        require("dap").step_over()
      end,
      desc = "debug: step over",
    },
    {
      mode = "n",
      lhs = "<Leader>di",
      rhs = function()
        require("dap").step_into()
      end,
      desc = "debug: step into",
    },
    {
      mode = "n",
      lhs = "<Leader>do",
      rhs = function()
        require("dap").step_out()
      end,
      desc = "debug: step out",
    },

    -- Breakpoints
    {
      mode = "n",
      lhs = "<Leader>db",
      rhs = function()
        require("dap").toggle_breakpoint()
      end,
      desc = "debug: toggle breakpoint",
    },
    {
      mode = "n",
      lhs = "<Leader>dx",
      rhs = function()
        require("dap").clear_breakpoints()
        M.log("All breakpoints cleared", "info")
      end,
      desc = "debug: clear all breakpoints",
    },

    -- UI and inspection
    {
      mode = "n",
      lhs = "<Leader>du",
      rhs = function()
        require("dapui").toggle()
      end,
      desc = "debug: toggle ui",
    },
    {
      mode = "n",
      lhs = "<Leader>de",
      rhs = function()
        require("dap.ui.widgets").hover()
      end,
      desc = "debug: evaluate expression under cursor",
    },
  }

  -- Register all keybindings
  for _, binding in ipairs(keybindings) do
    vim.keymap.set(binding.mode, binding.lhs, binding.rhs, { desc = binding.desc })
  end
end

-- Safe utility functions for common operations
function M.utils.safe_call(fn, ...)
  local status, result = pcall(fn, ...)
  return status and result or nil
end

function M.utils.safe_trim(str)
  if not str then return "" end
  if type(vim.fn.trim) == "function" then
    return vim.fn.trim(str)
  else
    return str:gsub("^%s*(.-)%s*$", "%1")
  end
end

-- Find a working Python path for debugging
function M.adapters.find_python_path()
  -- Handle testing environment
  if _G._TEST_ENV then
    return "/usr/bin/python3"
  end

  local safe_call = M.utils.safe_call
  local safe_trim = M.utils.safe_trim

  -- Method 1: Try pyenv which python (with error checking)
  local pyenv_path
  if type(vim.fn.system) == "function" then
    pyenv_path = safe_call(function() 
      return safe_trim(vim.fn.system("pyenv which python 2>/dev/null"))
    end)
    if pyenv_path and pyenv_path ~= "" and vim.fn.executable and vim.fn.executable(pyenv_path) == 1 then
      return pyenv_path
    end
  end
  
  -- Method 2: Try direct path to current pyenv Python
  local pyenv_root = "~/.pyenv"
  if type(os) == "table" and type(os.getenv) == "function" and os.getenv("PYENV_ROOT") then
    pyenv_root = os.getenv("PYENV_ROOT")
  end
  if vim.fn.expand then
    pyenv_root = vim.fn.expand(pyenv_root)
  end
  
  if vim.fn.filereadable then
    local version_path = pyenv_root .. "/version"
    if vim.fn.filereadable(version_path) == 1 and vim.fn.readfile then
      local readfile_result = safe_call(function() return vim.fn.readfile(version_path) end) or {""}
      local current_version = safe_trim(readfile_result[1])
      local direct_path = pyenv_root .. "/versions/" .. current_version .. "/bin/python"
      if vim.fn.executable and vim.fn.executable(direct_path) == 1 then
        return direct_path
      end
    end
  end
  
  -- Method 3: Try system Python
  if vim.fn.exepath then
    local sys_path = vim.fn.exepath("python3")
    if sys_path and sys_path ~= "" then
      return sys_path
    end
    
    -- Method 4: Try system Python (python command)
    sys_path = vim.fn.exepath("python")
    if sys_path and sys_path ~= "" then
      return sys_path
    end
  end
  
  -- Fallback to a common path
  return "/usr/bin/python3"
end

-- Define project-specific debug configurations
function M.config.setup_projects()
  -- Get Python path for DAP configuration
  local python_path = M.adapters.find_python_path()
  M.log("DAP Projects using Python: " .. python_path, "info")

  -- Initialize projects configuration table
  M.projects = {
    -- Default configurations by language
    ["default"] = {
      type = "python",
      request = "attach",
      name = "Default Python Debug",
      connect = { host = "localhost", port = 5678 },
      pathMappings = {
        {
          localRoot = function()
            return vim.fn.getcwd()
          end,
          remoteRoot = "/app",
        },
      },
      justMyCode = false,
      pythonPath = python_path,  -- Add explicit Python path
    },

    -- You can add more project configurations here
    -- Example:
    -- ["my-project"] = {
    --   type = "python",
    --   request = "attach",
    --   name = "My Project Debug",
    --   connect = { host = "localhost", port = 5678 },
    --   pathMappings = {
    --     {
    --       localRoot = vim.fn.getcwd,
    --       remoteRoot = "/app",
    --     },
    --   },
    -- },
  }
end

-- Logging function for user notifications
function M.utils.log(message, level)
  level = level or "info" -- Default level is info
  local prefix = {
    info = "ℹ️ ",
    warn = "⚠️ ",
    error = "❌ ",
    success = "✅ ",
  }

  -- Only log to notify if vim.notify is available
  if vim.notify then
    local levels = {
      info = vim.log.levels.INFO,
      warn = vim.log.levels.WARN,
      error = vim.log.levels.ERROR,
      success = vim.log.levels.INFO,
    }
    vim.notify(message, levels[level] or vim.log.levels.INFO, { title = "DAP Projects" })
  else
    -- Fallback to print with emoji prefix
    print((prefix[level] or "") .. message)
  end
end

-- Module-level log function that forwards to utils.log
function M.log(message, level)
  M.utils.log(message, level)
end

-- Load project configuration based on current directory
function M.load_project_config()
  local current_dir = vim.fn.getcwd()

  -- Skip if already loaded for this directory
  if M.initialized and M.last_loaded_dir == current_dir then
    return true
  end

  M.log("Current directory: " .. current_dir, "info")

  -- Try to find a matching project configuration
  local matched_config, matched_pattern = M.find_matching_config(current_dir)

  if matched_config then
    local project_type = matched_config.type
    require("dap").configurations[project_type] = { matched_config }
    M.log("Loaded DAP config for: " .. matched_pattern, "success")
    M.initialized = true
    M.last_loaded_dir = current_dir
    return true
  end

  -- If no match found, use default configuration if available
  if M.projects["default"] then
    local default_config = M.projects["default"]
    local project_type = default_config.type
    require("dap").configurations[project_type] = { default_config }
    M.log("Using default DAP config", "info")
    M.initialized = true
    M.last_loaded_dir = current_dir
    return true
  end

  -- No matching project found and no default
  M.log("No matching DAP config found for this directory", "warn")
  return false
end

-- Find a matching configuration for the given directory
function M.find_matching_config(directory)
  local directory_lower = directory:lower()

  -- First try direct substring matching
  for pattern, config in pairs(M.projects) do
    -- Skip the default config for now
    if pattern ~= "default" then
      -- Use string.find with plain=true for direct substring matching (case-insensitive)
      if directory_lower:find(pattern:lower(), 1, true) then
        return config, pattern
      end
    end
  end

  -- No match found
  return nil, nil
end

-- Get the DAP status for display in lualine
-- This function is called frequently by lualine, so it should be fast
function M.get_status()
  -- Access dap directly each time to get real-time status
  local ok, dap = pcall(require, "dap")
  if not ok then
    return ""
  end
  
  -- Safety check - don't access dap.session directly as it can cause issues
  local sessions = {}
  local session_count = 0
  
  -- Use pcall for everything to ensure we don't crash if DAP API changes
  if dap.sessions then
    ok, sessions = pcall(function() return dap.sessions() end)
    if ok and type(sessions) == "table" then
      session_count = #sessions
    end
  end
  
  -- Additional safety check to ensure dap.session (old API) isn't giving false positives
  if session_count == 0 and dap.session then
    -- Only count dap.session if it's actually connected and running
    if type(dap.session) == "table" and dap.session.dirty == false and dap.session.capabilities then
      session_count = 1
    end
  end
  
  if session_count > 0 then
    -- Show number of active debug sessions if more than one
    if session_count > 1 then
      return "🐛 DBG(" .. session_count .. ")"
    else
      return "🐛 DBG"
    end
  end
  
  return ""
end

-- Check if there are multiple active debug sessions
function M.check_multiple_sessions()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return false
  end
  
  -- Safety wrapper to avoid errors
  local function safe_call(fn, ...)
    local status, result = pcall(fn, ...)
    return status and result or nil
  end
  
  -- Safely check for sessions using the same logic as get_status
  local sessions = {}
  local session_count = 0
  
  if dap.sessions then
    sessions = safe_call(function() return dap.sessions() end) or {}
    session_count = #sessions
  end
  
  -- Additional safety check to ensure dap.session (old API) isn't giving false positives
  if session_count == 0 and dap.session then
    -- Only count dap.session if it's actually connected and running
    if type(dap.session) == "table" and dap.session.dirty == false and dap.session.capabilities then
      session_count = 1
    end
  end
  
  if session_count > 1 then
    M.log("Warning: " .. session_count .. " active debug sessions detected", "warn")
    return true
  end
  
  return false
end

-- Check if debugpy is installed and install if needed
function M.adapters.ensure_debugpy()
  -- Handle testing environment
  if _G._TEST_ENV then
    return true
  end
  
  local python_path = M.adapters.find_python_path()
  
  -- Check if os.execute is available (won't be in test env)
  if type(os) ~= "table" or type(os.execute) ~= "function" then
    M.log("Cannot check for debugpy (os.execute not available)", "warn")
    return true
  end
  
  -- Check if debugpy is installed
  local check_cmd = python_path .. " -c \"import debugpy\" 2>/dev/null"
  local debugpy_installed = os.execute(check_cmd) == 0
  
  if not debugpy_installed then
    M.log("debugpy not found. Attempting to install...", "warn")
    
    -- Try to install debugpy
    local install_cmd = python_path .. " -m pip install debugpy"
    local install_result = os.execute(install_cmd)
    
    if install_result == 0 then
      M.log("Successfully installed debugpy", "success")
      return true
    else
      M.log("Failed to install debugpy. Please install it manually: pip install debugpy", "error")
      return false
    end
  end
  
  return true
end

-- Configure the Python DAP adapter
function M.adapters.setup_python()
  -- Skip actual adapter setup in test environment
  if _G._TEST_ENV then
    return
  end

  local ok, dap = pcall(require, "dap")
  if not ok then
    M.log("DAP not available for adapter setup", "error")
    return
  end

  -- Get the Python path
  local python_path = M.adapters.find_python_path()
  
  -- Ensure debugpy is installed
  local debugpy_installed = M.adapters.ensure_debugpy()
  if not debugpy_installed then
    M.log("Warning: Python adapter may not work properly without debugpy", "warn")
  else
    M.log("Setting up Python adapter with: " .. python_path, "info")
  end

  -- Setup the debugpy adapter
  dap.adapters.python = {
    type = "executable",
    command = python_path,
    args = { "-m", "debugpy.adapter" }
  }
  
  -- For compatibility with nvim-dap-python, also set 'debugpy' adapter
  dap.adapters.debugpy = dap.adapters.python
end

-- Setup DAP event listeners to track attachment status
function M.config.setup_listeners()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  
  -- When a DAP session initializes - just warn about multiple sessions
  if dap.listeners and dap.listeners.after then
    dap.listeners.after.event_initialized["dap_projects_status"] = function()
      vim.defer_fn(function()
        M.check_multiple_sessions()
      end, 100)
    end
  end
end

-- Clean DAP state on startup to avoid stale sessions
function M.utils.clean_dap_state()
  -- Skip in test environment
  if _G._TEST_ENV then
    return
  end

  -- Safely check if DAP exists
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  
  local safe_call = M.utils.safe_call

  -- Clean up any stale session state
  if dap.session ~= nil then
    dap.session = nil
  end
  
  -- Handle session table if it exists (newer DAP API)
  if dap.sessions then
    local all_sessions = safe_call(function() return dap.sessions() end) or {}
    for _, session in pairs(all_sessions) do
      safe_call(function() session:close() end)
    end
    
    -- Clear internal sessions data if possible
    if type(dap._sessions) == "table" then
      for k in pairs(dap._sessions) do
        dap._sessions[k] = nil
      end
    end
  end
  
  -- Force a reload of DAP if possible
  if package and package.loaded then
    package.loaded["dap"] = nil
  end
  
  -- Explicitly require DAP again to ensure clean state
  ok, dap = pcall(require, "dap")
end

-- Initialize the module with all required setup functions
function M.init()
  -- Reset DAP state to ensure a clean startup
  M.utils.clean_dap_state()
  
  -- Setup configs and adapters
  M.config.setup_projects()
  M.adapters.setup_python()
  M.config.setup_commands_and_keybindings()
  M.config.setup_listeners()
  M.load_project_config()
  
  -- Log ready status
  M.log("DAP Projects module initialized", "success")
end

-- Auto-initialize when the module is loaded
M.init()

return M
