-- Custom Ruby DAP integration with path mapping support
return {
  -- Use our custom Ruby DAP module instead of nvim-dap-ruby
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- We're not including suketa/nvim-dap-ruby here
    },
    config = function()
      -- Load our custom dap-ruby module
      local status_ok, dap_ruby = pcall(require, "dap-ruby")
      if not status_ok then
        vim.notify("Could not load dap-ruby", vim.log.levels.ERROR)
        return
      end
      
      -- Configure with specific path mappings if needed
      dap_ruby.setup({
        -- Use system Ruby by default (will be auto-detected)
        -- ruby_path = "/path/to/ruby",
        
        -- Configure the adapter
        adapter_options = {
          port = 38698,
          command = "bundle",
          args = { "exec", "rdbg", "-n", "--open", "--port", "38698" }
        },
        
        -- Add path mappings for remote/container debugging
        path_mappings = {
          -- Example path mapping (uncomment and modify as needed)
          -- {
          --   localRoot = vim.fn.getcwd(),
          --   remoteRoot = "/app"
          -- }
        }
      })
    end
  },
}