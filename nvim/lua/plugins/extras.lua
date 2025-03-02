return {
  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
    },
  },

  -- Better CSS color preview
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      css = { css = true },
      scss = { css = true },
      html = { names = false },
    },
  },
}
