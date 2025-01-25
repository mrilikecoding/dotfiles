return {
  {
    "RRethy/base16-nvim",
    config = function()
      vim.cmd("colorscheme tokyonight-day")
    end,
  },
  -- Telescope configuration with colorscheme preview enabled
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup({
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
      })
    end,
  },
  -- Colorful window separation
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
}
