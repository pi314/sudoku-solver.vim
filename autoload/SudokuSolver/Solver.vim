function! s:sum (list)
    let l:acc = 0
    for l:i in a:list
        let l:acc += l:i
    endfor
    return l:acc
endfunction


function! s:line_solver (line)
    let l:sum = s:sum(a:line)
    let l:zero_idx = index(a:line, 0)
    if l:sum >= 36 && l:zero_idx >= 0
        return [l:zero_idx, 45 - l:sum]
    endif
    return []
endfunction


function! SudokuSolver#Solver#RowSolver (ary)
    let l:results = []
    for l:row in range(9)
        let l:res = s:line_solver(a:ary[(l:row)])
        if l:res != []
            call add(l:results, [l:row, l:res[0], l:res[1]])
        endif
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#ColSolver (ary)
    let l:results = []
    for l:col in range(9)
        let l:res = s:line_solver(map(copy(a:ary), 'v:val['. l:col .']'))
        if l:res != []
            call add(l:results, [l:res[0], l:col, l:res[1]])
        endif
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#BlockSolver (ary)
    let l:results = []
    return l:results
endfunction


let s:solvers = [
        \ function('SudokuSolver#Solver#RowSolver'),
        \ function('SudokuSolver#Solver#ColSolver'),
        \ function('SudokuSolver#Solver#BlockSolver'),
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
    while v:true
        let l:results = SudokuSolver#Solver#RuleSolver(SudokuSolver#Sudoku#array())
        if type(l:results) != type([]) || l:results == []
            break
        else
            for l:res in l:results
                if type(l:res) != type([]) || len(l:res) != 3
                elseif l:res[0] < 0 || 9 < l:res[0]
                elseif l:res[1] < 0 || 9 < l:res[1]
                elseif l:res[2] < 0 || 9 < l:res[2]
                else
                    call SudokuSolver#Sudoku#set_number(l:res[0], l:res[1], l:res[2])
                    call SudokuSolver#Canvus#draw_number(l:res[0], l:res[1])
                endif
            endfor
        endif
    endwhile
endfunction
