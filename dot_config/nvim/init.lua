-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- statusline
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text

-- refactoring related config (see plugins/ide.lua)
--
-- https://github.com/ThePrimeagen/refactoring.nvim
require("refactoring").setup({})
require("telescope").load_extension("refactoring")
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  require("telescope").extensions.refactoring.refactors()
end)

-- comment default
require("Comment").setup()
