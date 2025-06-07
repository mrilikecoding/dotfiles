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
    -- Python projects
    ["commercial-api"] = {
      type = "python",
      request = "attach",
      name = "Commercial API",
      connect = { host = "localhost", port = 5678 },
      pathMappings = {
        {
          localRoot = function()
            -- Try to find the project root
            local current_dir = vim.fn.getcwd()
            if current_dir:find("commercial-api", 1, true) then
              return current_dir
            end
            -- Fallback to the original path if needed
            return vim.fn.expand("~/Documents/Development/jv-dev-kit/services/commercial-api")
          end,
          remoteRoot = "/app",
        },
      },
      justMyCode = false,
    },

    -- Platform API project
    ["platform-api"] = {
      type = "ruby",
      request = "attach",
      name = "Platform API",
      port = 38698,
      host = "0.0.0.0",
      pathMappings = {
        -- Try multiple path mappings to cover possible variations
        ["/Users/nategreen/Documents/Development/jv-dev-kit/services/platform-api"] = "/home/app",
        [vim.fn.expand("$HOME/Documents/Development/jv-dev-kit/services/platform-api")] = "/home/app",
        ["/Users/nategreen/Documents/Development/jv-dev-kit/services/platform-api/"] = "/home/app/",
      },
      localfs = true,
      wait_for_ready = true,
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

-- Function to get DAP status for statusline integration
function M.get_status()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return ""
  end
  
  local sessions = dap.sessions()
  if #sessions > 0 then
    return "🐞 " .. #sessions
  end
  return ""
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

-- Initialize nvim-dap-ruby if available
local function setup_ruby_dap()
  local has_dap_ruby, dap_ruby = pcall(require, "dap-ruby")
  if has_dap_ruby then
    -- Set up Ruby DAP adapter
    dap_ruby.setup()

    -- Create a direct command to force the Ruby Docker config
    vim.api.nvim_create_user_command("RubyDebugDocker", function()
      -- Force load the platform-api config if we're in that directory
      local matched_config, _ = M.find_matching_config(vim.fn.getcwd())
      if matched_config and matched_config.type == "ruby" then
        require("dap").run(matched_config)
      else
        -- Use the platform-api config directly if no match
        require("dap").run(M.projects["platform-api"])
      end
      M.log("Loaded Ruby Docker debugger configuration", "success")
    end, { desc = "Start Ruby debugging in Docker" })

    -- Create a command to update Ruby path mappings on the fly
    vim.api.nvim_create_user_command("RubyUpdatePathMapping", function(opts)
      local args = opts.fargs
      if #args ~= 2 then
        M.log("Usage: RubyUpdatePathMapping <local_path> <remote_path>", "info")
        return
      end

      -- Update all Ruby configurations
      for pattern, config in pairs(M.projects) do
        if config.type == "ruby" then
          M.projects[pattern].pathMappings = {
            [args[1]] = args[2],
          }
        end
      end

      -- Immediately reload if we're in a Ruby project
      local matched_config, _ = M.find_matching_config(vim.fn.getcwd())
      if matched_config and matched_config.type == "ruby" then
        require("dap").configurations.ruby = { matched_config }
        M.log("Updated and reloaded Ruby path mapping: " .. args[1] .. " → " .. args[2], "success")
      else
        M.log("Updated Ruby path mapping: " .. args[1] .. " → " .. args[2], "success")
      end
    end, { nargs = "*", desc = "Update Ruby debug path mapping", complete = "file" })
  else
    M.log("nvim-dap-ruby not found, Ruby debugging might not work properly", "warn")
  end
end

-- Define module-level setup functions based on internal functions
local function setup_project_configs()
  M.config.setup_projects()
end

local function setup_commands_and_keybindings()
  M.config.setup_commands_and_keybindings()
end

local function setup_listeners()
  M.config.setup_listeners()
end

-- Auto-initialize when the module is loaded
-- Define init() function at module level for external access
function M.init()
  -- Reset DAP state to ensure a clean startup
  if M.utils.clean_dap_state then
    M.utils.clean_dap_state()
  end
  
  -- Setup configs and adapters
  M.config.setup_projects()
  M.config.setup_commands_and_keybindings()
  if M.config.setup_listeners then
    M.config.setup_listeners()
  end
  
  -- Setup Ruby DAP adapter if available
  setup_ruby_dap()
  M.load_project_config()
  
  -- Log ready status
  M.log("DAP Projects module initialized", "success")
end

-- Call init on module load
M.init()

return M
