return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local neotest = require("neotest") -- Define this first!
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_stopped["reuse_windows"] = function(_, body)
      local filename = body.frame and body.frame.source and body.frame.source.path
      if filename then
        -- Try to find existing window with this buffer
        local found = false
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_name(buf) == filename then
            vim.api.nvim_set_current_win(win)
            found = true
            break
          end
        end

        -- If window not found, open in new buffer
        if not found then
          vim.cmd("edit " .. filename)
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
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E51A4C" }) -- Ruby red color
    vim.fn.sign_define("DapBreakpoint", {
      text = "◉",
      texthl = "DapBreakpoint",
      linehl = "",
      numhl = "",
    })
    -- Conditional breakpoint - using a different color and symbol
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#F5C747" }) -- Golden yellow
    vim.fn.sign_define("DapBreakpointCondition", {
      text = "◈", -- Diamond with dot
      texthl = "DapBreakpointCondition",
      linehl = "",
      numhl = "",
    })

    -- Automatically open UI when debugging starts
    -- Allow live introspection
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
      -- Find and set modifiable on the REPL buffer
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "dap-repl" then
          vim.opt.modifiable = true

          -- Focus the REPL window
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf then
              vim.api.nvim_set_current_win(win)
              vim.cmd("startinsert") -- Enter insert mode
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
          -- Extra arguments for pytest
          args = {
            "--verbose",
            "-vv",
          },
          env = {
            PYTEST_ADDOPTS = "--sugar-no-header", -- Optional: removes the pytest-sugar header
          },
          -- Runner to use. Will try to detect python test runner
          runner = "pytest",
          -- Python path
          python = vim.fn.trim(vim.fn.system("pyenv which python")),

          -- Root patterns for package detection
          root_patterns = { "pyproject.toml", "setup.cfg", "setup.py", "pytest.ini" },

          dap = { justMyCode = false }, -- Include non-user code in debugging
        }),
        output = {
          open_on_run = false,
        },
      },
      icons = {
        passed = "●", -- Green dot
        failed = "●", -- Red dot
        running = "◍",
        skipped = "○",
      },
      highlights = {
        passed = "NeotestPassed", -- We'll define these highlights below
        failed = "NeotestFailed",
        running = "NeotestRunning",
        skipped = "NeotestSkipped",
      },
    })
    vim.cmd([[
      highlight NeotestPassed ctermfg=Green guifg=#00ff00
      highlight NeotestFailed ctermfg=Red guifg=#ff0000
      highlight NeotestRunning ctermfg=Yellow guifg=#ffff00
      highlight NeotestSkipped ctermfg=Gray guifg=#808080
      ]])

    -- test runner keymaps
    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run test file" })

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open()
    end, { desc = "Show test output" })

    vim.keymap.set("n", "<leader>tO", function()
      require("neotest").output_panel.toggle()
    end, { desc = "Toggle test output panel" })

    vim.keymap.set("n", "<leader>tT", function()
      neotest.run.run(vim.fn.getcwd())
      neotest.output_panel.toggle()
    end, { desc = "Run all tests in project" })

    -- Debug keymaps
    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "Debug nearest test" })

    vim.keymap.set("n", "<leader>du", function()
      dapui.toggle()
    end, { desc = "Debug: Toggle UI" })

    vim.keymap.set("n", "<leader>dc", function()
      dap.continue()
    end, { desc = "Debug: Continue" })

    vim.keymap.set("n", "<leader>do", function()
      dap.step_over()
    end, { desc = "Debug: Step Over" })

    vim.keymap.set("n", "<leader>di", function()
      dap.step_into()
    end, { desc = "Debug: Step Into" })

    vim.keymap.set("n", "<leader>dO", function()
      dap.step_out()
    end, { desc = "Debug: Step Out" })

    -- Set breakpoints
    vim.keymap.set("n", "<leader>db", function()
      vim.api.nvim_command("DapToggleBreakpoint")
    end, { desc = "Toggle breakpoint" })
  end,
}
