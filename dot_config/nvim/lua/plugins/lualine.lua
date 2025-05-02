return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local git_blame = require("gitblame")
    local spelunk = require("spelunk")
    local dap_projects = require("dap_projects")

    return {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diagnostics" },
        lualine_c = {
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
        },
        lualine_x = { 
          { dap_projects.get_status },
          { "filename", path = 1 } 
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  end,
}
