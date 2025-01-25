return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local git_blame = require("gitblame")
    local spelunk = require("spelunk")

    return {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diagnostics", spelunk.persist },
        lualine_c = {
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
        },
        lualine_x = { { "filename", path = 1 } },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  end,
}
