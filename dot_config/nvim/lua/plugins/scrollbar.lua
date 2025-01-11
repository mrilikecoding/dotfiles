return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "kevinhwang91/nvim-hlslens", -- Optional for better search
  },
  config = function()
    require("scrollbar").setup({
      show_in_active_only = true,
      handle = {
        color = "#555555",
        clickable = true,
      },
      marks = {
        Search = { color = "#ff9e64" },
        Error = { color = "#db4b4b" },
        Warn = { color = "#e0af68" },
        Info = { color = "#0db9d7" },
        Hint = { color = "#1abc9c" },
        Misc = { color = "#9d7cd8" },
        GitAdd = { color = "#449dab" },
        GitChange = { color = "#6183bb" },
        GitDelete = { color = "#914c54" },
      },
    })
  end,
}
