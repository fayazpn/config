return {
  -- Add Dracula theme
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = 1000, -- Make sure it loads first
    opts = {
      -- Dracula customization options
      transparent_bg = true, -- Set to true if you want transparent background
      italic_comment = true, -- Enable italic comments
    },
  },

  -- Set it as the default color scheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },

  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- This will run after the plugin loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Set the background to transparent
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })

          -- Set additional UI elements to be transparent
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
          vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
          vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", ctermbg = "NONE" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
        end,
      })
    end,
  },
}
