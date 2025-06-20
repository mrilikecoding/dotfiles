-- Complete testing configuration for Python and Ruby
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/fixcursorhold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    -- Language-specific dependencies
    "nvim-neotest/neotest-python",
    "mfussenegger/nvim-dap-python",
    -- "olimorris/neotest-rspec",
  },
  config = function()
    local neotest = require("neotest")
    local dap = require("dap")
    local dapui = require("dapui")

    -- DAP UI configuration
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
    })

    -- Breakpoint styling
    vim.api.nvim_set_hl(0, "dapbreakpoint", { fg = "#e51a4c" })
    vim.fn.sign_define("dapbreakpoint", {
      text = "◉",
      texthl = "dapbreakpoint",
      linehl = "",
      numhl = "",
    })
    vim.api.nvim_set_hl(0, "dapbreakpointcondition", { fg = "#f5c747" })
    vim.fn.sign_define("dapbreakpointcondition", {
      text = "◈",
      texthl = "dapbreakpointcondition",
      linehl = "",
      numhl = "",
    })

    -- Window reuse logic for debugging
    dap.listeners.after.event_stopped["reuse_windows"] = function(_, body)
      local filename = body.frame and body.frame.source and body.frame.source.path
      if filename then
        local current_win = vim.api.nvim_get_current_win()
        local available_wins = {}
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          -- Modified pattern to handle both Python and Ruby test files
          if
            not buf_name:match("_test%.py$")
            and not buf_name:match("test_.*%.py$")
            and not buf_name:match("_spec%.rb$")
            and not buf_name:match("_test%.rb$")
          then
            table.insert(available_wins, win)
          end
        end

        if #available_wins > 0 then
          vim.api.nvim_set_current_win(available_wins[1])
          vim.cmd("edit " .. filename)
          vim.api.nvim_set_current_win(current_win)
        end
      end
    end

    -- Configure Python DAP with more robust path detection
    local python_path

    -- Try multiple methods to find Python path
    local function get_python_path()
      -- Method 1: Try pyenv which python (with error checking)
      local pyenv_path = vim.fn.trim(vim.fn.system("pyenv which python 2>/dev/null"))
      if pyenv_path ~= "" and vim.fn.executable(pyenv_path) == 1 then
        return pyenv_path
      end

      -- Method 2: Try direct path to current pyenv Python
      local pyenv_root = os.getenv("PYENV_ROOT") or vim.fn.expand("~/.pyenv")
      local version_path = pyenv_root .. "/version"
      if vim.fn.filereadable(version_path) == 1 then
        local current_version = vim.fn.trim(vim.fn.readfile(version_path)[1])
        local direct_path = pyenv_root .. "/versions/" .. current_version .. "/bin/python"
        if vim.fn.executable(direct_path) == 1 then
          return direct_path
        end
      end

      -- Method 3: Try system Python
      local sys_path = vim.fn.exepath("python3")
      if sys_path ~= "" then
        return sys_path
      end

      -- Method 4: Try system Python (python command)
      sys_path = vim.fn.exepath("python")
      if sys_path ~= "" then
        return sys_path
      end

      -- Fallback to a common path
      return "/usr/bin/python3"
    end

    python_path = get_python_path()

    -- Log the path we're using
    vim.notify("DAP using Python: " .. python_path, vim.log.levels.INFO)

    -- Setup with error handling
    local status, err = pcall(function()
      require("dap-python").setup(python_path)
    end)

    if not status then
      vim.notify("Error setting up Python DAP: " .. tostring(err), vim.log.levels.ERROR)
    end

    -- -- Configure Ruby DAP
    -- dap.adapters.ruby = {
    --   type = "server",
    --   host = "127.0.0.1",
    --   port = 38698,
    --   executable = {
    --     command = "bundle",
    --     args = { "exec", "rdbg", "-n", "--open", "--port", "38698" },
    --   },
    -- }
    --
    -- dap.configurations.ruby = {
    --   {
    --     type = "ruby",
    --     name = "Debug Ruby Tests",
    --     request = "attach",
    --     port = 38698,
    --     localfs = true,
    --     waiting = 1000,
    --   },
    -- }
    --
    -- Python config
    local python_config = {
      -- Arguments for pytest
      args = {
        "--verbose",
        "-vv",
      },
      -- Environment variables for pytest
      env = {
        pytest_addopts = "--sugar-no-header", -- optional: removes the pytest-sugar header
      },
      -- Runner to use
      runner = "pytest",
      -- Root patterns for package detection
      root_patterns = {
        "pyproject.toml",
        "setup.cfg",
        "setup.py",
        "pytest.ini",
      },
      -- DAP settings
      dap = {
        justmycode = false, -- include non-user code in debugging
      },
    }

    -- -- Ruby config
    -- local ruby_config = {
    --   -- File pattern for RSpec and Rails tests
    --   rspec_files = {
    --     -- Default RSpec patterns
    --     "spec/(.*)_spec.rb",
    --     "spec/(.*)/(.*)_spec.rb",
    --     -- Rails test patterns
    --     "test/(.*)_test.rb",
    --     "test/(.*)/(.*)_test.rb",
    --   },
    --
    --   -- Transform test results
    --   results_path = "tmp/rspec.output.json",
    --
    --   -- Test root patterns
    --   root_patterns = {
    --     ".rspec",
    --     ".gitlab-ci.yml",
    --     ".github",
    --     "Gemfile",
    --   },
    --
    --   -- Automatically detect Rails projects
    --   is_rails_project = function()
    --     local path = vim.fn.getcwd() .. "/config/application.rb"
    --     return vim.fn.filereadable(path) == 1
    --   end,
    --
    --   -- Configure DAP settings
    --   dap = {
    --     type = "ruby",
    --     request = "attach",
    --   },
    -- }
    --
    -- Neotest setup with all adapters
    neotest.setup({
      -- Add adapters
      adapters = {
        -- Python adapter
        require("neotest-python")({
          args = python_config.args,
          env = python_config.env,
          runner = python_config.runner,
          python = python_path,
          root_patterns = python_config.root_patterns,
          dap = python_config.dap,
        }),

        -- -- Ruby adapter
        -- require("neotest-rspec")({
        --   rspec_files = ruby_config.rspec_files,
        --   results_path = ruby_config.results_path,
        --   root_patterns = ruby_config.root_patterns,
        --   is_rails_project = ruby_config.is_rails_project,
        --   dap = ruby_config.dap,
        -- }),
      },

      -- Common test icons and highlights
      icons = {
        passed = "●",
        failed = "●",
        running = "◍",
        skipped = "○",
      },
      highlights = {
        passed = "neotestpassed",
        failed = "neotestfailed",
        running = "neotestrunning",
        skipped = "neotestskipped",
      },
      output = {
        open_on_run = false,
      },
    })

    -- Set up highlight groups
    vim.cmd([[
      highlight neotestpassed ctermfg=green guifg=#00ff00
      highlight neotestfailed ctermfg=red guifg=#ff0000
      highlight neotestrunning ctermfg=yellow guifg=#ffff00
      highlight neotestskipped ctermfg=gray guifg=#808080
    ]])

    -- Common keymaps for all test types
    vim.keymap.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "run test file" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, { desc = "toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open()
    end, { desc = "show test output" })

    vim.keymap.set("n", "<leader>tp", function()
      neotest.output_panel.toggle()
    end, { desc = "toggle test output panel" })

    vim.keymap.set("n", "<leader>tF", function()
      neotest.run.run(vim.fn.getcwd())
      neotest.output_panel.toggle()
    end, { desc = "run all tests in project" })

    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "debug nearest test" })
  end,
}
