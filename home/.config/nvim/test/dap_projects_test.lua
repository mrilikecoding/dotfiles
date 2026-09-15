-- Behavior tests for lua/debugging/projects.lua: matching and loading DAP configs.
-- The module is loaded in the mock sandbox, where vim.fn.getcwd() returns
-- "/default/path" and require("dap") returns the mock dap object.
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
  test_find_matching_config_by_substring = function()
    projects = load_module()
    local config, pattern = projects.find_matching_config("/path/to/commercial-api/src")
    assert(config ~= nil, "Should find a matching config")
    assert(pattern == "commercial-api", "Should report which pattern matched")
    assert(config.name == "Commercial API", "Should return that pattern's config")
  end,

  test_find_matching_config_is_case_insensitive = function()
    projects = load_module()
    local config, pattern = projects.find_matching_config("/Work/PLATFORM-API/lib")
    assert(config ~= nil and pattern == "platform-api", "Matching should ignore case")
  end,

  test_find_matching_config_returns_nil_for_unknown_directory = function()
    projects = load_module()
    local config, pattern = projects.find_matching_config("/some/unknown/project")
    assert(config == nil and pattern == nil, "Unknown directories should not match")
  end,

  test_added_config_is_matchable = function()
    projects = load_module()
    projects.configs["my-service"] = { type = "python", request = "attach", name = "My Service" }
    local config, pattern = projects.find_matching_config("/repos/my-service/app")
    assert(config ~= nil and pattern == "my-service", "Configs added at runtime should match")
  end,

  test_load_project_config_without_match_returns_false = function()
    projects = load_module()
    -- sandbox cwd is /default/path, which matches no config
    local result = projects.load_project_config()
    assert(result == false, "No match should return false")
    assert(projects.initialized == false, "No match should leave the module uninitialized")
    assert(projects.last_loaded_dir == nil, "No match should not record a directory")
  end,

  test_load_project_config_with_match_returns_true = function()
    projects = load_module()
    local commercial = projects.configs["commercial-api"]
    projects.find_matching_config = function()
      return commercial, "commercial-api"
    end
    local result = projects.load_project_config()
    assert(result == true, "A match should return true")
    assert(projects.initialized == true, "A match should mark the module initialized")
    assert(projects.last_loaded_dir == "/default/path", "The matched cwd should be recorded")
  end,

  test_load_project_config_is_idempotent_for_same_directory = function()
    projects = load_module()
    local calls = 0
    local commercial = projects.configs["commercial-api"]
    projects.find_matching_config = function()
      calls = calls + 1
      return commercial, "commercial-api"
    end
    assert(projects.load_project_config() == true, "first load should succeed")
    assert(projects.load_project_config() == true, "second load should succeed")
    assert(calls == 1, "second load for the same cwd should short-circuit without re-matching")
  end,
}

return M
