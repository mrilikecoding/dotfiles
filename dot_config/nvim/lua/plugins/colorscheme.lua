return {
  -- Add the base16-nvim plugin
  -- https://github.com/RRethy/base16-nvim
  {
    "RRethy/base16-nvim",
    config = function()
      vim.cmd("colorscheme base16-gruvbox-dark-hard")
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

  -- You may have additional plugins here
}
