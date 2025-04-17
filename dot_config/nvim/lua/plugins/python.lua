return {
  -- Configure LSP for Python
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Import shared utility for MyPy detection
      local function is_mypy_project()
        local cwd = vim.fn.getcwd()
        -- Check for mypy.ini
        return vim.fn.filereadable(cwd .. "/mypy.ini") == 1
      end

      -- Configure servers based on project
      if is_mypy_project() then
        print("MyPy project detected! Configuring Python LSP accordingly.")

        -- Adjust Pyright to focus on completion rather than type checking
        opts.servers = opts.servers or {}
        opts.servers.pyright = opts.servers.pyright or {}
        opts.servers.pyright.settings = opts.servers.pyright.settings or {}
        opts.servers.pyright.settings.python = opts.servers.pyright.settings.python or {}
        opts.servers.pyright.settings.python.analysis = opts.servers.pyright.settings.python.analysis or {}
        opts.servers.pyright.settings.python.analysis.typeCheckingMode = "off" -- Let MyPy handle type checking
      end

      return opts
    end,
  },

  -- Ensure formatters and linters are installed via Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "mypy", "black", "ruff" })
      return opts
    end,
  },

  -- Configure null-ls/none-ls for formatting and linting
  {
    "nvimtools/none-ls.nvim", -- Make sure this is installed in your LazyVim setup
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local h = require("null-ls.helpers")

      -- Helper function to check if a formatter is installed in the python env
      local function is_tool_in_pyenv(tool)
        local venv = os.getenv("VIRTUAL_ENV")
        if not venv then
          return false
        end

        local tool_path = venv .. "/bin/" .. tool
        local f = io.open(tool_path, "r")
        if f then
          f:close()
          return true
        end
        return false
      end

      -- Reuse the same detection function from earlier
      local function is_mypy_project()
        local cwd = vim.fn.getcwd()
        return vim.fn.filereadable(cwd .. "/mypy.ini") == 1
      end

      -- Configure sources based on project and environment
      opts.sources = opts.sources or {}

      -- Add MyPy if we're in a MyPy project
      if is_mypy_project() then
        vim.list_extend(opts.sources, {
          null_ls.builtins.diagnostics.mypy.with({
            -- The --config-file option will automatically use mypy.ini from the project root
            extra_args = { "--config-file", vim.fn.getcwd() .. "/mypy.ini" },
            -- If using a virtual environment:
            cwd = vim.fn.getcwd(),
            env = {
              -- Adjust this path to match your virtual environment location
              PYTHONPATH = vim.fn.getcwd() .. ":" .. vim.fn.getcwd() .. "/.venv/lib/python3.9/site-packages",
            },
          }),
        })
      end

      -- Use black from pyenv if available, otherwise use global
      if is_tool_in_pyenv("black") then
        local venv = os.getenv("VIRTUAL_ENV")
        vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.black.with({
            command = venv .. "/bin/black",
          }),
        })
      else
        vim.list_extend(opts.sources, {
          null_ls.builtins.formatting.black,
        })
      end

      -- Use ruff from pyenv if available, otherwise use global
      if is_tool_in_pyenv("ruff") then
        local venv = os.getenv("VIRTUAL_ENV")
        vim.list_extend(opts.sources, {
          null_ls.builtins.diagnostics.ruff.with({
            command = venv .. "/bin/ruff",
          }),
        })
      else
        vim.list_extend(opts.sources, {
          null_ls.builtins.diagnostics.ruff,
        })
      end

      return opts
    end,
  },
}
