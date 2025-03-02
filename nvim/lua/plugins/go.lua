return {
  -- Configure Go development tools
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },

  -- Improve Go development experience
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure gopls (Go language server)
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              semanticTokens = true,
            },
          },
        },
      },
    },
  },
}
