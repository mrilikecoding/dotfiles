-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- statusline
local git_blame = require("gitblame")
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
require("lualine").setup({
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diagnostics" },
    lualine_c = {
      { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
    },
    lualine_x = {},
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- refactoring related config (see plugins/ide.lua)
--
-- https://github.com/ThePrimeagen/refactoring.nvim
require("refactoring").setup({})
require("telescope").load_extension("refactoring")
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
  require("telescope").extensions.refactoring.refactors()
end)

require("telescope").setup({
  defaults = {
    cache_picker = {
      num_pickers = 20,
    },
  },
})

-- comment default
require("Comment").setup()
