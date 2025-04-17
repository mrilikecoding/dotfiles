-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- statusline
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text

-- Load telescope refactoring extension
require("telescope").load_extension("refactoring")
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  require("telescope").extensions.refactoring.refactors()
end)

-- Project-specific configurations are loaded here
require("dap_projects").load_project_config()
