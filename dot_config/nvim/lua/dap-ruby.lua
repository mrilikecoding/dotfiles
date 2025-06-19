-- ~/.config/nvim/lua/dap-ruby.lua
--
-- A Ruby Debug Adapter Protocol integration with path mapping support
-- Inspired by nvim-dap-python's approach to path mapping
--
-- Usage:
--   require('dap-ruby').setup({
--     -- Ruby path (optional, will try to detect if not provided)
--     ruby_path = "/path/to/ruby",
--     -- Default adapter options
--     adapter_options = {
--       port = 38698,
--       command = "bundle",
--       args = { "exec", "rdbg", "-n", "--open", "--port", "38698" }
--     },
--     -- Path mappings between local and remote paths (for container/remote debugging)
--     path_mappings = {
--       {
--         localRoot = "/local/path",
--         remoteRoot = "/remote/path"
--       }
--     }
--   })

local M = {}
local dap = require("dap")

-- Store the module config to use across functions
M.config = {
  ruby_path = nil,
  adapter_options = {
    port = 38698,
    command = "bundle",
    args = { "exec", "rdbg", "-n", "--open", "--port", "38698" },
  },
  path_mappings = {},
}

---@class dap-ruby.PathMapping
---@field localRoot string Local path
---@field remoteRoot string Corresponding remote path

---@class dap-ruby.Config
---@field pathMappings dap-ruby.PathMapping[]|nil Map of local and remote paths
---@field port number|nil Port to connect to
---@field command string|nil Command to execute debug server
---@field args string[]|nil Command arguments

-- Platform detection helpers
local function is_windows()
  return vim.fn.has("win32") == 1
end

local function is_mac()
  return vim.fn.has("mac") == 1
end

-- Helper to find Ruby executable
local function find_ruby_path()
  -- Check RVM first
  local handle = io.popen("rvm current 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("%s+$", "")
    handle:close()
    if result ~= "" then
      local rvm_ruby = os.getenv("HOME") .. "/.rvm/rubies/" .. result .. "/bin/ruby"
      if vim.fn.filereadable(rvm_ruby) == 1 then
        return rvm_ruby
      end
    end
  end

  -- Check RBENV next
  local rbenv_root = os.getenv("RBENV_ROOT")
  if not rbenv_root then
    rbenv_root = os.getenv("HOME") .. "/.rbenv"
  end

  if vim.fn.isdirectory(rbenv_root) == 1 then
    local rbenv_ruby_version_path = rbenv_root .. "/version"
    if vim.fn.filereadable(rbenv_ruby_version_path) == 1 then
      local version_file = io.open(rbenv_ruby_version_path, "r")
      if version_file then
        local ruby_version = version_file:read("*line"):gsub("%s+$", "")
        version_file:close()
        local ruby_path = rbenv_root .. "/versions/" .. ruby_version .. "/bin/ruby"
        if vim.fn.filereadable(ruby_path) == 1 then
          return ruby_path
        end
      end
    end
  end

  -- Fall back to system ruby
  return vim.fn.exepath("ruby")
end

-- Get ruby path using either provided path or autodetection
local function get_ruby_path()
  if M.config.ruby_path then
    return M.config.ruby_path
  end
  return find_ruby_path()
end

-- Configuration enrichment function to handle path mappings and other configs
---@param config dap-ruby.Config
---@param on_config fun(config: dap-ruby.Config)
local function enrich_config(config, on_config)
  -- Add path mappings from the module config if not specified in the individual config
  if not config.pathMappings and #M.config.path_mappings > 0 then
    config.pathMappings = M.config.path_mappings
  end

  on_config(config)
end

-- Setup the Ruby debug adapter
function M.setup(user_config)
  -- Merge user config with defaults
  if user_config then
    if user_config.ruby_path then
      M.config.ruby_path = user_config.ruby_path
    end

    if user_config.adapter_options then
      for k, v in pairs(user_config.adapter_options) do
        M.config.adapter_options[k] = v
      end
    end

    if user_config.path_mappings then
      M.config.path_mappings = user_config.path_mappings
    end
  end

  -- Configure DAP
  dap.adapters.ruby = {
    type = "server",
    host = "127.0.0.1",
    port = M.config.adapter_options.port or 38698,
    executable = {
      command = M.config.adapter_options.command or "bundle",
      args = M.config.adapter_options.args or { "exec", "rdbg", "-n", "--open", "--port", "38698" },
    },
    enrich_config = enrich_config,
    options = {
      source_filetype = "ruby",
      initialize_timeout_sec = 20,
    },
    before_start = function(conf)
      -- Check if any path mappings are defined
      if M.config.path_mappings and #M.config.path_mappings > 0 then
        vim.notify("Ruby DAP: Using path mappings", vim.log.levels.INFO)
      end
    end,
    before_continue = function(conf)
      -- Log configuration details for debugging purposes
      vim.notify("Ruby DAP: Starting debug session", vim.log.levels.INFO)
    end,
  }

  -- dap.configurations.ruby = {
  --   {
  --     type = "ruby",
  --     name = "Debug Ruby",
  --     request = "attach",
  --     port = M.config.adapter_options.port or 38698,
  --   },
  -- }
  --
  dap.configurations.ruby = {
    {
      type = "ruby",
      request = "attach",
      name = "Debug Ruby (Default)",
      port = M.config.adapter_options.port or 38698,
      localfs = true,
    },
  }

  -- Log the ruby path we're using
  local ruby_path = get_ruby_path()
  vim.notify("DAP Ruby using: " .. ruby_path, vim.log.levels.INFO)
end

-- Debug current test file
function M.debug_test_file()
  local path = vim.fn.expand("%:p")

  -- Check if file is a test
  if not (path:match("_spec%.rb$") or path:match("_test%.rb$")) then
    vim.notify("Current file is not a test file", vim.log.levels.ERROR)
    return
  end

  -- Configure debug adapter for the test file
  local config = {
    type = "ruby",
    name = "Debug Test File",
    request = "attach",
    port = M.config.adapter_options.port,
    program = path,
    localfs = true,
  }

  -- Add path mappings if configured
  if #M.config.path_mappings > 0 then
    config.pathMappings = M.config.path_mappings
  end

  -- Start debugging
  dap.run(config)
end

-- Debug current file
function M.debug_current_file()
  local path = vim.fn.expand("%:p")

  -- Configure debug adapter for the file
  local config = {
    type = "ruby",
    name = "Debug Current File",
    request = "attach",
    port = M.config.adapter_options.port,
    program = path,
    localfs = true,
  }

  -- Add path mappings if configured
  if #M.config.path_mappings > 0 then
    config.pathMappings = M.config.path_mappings
  end

  -- Start debugging
  dap.run(config)
end

-- Set up module with defaults if not explicitly configured
if not M.setup_complete then
  M.setup()
  M.setup_complete = true
end

return M
