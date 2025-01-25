return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        -- separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = false,
        tab_size = 21,
        numbers = "ordinal",
        max_name_length = 30, -- Truncate long filenames
        name_formatter = function(buf) -- buf contains:
          return buf.name -- Show full path on hover
        end,
        height = 4,
        padding = 2,
        enforce_regular_tabs = true,
      },
    },
  },
}
-- return {
--   {
--     "romgrk/barbar.nvim",
--     dependencies = {
--       "lewis6991/gitsigns.nvim", -- optional
--       "nvim-tree/nvim-web-devicons", -- optional
--     },
--     init = function()
--       vim.g.barbar_auto_setup = false
--     end,
--     opts = {
--       -- Enable animations
--       animation = true,
--
--       -- Enable auto-hiding when only one tab
--       auto_hide = false,
--
--       focus_on_win = true,
--
--       -- Enable clickable tabs
--       clickable = true,
--
--       -- Display buffers in their windows
--       sidebar_filetypes = {
--         -- Make tabs display over the file tree
--         NvimTree = { text = "File Explorer" },
--       },
--
--       highlight_visible = true,
--
--       -- Customize icons
--       icons = {
--         -- Configure buffer-pick icons
--         buffer_index = true,
--         buffer_number = false,
--         button = "",
--
--         -- Enables / disables diagnostic symbols
--         diagnostics = {
--           [vim.diagnostic.severity.ERROR] = { enabled = true },
--           [vim.diagnostic.severity.WARN] = { enabled = true },
--         },
--       },
--     },
--     version = "^1.0.0",
--   },
-- }
