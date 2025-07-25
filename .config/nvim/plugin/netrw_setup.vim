
"If mapping for <C-H> exists the netrw-s-cr (Squeezing the Current Tree-Listing Directory) works not properly
"(https://github.com/vim/vim/issues/3307). 

"There is a few ways to fix it:
"go to $VIMRUNTIME/autoload/netrw.vim to line 6594 'nmap <buffer> <unique> <c-h> <Plug>NetrwHideEdit'
"1. Change <c-h> to free key sequence.
"2. Remove <unique> and redefine it in your vim config.

"size in percent
let g:netrw_winsize = 35
"hide banner
let g:netrw_banner = 0
"set tree style
let g:netrw_liststyle = 3
"open files in previous window
let g:netrw_browse_split = 4
"hide .gitignore files
let g:netrw_list_hide = '*.swp$,__pycache__'
"adjust preview window due 'p' key
let g:netrw_preview = 0 "horizontal
let g:netrw_alto = 0 "bottom
"if 0 the current dir will be chanched to netrw dir. If 1 it can be done by
"cd keys
let g:netrw_keepdir = 1

augroup netrw_custom_group
    autocmd!
    "-- Open after enter
    autocmd VimEnter * :Lexplore
    "-- Mapping
    autocmd filetype netrw call NetrwMapping()
augroup END

"-- Mapping
function! NetrwMapping()
    nnoremap <buffer> <C-H> <C-W>h
    nnoremap <buffer> <C-J> <C-W>j
    nnoremap <buffer> <C-K> <C-W>k
    nnoremap <buffer> <C-L> <C-W>l
    "Fixed functionality as described at the strart of the document.
    nmap <buffer> <leader><C-H> <Plug>NetrwHideEdit
    nmap <buffer> <leader><C-L> <Plug>NetrwRefresh
endfunction

nnoremap <silent> <Space> :Lexplore<CR> 
nnoremap <silent> <leader><Space> :exec ('Lexplore ' ..  fnamemodify(expand('%'),':p:h'))<CR>

echom "module: NetrwBrowser"
