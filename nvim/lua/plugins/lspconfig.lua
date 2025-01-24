-- ~/.config/nvim/lua/plugins/lspconfig.lua

return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      underline = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
    },
    -- Enable inlay hints
    inlay_hints = {
      enabled = true,
    },
    -- Configure servers
    servers = {
      -- Example for gopls
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
    },
  },
}
