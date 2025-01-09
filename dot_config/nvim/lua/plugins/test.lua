return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local python_path = vim.fn.trim(vim.fn.system("pyenv which python"))
    print("Neotest using Python: " .. python_path) -- This will show the path

    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          -- Extra arguments for pytest
          args = { "--verbose" },
          -- Runner to use. Will try to detect python test runner
          runner = "pytest",
          -- Python path
          python = vim.fn.trim(vim.fn.system("pyenv which python")),

          -- Root patterns for package detection
          root_patterns = { "pyproject.toml", "setup.cfg", "setup.py", "pytest.ini" },
        }),
        output = {
          open_on_run = true,
        },
        output_panel = {
          open_on_run = true,
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

    local neotest = require("neotest") -- Define this first!

    vim.keymap.set("n", "<leader>tT", function()
      neotest.run.run(vim.fn.getcwd())
      neotest.output_panel.toggle()
    end, { desc = "Run all tests in project" })
  end,
}
