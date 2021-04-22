function! s:init ()
    if &filetype == 'sudoku'
    elseif (bufname('%') == '' && &modified == 0 && line('$') == 1 && getline(1) == '')
    else
        tabedit
    endif

    set buftype=nofile
    set filetype=sudoku
    set colorcolumn=

    call SudokuBoard#init()
    call SudokuGUI#init()

endfunction

command! Sudoku :call <SID>init()
