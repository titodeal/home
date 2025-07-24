vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.lazy")

vim.cmd("set termguicolors")
vim.cmd("colorscheme substrata")

-- Split Window priority
vim.cmd("set splitright")
vim.cmd("set splitbelow")

-- Set indent
vim.cmd("set expandtab softtabstop=-1 shiftwidth=4")
-- Set separate window charachters.
-- vim.cmd("set fillchars=vert:.,fold:-,stl:\\ ,stlnc:\\ ,diff:-")
vim.opt.fillchars = {
  vert = '.',
  fold = '-',
  stl = ' ',
  stlnc = ' ',
  diff = '-',
}

-- Show statusline always.
vim.cmd("set laststatus=2")
-- Set row number
vim.cmd("set number")
-- Disable recursive search.
vim.cmd("set nowrapscan")
-- Enable mouse. To use terminal clipboard press and hold Shift key.
vim.cmd("set mouse=a")
-- Rrovides mouse response beyond 230 column.
--set ttymouse=sgr
-- Avoid comment line while 'O' or <Enter>.
-- Exclude 'o' and 'r' flag'.
vim.cmd("set formatoptions=cqlto")
-- completion
-- set completeopt=menuone,longest
-- Set clipboard behavior
vim.cmd("set clipboard=unnamedplus")

-- Створюємо автогрупу
local group = vim.api.nvim_create_augroup("aoutosourcing", { clear = true })

-- Автокоманда для збереження vimrc
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "vimrc",
  command = "source %",
  group = group,
  desc = "Reload vimrc after saving",
})

-- Автокоманда для збереження будь-якого .vim-файлу
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.vim",
  command = "source %",
  group = group,
  desc = "Reload .vim file after saving",
})
