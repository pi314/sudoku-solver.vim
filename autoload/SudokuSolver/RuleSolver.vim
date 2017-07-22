function! s:line_filter (line)
    let l:sum = 0
    let l:zero_idx = -1

    let l:idx = 0
    for l:idx in range(9)
        let l:item = a:line[(l:idx)]
        if l:item.val()
            for l:i in filter(range(9), 'v:val != '. l:idx)
                call a:line[(l:i)].remove(l:item.val())
            endfor
        endif
    endfor
endfunction


function! SudokuSolver#RuleSolver#RowFilter (data)
    for l:row in range(9)
        call s:line_filter(a:data[(l:row)])
    endfor
endfunction


function! SudokuSolver#RuleSolver#ColFilter (data)
    for l:col in range(9)
        call s:line_filter(map(copy(a:data), 'v:val['. l:col .']'))
    endfor
endfunction


function! SudokuSolver#RuleSolver#BlockFilter (data)
    for l:row in range(3)
        for l:col in range(3)
            let l:line = []
            for l:i in range(9)
                call add(l:line, a:data[((l:row * 3) + (l:i / 3))][((l:col * 3) + (l:i % 3))])
            endfor
            call s:line_filter(l:line)
        endfor
    endfor
endfunction


let s:filters = [
        \ function('SudokuSolver#RuleSolver#RowFilter'),
        \ function('SudokuSolver#RuleSolver#ColFilter'),
        \ function('SudokuSolver#RuleSolver#BlockFilter'),
        \ ]
function! SudokuSolver#RuleSolver#RuleSolver (data)
    let l:results = []
    for Filter in s:filters
        call Filter(a:data)
    endfor

    for l:row in range(9)
        for l:col in range(9)
            let l:item = a:data[(l:row)][(l:col)]
            if !(l:item.given()) && !(l:item.confirmed()) && l:item.val() != 0
                call add(l:results, [l:row, l:col, a:data[(l:row)][(l:col)].val()])
            endif
        endfor
    endfor
    return l:results
endfunction
