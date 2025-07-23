vim9script

augroup python_linting
	autocmd! 
	autocmd BufWritePost *.py call Lint()
augroup END

def Lint()

    var flist_data: list<dict<any>>
    var util_title: string
    var bufnr: number

    bufnr = bufnr('%')

    util_title = "-- Flake8:"
    flist_data = [{'text': ""}, {'bufnr': bufnr, 'text': util_title}]
    setlocal makeprg=flake8
    exec 'make! %'
    flist_data += getqflist()

    util_title = "-- Ruff:"
    flist_data += [{'text': ""}, {'bufnr': bufnr, 'text': util_title}]
    setlocal makeprg=ruff\ check\ --output-format\ concise
    exec 'make! %'
    flist_data += getqflist()

    util_title = "-- Mypy:"
    flist_data += [{'text': ""}, {'bufnr': bufnr, 'text': util_title}]
    setlocal makeprg=mypy\ --show-column-numbers\ --strict
    exec 'make! %'
    flist_data += getqflist()

    setqflist(flist_data)
    exec 'copen' 
    feedkeys('<CR>')

enddef
