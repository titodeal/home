" Set inclusive backward motions 
onoremap b vb
onoremap 0 v0
onoremap F vF

" Split and move keymaps
"execute "set <A-w>=\x1bw"
"execute "set <A-W>=\x1bW"
"nnoremap <A-W> :botright split<CR>
nnoremap <A-w> :split<CR>
nnoremap <S-W> :vsplit<CR>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <leader>q :q<CR>
nnoremap !<leader>q :q!<CR>

" --- Maximize window size function
noremap <silent><expr> <A-Space> ExpandWindow()
" inoremap <silent><expr> <A-Space> ExpandWindow()
" tnoremap <silent><expr> <A-Space> ExpandWindow()

let g:expanded = 1
function! ExpandWindow() abort
"     var maximize: string
"     var minimize: string
    if mode() == 'i'
        let maximize = "\<C-R>=execute" .. '("normal \<C-W>|\<C-W>_")' .. "\<CR>"
        let minimize = "\<C-R>=execute" .. '("normal \<C-W>=")' .. "\<CR>"
    else
        let maximize = "\<C-W>\|\<C-W>_"
        let minimize = "\<C-W>="
    endif
    let g:expanded = 1 - g:expanded
    return g:expanded ? minimize : maximize
endfunction

" Split and move terminal
nnoremap <leader><S-W> :vertical term <CR>
tnoremap <C-J> <C-\><C-N><C-w>j
tnoremap <C-K> <C-\><C-N><C-w>k
tnoremap <C-H> <C-\><C-N><C-w>h
tnoremap <C-L> <C-\><C-N><C-w>l
tnoremap <leader>q <C-\><C-N>:q!<CR>
tnoremap <C-[><C-[> <C-\><C-N>


" Saving
nnoremap <silent> <C-S> :write<CR>
inoremap <silent><C-S> <Cmd>call execute("write")<CR>
" Highlight search on/off
nnoremap <F3> :set hlsearch!<CR>

" Dot completion
" inoremap <expr> . empty(&omnifunc) ? '.' : ".\<C-X>\<C-O>" 
" Reject popup menu
" inoremap <C-L> <C-X><C-Z>
" Insert mode Undo record
"inoremap <Space> <C-G>u<Space>
inoremap <CR> <C-G>u<CR>

" Insert cursor motions.
noremap! <A-h> <C-Left>
noremap! <A-l> <C-Right>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <C-A-j> <C-g><Down>
inoremap <C-A-k> <C-g><Up>

" open tag file in preveiw window
noremap <leader>] :exe "ptag " .. expand("<cword>")<CR>
echom "module: Mapping"
