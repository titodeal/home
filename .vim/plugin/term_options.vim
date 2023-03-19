vim9script

augroup termoptions
	autocmd! 
	autocmd TerminalOpen * SetTermOptions()
augroup END

def SetTermOptions()
    setlocal nonumber
enddef

# Terminal scrolling
tnoremap <ScrollWheelUp> <C-W>N
tnoremap <ScrollWheelDown> <C-W>N

echom "module: Terminal Options"
