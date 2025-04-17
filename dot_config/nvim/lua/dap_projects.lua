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

local M = {}

-- State tracking variables
M.initialized = false
M.last_loaded_dir = nil

-- Setup commands and keybindings
local function setup_commands_and_keybindings()
  -- Create user commands
  vim.api.nvim_create_user_command("DapAttachDebugger", function()
    require("dap").continue()
    M.log("Attached to debugger", "success")
  end, { desc = "Attach to running debugger" })

  vim.api.nvim_create_user_command("DapClearBreakpoints", function()
    require("dap").clear_breakpoints()
    M.log("All breakpoints cleared", "info")
  end, { desc = "Clear all breakpoints" })

  -- Define keybindings with consistent descriptions
  local keybindings = {
    -- Basic debugging operations
    {
      mode = "n",
      lhs = "<Leader>da",
      rhs = function()
        require("dap").continue()
        M.log("Attached to debugger", "success")
      end,
      desc = "debug: attach to debugger",
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

-- Project configurations
local function setup_project_configs()
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
    },

    -- You can add more project configurations here
  }
end

-- Helper function for logging
function M.log(message, level)
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

-- Initialize the module
local function init()
  setup_project_configs()
  setup_commands_and_keybindings()
  M.load_project_config()
end

-- Auto-initialize when the module is loaded
init()

return M
