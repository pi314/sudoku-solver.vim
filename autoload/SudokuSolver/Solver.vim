function! s:sum (list)
    let l:acc = 0
    for l:i in a:list
        let l:acc += l:i
    endfor
    return l:acc
endfunction


function! SudokuSolver#Solver#RowSolver (ary)
    let l:results = []
    for l:row in range(9)
        let l:sum = s:sum(a:ary[(l:row)])
        if l:sum >= 36
            let l:zero_col = index(a:ary[(l:row)], 0)
            call add(l:results, [l:row, l:zero_col, 45 - l:sum])
        endif
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#ColSolver (ary)
    let l:results = []
    for l:col in range(9)
        let l:list = map(copy(a:ary), 'v:val['. l:col .']')
        let l:sum = s:sum(l:list)
        if l:sum >= 36
            let l:zero_row = index(l:list, 0)
            call add(l:results, [l:zero_row, l:col, 45 - l:sum])
        endif
    endfor
    return l:results
endfunction


let s:solvers = [
        \ function('SudokuSolver#Solver#RowSolver'),
        \ function('SudokuSolver#Solver#ColSolver'),
        \ ]
function! SudokuSolver#Solver#RuleSolver (ary)
    let l:results = []
    for Solver in s:solvers
        for l:res in Solver(a:ary)
            if l:res != []
                call add(l:results, l:res)
            endif
        endfor
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#solve ()
    let l:results = SudokuSolver#Solver#RuleSolver(s:sudoku_ary)
    if type(l:results) != type([])
    else
        for l:res in l:results
            if type(l:res) != type([]) || len(l:res) != 3
            elseif l:res[0] < 0 || 9 < l:res[0]
            elseif l:res[1] < 0 || 9 < l:res[1]
            elseif l:res[2] < 0 || 9 < l:res[2]
            else
                let s:sudoku_ary[(l:res[0])][(l:res[1])] = l:res[2]
                call SudokuSolver#Canvus#draw_number(l:res[0], l:res[1])
            endif
        endfor
    endif
endfunction


function! SudokuSolver#Solver#init ()
    let s:sudoku_ary = []
    for l:row in range(9)
        call add(s:sudoku_ary, [])
        for l:col in range(9)
            call add(s:sudoku_ary[(l:row)], 0)
        endfor
    endfor
endfunction


function! SudokuSolver#Solver#set_number (row, col, num)
    let s:sudoku_ary[(a:row)][(a:col)] = a:num
endfunction


function! SudokuSolver#Solver#array (...)
    if a:0 == 0
        return s:sudoku_ary
    elseif a:0 == 1
        return s:sudoku_ary[(a:1)]
    elseif a:0 == 2
        return s:sudoku_ary[(a:1)][(a:2)]
    endif
endfunction
