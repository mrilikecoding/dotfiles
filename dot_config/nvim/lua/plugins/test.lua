return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/fixcursorhold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local neotest = require("neotest") -- define this first!
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_stopped["reuse_windows"] = function(_, body)
      local filename = body.frame and body.frame.source and body.frame.source.path
      if filename then
        -- get the current window
        local current_win = vim.api.nvim_get_current_win()
        -- get all windows that aren't the test window
        local available_wins = {}
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if not buf_name:match("_test%.py$") and not buf_name:match("test_.*%.py$") then
            table.insert(available_wins, win)
          end
        end

        -- use the first non-test window found
        if #available_wins > 0 then
          vim.api.nvim_set_current_win(available_wins[1])
          vim.cmd("edit " .. filename)
          -- return to the original window
          vim.api.nvim_set_current_win(current_win)
        end
      end
    end

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
    --
    vim.api.nvim_set_hl(0, "dapbreakpoint", { fg = "#e51a4c" }) -- ruby red color
    vim.fn.sign_define("dapbreakpoint", {
      text = "◉",
      texthl = "dapbreakpoint",
      linehl = "",
      numhl = "",
    })
    -- conditional breakpoint - using a different color and symbol
    vim.api.nvim_set_hl(0, "dapbreakpointcondition", { fg = "#f5c747" }) -- golden yellow
    vim.fn.sign_define("dapbreakpointcondition", {
      text = "◈", -- diamond with dot
      texthl = "dapbreakpointcondition",
      linehl = "",
      numhl = "",
    })

    -- automatically open ui when debugging starts
    -- allow live introspection
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      -- find and set modifiable on the repl buffer
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "dap-repl" then
          vim.opt.modifiable = true

          -- focus the repl window
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf then
              vim.api.nvim_set_current_win(win)
              vim.cmd("startinsert") -- enter insert mode
              break
            end
          end
        end
      end
    end

    -- dap for python
    local python_path = vim.fn.trim(vim.fn.system("pyenv which python"))
    require("dap-python").setup(python_path)

    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          -- extra arguments for pytest
          args = {
            "--verbose",
            "-vv",
          },
          env = {
            pytest_addopts = "--sugar-no-header", -- optional: removes the pytest-sugar header
          },
          -- runner to use. will try to detect python test runner
          runner = "pytest",
          -- python path
          python = vim.fn.trim(vim.fn.system("pyenv which python")),

          -- root patterns for package detection
          root_patterns = { "pyproject.toml", "setup.cfg", "setup.py", "pytest.ini" },

          dap = { justmycode = false }, -- include non-user code in debugging
        }),
        output = {
          open_on_run = false,
        },
      },
      icons = {
        passed = "●", -- green dot
        failed = "●", -- red dot
        running = "◍",
        skipped = "○",
      },
      highlights = {
        passed = "neotestpassed", -- we'll define these highlights below
        failed = "neotestfailed",
        running = "neotestrunning",
        skipped = "neotestskipped",
      },
    })
    vim.cmd([[
      highlight neotestpassed ctermfg=green guifg=#00ff00
      highlight neotestfailed ctermfg=red guifg=#ff0000
      highlight neotestrunning ctermfg=yellow guifg=#ffff00
      highlight neotestskipped ctermfg=gray guifg=#808080
      ]])

    -- test runner keymaps
    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "run test file" })

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open()
    end, { desc = "show test output" })

    vim.keymap.set("n", "<leader>tp", function()
      require("neotest").output_panel.toggle()
    end, { desc = "toggle test output panel" })

    vim.keymap.set("n", "<leader>tF", function()
      neotest.run.run(vim.fn.getcwd())
      neotest.output_panel.toggle()
    end, { desc = "run all tests in project" })

    -- debug keymaps
    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "debug nearest test" })
  end,
}
