vim9script

# Set inclusive backward motions 
onoremap b vb
onoremap 0 v0
onoremap F vF

# Split and move keymaps
#execute "set <A-w>=\x1bw"
#execute "set <A-W>=\x1bW"
#nnoremap <A-W> :botright split<CR>
nnoremap <A-w> :split<CR>
nnoremap <S-W> :vsplit<CR>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <leader>q :q<CR>
nnoremap !<leader>q :q!<CR>

# --- Maximize window size function
noremap <silent><expr> <A-Space> ExpandWindow()
inoremap <silent><expr> <A-Space> ExpandWindow()
tnoremap <silent><expr> <A-Space> ExpandWindow()

var expanded = 1
def ExpandWindow(): string
    var maximize: string
    var minimize: string
    if mode() == 'i'
        maximize = "\<C-R>=execute" .. '("normal \<C-W>|\<C-W>_")' .. "\<CR>"
        minimize = "\<C-R>=execute" .. '("normal \<C-W>=")' .. "\<CR>"
    else
        maximize = "\<C-W>\|\<C-W>_"
        minimize = "\<C-W>="
    endif
    expanded = 1 - expanded
    return expanded ? minimize : maximize
enddef

# Split and move terminal
nnoremap <leader><S-W> :vertical term <CR>
tnoremap <C-J> <C-W>j 
tnoremap <C-K> <C-W>k
tnoremap <C-H> <C-W>h
tnoremap <C-L> <C-W>l
tnoremap <leader>q <C-W>N:q!<CR>

# Saving
nnoremap <silent> <C-S> :write<CR>
inoremap <silent><C-S> <Cmd>call execute("write")<CR>
# Highlight search on/off
nnoremap <F3> :set hlsearch!<CR>
# Dot completion
inoremap <expr> . empty(&omnifunc) ? '.' : ".\<C-X>\<C-O>" # Insert mode Undo record
#inoremap <Space> <C-G>u<Space>
inoremap <CR> <C-G>u<CR>

# Insert cursor motions.
noremap! <A-h> <C-Left>
noremap! <A-l> <C-Right>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <C-A-j> <C-g><Down>
inoremap <C-A-k> <C-g><Up>

# open tag file in preveiw window
noremap <leader>] :exe "ptag " .. expand("<cword>")<CR>
echom "module: Mapping"
