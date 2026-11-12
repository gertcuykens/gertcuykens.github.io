-- ~/.config/nvim/init.lua

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.hidden = true
vim.opt.laststatus = 3
vim.opt.showtabline = 1
vim.opt.ttimeoutlen = 0
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.clipboard = "unnamed" -- "unnamedplus"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.list = true
vim.opt.listchars = {
  trail = "·",
  tab = "»·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}

vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/ibhagwan/fzf-lua',
--  'https://github.com/Mofiqul/vscode.nvim',
})

vim.cmd.colorscheme('retrobox')

require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = true,
  },
})

local fzf = require('fzf-lua')
fzf.setup({
  "ivy",
  fzf_colors = true,
})

vim.keymap.set('n', '<leader>g', fzf.live_grep, { desc = 'Live grep (rg)' })
vim.keymap.set('v', '<leader>g', fzf.grep_visual, { desc = 'Grep visual selection' })
vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>q', fzf.quickfix, { desc = 'Filter quickfix list' })
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>')

-- lua vim.pack.del({ 'vscode.nvim' })
-- lua vim.print(vim.pack.get())

