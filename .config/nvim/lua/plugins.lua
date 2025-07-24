return {
  {
    "tpope/vim-commentary",
    lazy = false,
    config = function()
      vim.keymap.set('n', '<C-_>', '<Plug>Commentary', { silent = true, desc = "Comment/uncomment with operator" })
      vim.keymap.set('n', '<C-_><C-_>', '<Plug>CommentaryLine', { silent = true, desc = "Toggle comment on current line" })
    end,
  },
}
