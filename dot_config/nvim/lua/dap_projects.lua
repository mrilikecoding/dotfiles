-- ~/.config/nvim/lua/dap_projects.lua
local M = {}

-- State tracking variables
M.initialized = false
M.last_loaded_dir = nil

-- Create a command to attach to debugger
vim.api.nvim_create_user_command("DapAttachDebugger", function()
  require("dap").continue()
  print("Attached to debugger")
end, {})
-- Keybinding for attaching to debugger
vim.keymap.set("n", "<Leader>da", function()
  require("dap").continue()
  print("Attached to debugger")
end, { desc = "Attach to debugger" })

-- Create a command to clear all breakpoints
vim.api.nvim_create_user_command("DapClearBreakpoints", function()
  require("dap").clear_breakpoints()
  print("All breakpoints cleared")
end, {})

-- Keybinding for clearing breakpoints
vim.keymap.set("n", "<Leader>dx", function()
  require("dap").clear_breakpoints()
  print("All breakpoints cleared")
end, { desc = "debug: clear all breakpoints" })

vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "debug: toggle ui" })

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "debug: continue" })

vim.keymap.set("n", "<leader>ds", function()
  require("dap").step_over()
end, { desc = "debug: step over" })

vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "debug: step into" })

vim.keymap.set("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "debug: step out" })

-- Map a key to evaluate expressions
vim.keymap.set("n", "<Leader>de", function()
  require("dap.ui.widgets").hover()
end, { desc = "debug: evaluate expression under cursor" })

-- set breakpoints
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "toggle breakpoint" })

M.projects = {
  ["commercial-api"] = {
    type = "python",
    request = "attach",
    name = "Commercial API",
    connect = { host = "localhost", port = 5678 },
    pathMappings = {
      {
        localRoot = vim.fn.expand("/Users/nategreen/Documents/Development/jv-dev-kit/services/commercial-api"),
        remoteRoot = "/app",
      },
    },
    justMyCode = false,
  },
  -- Default configuration
  ["default"] = {
    type = "python",
    request = "attach",
    name = "Default Python Debug",
    connect = { host = "localhost", port = 5678 },
    pathMappings = {
      {
        localRoot = vim.fn.getcwd(),
        remoteRoot = "/app",
      },
    },
    justMyCode = false,
  },
}

function M.load_project_config()
  local current_dir = vim.fn.getcwd()

  -- Skip if already loaded for this directory
  if M.initialized and M.last_loaded_dir == current_dir then
    return true
  end

  print("Current directory: " .. current_dir)

  for pattern, config in pairs(M.projects) do
    -- Use string.find with plain=true for direct substring matching
    if current_dir:find(pattern, 1, true) then
      require("dap").configurations.python = { config }
      print("✅ Loaded DAP config for: " .. pattern)
      M.initialized = true
      M.last_loaded_dir = current_dir
      return true
    end
    if pattern ~= "default_python" and pattern ~= "default_ruby" and pattern ~= "rails" then
      -- Check if the pattern is in the path (case-insensitive)
      if current_dir:lower():match(pattern:lower()) then
        local project_type = config.type
        require("dap").configurations[project_type] = { config }
        print("✅ Loaded DAP config for: " .. pattern)
        M.initialized = true
        M.last_loaded_dir = current_dir
        return true
      end
    end
  end

  -- No matching project found
  print("⚠️ No matching DAP config found for this directory")
  return false
end

-- Auto-call the function when the module is loaded
M.load_project_config()

return M
