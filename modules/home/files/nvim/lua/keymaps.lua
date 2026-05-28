local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>r", ":source $MYVIMRC<CR>", opts)

map("n", "<leader>f", "<cmd>lua require('fzf-lua').files()<CR>", opts)
map("n", "<leader>g", "<cmd>lua require('fzf-lua').live_grep()<CR>", opts)
map("n", "<leader>b", "<cmd>lua require('fzf-lua').buffers()<CR>", opts)
map("n", "<leader>h", "<cmd>lua require('fzf-lua').help_tags()<CR>", opts)
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", opts)
map("n", "<D-e>", "<cmd>NvimTreeToggle<CR>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
