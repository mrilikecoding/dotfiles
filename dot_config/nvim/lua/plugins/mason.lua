return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    -- Add debugpy to the list of ensure_installed
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "debugpy",
    })
    return opts
  end,
}
