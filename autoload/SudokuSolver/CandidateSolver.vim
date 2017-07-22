function! s:line_candidate_solver (line)
    for l:num in range(1, 9)
        let l:uniq_idx = -1
        for l:idx in range(9)
            let l:item = a:line[(l:idx)]
            if l:item.has_candidate(l:num)
                if l:uniq_idx == -1
                    let l:uniq_idx = l:idx
                else
                    let l:uniq_idx = -1
                    break
                endif
            endif
        endfor

        if l:uniq_idx != -1 && !(a:line[(l:uniq_idx)].given()) && !(a:line[(l:uniq_idx)].confirmed())
            call a:line[(l:uniq_idx)].keep_only(l:num)
        endif
    endfor
endfunction


function! SudokuSolver#CandidateSolver#RowCandidateSolver (data)
    for l:row in range(9)
        call s:line_candidate_solver(a:data[(l:row)])
    endfor
endfunction


function! SudokuSolver#CandidateSolver#ColCandidateSolver (data)
    for l:col in range(9)
        call s:line_candidate_solver(map(copy(a:data), 'v:val['. l:col .']'))
    endfor
endfunction


function! SudokuSolver#CandidateSolver#BlockCandidateSolver (data)
    for l:row in range(3)
        for l:col in range(3)
            let l:line = []
            for l:i in range(9)
                call add(l:line, a:data[((l:row * 3) + (l:i / 3))][((l:col * 3) + (l:i % 3))])
            endfor
            call s:line_candidate_solver(l:line)
        endfor
    endfor
endfunction


let s:candidate_solvers = [
            \ function('SudokuSolver#CandidateSolver#RowCandidateSolver'),
            \ function('SudokuSolver#CandidateSolver#ColCandidateSolver'),
            \ function('SudokuSolver#CandidateSolver#BlockCandidateSolver'),
            \ ]
function! SudokuSolver#CandidateSolver#MainCandidateSolver (data)
    let l:results = []
    for CandidateSolver in s:candidate_solvers
        call CandidateSolver(a:data)
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
