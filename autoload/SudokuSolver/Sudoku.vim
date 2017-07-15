function! SudokuSolver#Sudoku#init ()
    let s:sudoku_ary = []
    for l:row in range(9)
        call add(s:sudoku_ary, [])
        for l:col in range(9)
            call add(s:sudoku_ary[(l:row)], 0)
        endfor
    endfor
endfunction


function! SudokuSolver#Sudoku#set_number (row, col, num)
    let s:sudoku_ary[(a:row)][(a:col)] = a:num
endfunction


function! SudokuSolver#Sudoku#array (...)
    if a:0 == 0
        return s:sudoku_ary
    elseif a:0 == 1
        return s:sudoku_ary[(a:1)]
    elseif a:0 == 2
        return s:sudoku_ary[(a:1)][(a:2)]
    endif
endfunction
