return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Extend the existing opts
    opts.diagnostics = {
      virtual_text = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.INFO] = "ℹ",
          [vim.diagnostic.severity.HINT] = "⚑",
        },
      },
    }

    -- Keybindings to view diagnostics
    vim.keymap.set("n", "<Tab>", vim.diagnostic.open_float, { desc = "Show diagnostic in floating window" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })

    return opts
  end,
}
