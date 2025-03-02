-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
local map = vim.keymap.set

-- Easier navigation in normal mode
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Terminal mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Enhanced React development
map("n", "<leader>ra", function()
  vim.cmd("TSToolsAddMissingImports")
  vim.cmd("TSToolsOrganizeImports")
  vim.cmd("TSToolsFixAll")
end, { desc = "React: Fix imports & errors" })

-- Go development shortcuts
map("n", "<leader>gt", function()
  vim.cmd("GoTestFunc")
end, { desc = "Go: Test function" })

map("n", "<leader>gr", function()
  vim.cmd("GoRun")
end, { desc = "Go: Run file" })
