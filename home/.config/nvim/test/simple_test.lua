-- Basic shape tests for lua/debugging/projects.lua (the DAP project registry)
local mock = require("test.helpers.mock")
local M = {}

local projects = nil

function M.before_each()
  mock.reset()
  projects = nil
end

function M.after_each()
  collectgarbage("collect")
end

local function load_module()
  local loaded = mock.load_with_sandbox("debugging.projects")
  assert(loaded, "Failed to load debugging.projects module")
  return loaded
end

M.tests = {
  test_module_is_table = function()
    projects = load_module()
    assert(type(projects) == "table", "Module should be a table")
  end,

  test_configs_table_exists = function()
    projects = load_module()
    assert(type(projects.configs) == "table", "configs table should exist")
    assert(projects.configs["commercial-api"] ~= nil, "commercial-api config should exist")
    assert(projects.configs["platform-api"] ~= nil, "platform-api config should exist")
  end,

  test_public_functions_exist = function()
    projects = load_module()
    assert(type(projects.find_matching_config) == "function", "find_matching_config should exist")
    assert(type(projects.load_project_config) == "function", "load_project_config should exist")
  end,

  test_initial_state = function()
    projects = load_module()
    assert(projects.initialized == false, "module should start uninitialized")
    assert(projects.last_loaded_dir == nil, "no directory should be recorded before a load")
  end,

  test_commercial_api_config_shape = function()
    projects = load_module()
    local config = projects.configs["commercial-api"]
    assert(config.type == "python", "commercial-api should be a python config")
    assert(config.request == "attach", "commercial-api should attach")
    assert(type(config.pathMappings) == "table", "commercial-api should define pathMappings")
    assert(type(config.pathMappings[1].localRoot) == "function", "localRoot should be resolved lazily")
    assert(config.pathMappings[1].remoteRoot == "/app", "remoteRoot should be the container path")
  end,

  test_platform_api_config_is_not_machine_specific = function()
    projects = load_module()
    local config = projects.configs["platform-api"]
    assert(config.type == "ruby", "platform-api should be a ruby config")
    assert(config.localfsMap:sub(1, 10) == "/home/app:", "localfsMap should start with the container root")
    assert(not config.localfsMap:find("/Users/", 1, true), "localfsMap must not hardcode a user's home")
  end,
}

return M
