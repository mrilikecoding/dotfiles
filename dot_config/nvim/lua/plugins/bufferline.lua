return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
        numbers = "ordinal",
        max_name_length = 18, -- Truncate long filenames
        name_formatter = function(buf) -- buf contains:
          return buf.name -- Show full path on hover
        end,
      },
    },
  },
}
