vim9script

# If mapping for <C-H> exists the netrw-s-cr (Squeezing the Current Tree-Listing Directory) works not properly
# (https://github.com/vim/vim/issues/3307). 
#
# There is a few ways to fix it:
# go to $VIMRUNTIME/autoload/netrw.vim to line 6594 'nmap <buffer> <unique> <c-h> <Plug>NetrwHideEdit'
# 1. Change <c-h> to free key sequence.
# 2. Remove <unique> and redefine it in your vim config.
nmap <buffer> <leader><c-h> <Plug>NetrwHideEdit

# size in percent
g:netrw_winsize = 35
# hide banner
g:netrw_banner = 0
# set tree style
g:netrw_liststyle = 3
# open files in previous window
g:netrw_browse_split = 4
# hide .gitignore files
g:netrw_list_hide = '*.swp$,__pycache__'


augroup netrw_custom_group
    autocmd!
    # -- Open after enter
    autocmd VimEnter * :Lexplore
    # -- Mapping
    autocmd filetype netrw NetrwMapping()
augroup END

# -- Mapping
def NetrwMapping()
    nnoremap <buffer> <C-H> <C-W>h
    nnoremap <buffer> <C-J> <C-W>j
    nnoremap <buffer> <C-K> <C-W>k
    nnoremap <buffer> <C-L> <C-W>l
#    nnoremap <buffer><silent><nowait> <S-CR> <Plug>NetrwTreeSqueeze
#    nnoremap <buffer><silent><nowait><unique> <leader><C-H> <Plug>NetrwHideEdit
enddef

nnoremap <leader><C-K> :Lexplore<CR>

echom "module: NetrwBrowser"
