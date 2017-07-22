function! SudokuSolver#Solver#init ()
endfunction


function! s:reset_data (...)
    let l:data = []
    for l:row in range(9)
        call add(l:data, [])
        for l:col in range(9)
            if a:0 == 0 || a:1[(l:row)][(l:col)] == 0
                call add(l:data[(l:row)], {
                            \ 'cand': [1, 2, 3, 4, 5, 6, 7, 8, 9],
                            \ })
            else
                call add(l:data[(l:row)], {
                            \ 'cand': [(a:1[(l:row)][(l:col)])],
                            \ })
            endif
        endfor
    endfor
    return l:data
endfunction


function! s:sum (list)
    let l:acc = 0
    for l:i in a:list
        let l:acc += l:i
    endfor
    return l:acc
endfunction


function! s:line_solver (line)
    let l:sum = 0
    let l:zero_idx = -1

    let l:idx = 0
    for l:idx in range(9)
        if len(a:line[(l:idx)]['cand']) == 1
            let l:sum += a:line[(l:idx)]['cand'][0]
        else
            if l:zero_idx == -1
                let l:zero_idx = l:idx
            else
                return []
            endif
        endif
    endfor

    if l:sum >= 36 && l:zero_idx >= 0 && index(a:line[(l:zero_idx)]['cand'], 45 - l:sum) != -1
        return [l:zero_idx, 45 - l:sum]
    endif
    return []
endfunction


function! SudokuSolver#Solver#RowSolver (data)
    let l:results = []
    for l:row in range(9)
        let l:res = s:line_solver(a:data[(l:row)])
        if l:res != []
            call add(l:results, [l:row, l:res[0], l:res[1]])
        endif
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#ColSolver (data)
    let l:results = []
    for l:col in range(9)
        let l:res = s:line_solver(map(copy(a:data), 'v:val['. l:col .']'))
        if l:res != []
            call add(l:results, [l:res[0], l:col, l:res[1]])
        endif
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#BlockSolver (data)
    let l:results = []
    for l:row in range(3)
        for l:col in range(3)
            let l:line = []
            for l:i in range(9)
                call add(l:line, a:data[((l:row * 3) + (l:i / 3))][((l:col * 3) + (l:i % 3))])
            endfor
            let l:res = s:line_solver(l:line)
            if l:res != []
                call add(l:results, [
                            \ (l:row * 3) + (l:res[0] / 3),
                            \ (l:col * 3) + (l:res[0] % 3),
                            \ l:res[1]
                            \ ])
            endif
        endfor
    endfor
    return l:results
endfunction


let s:solvers = [
        \ function('SudokuSolver#Solver#RowSolver'),
        \ function('SudokuSolver#Solver#ColSolver'),
        \ function('SudokuSolver#Solver#BlockSolver'),
        \ ]
function! SudokuSolver#Solver#RuleSolver (data)
    let l:results = []
    for Solver in s:solvers
        for l:res in Solver(a:data)
            if l:res != []
                call add(l:results, l:res)
            endif
        endfor
    endfor
    return l:results
endfunction


function! SudokuSolver#Solver#solve ()
    let s:data = s:reset_data(SudokuSolver#Canvus#data())
    while v:true
        let l:results = SudokuSolver#Solver#RuleSolver(s:data)
        if type(l:results) != type([]) || l:results == []
            break
        else
            for l:res in l:results
                if type(l:res) != type([]) || len(l:res) != 3
                elseif l:res[0] < 0 || 9 < l:res[0]
                elseif l:res[1] < 0 || 9 < l:res[1]
                elseif l:res[2] < 0 || 9 < l:res[2]
                else
                    let s:data[(l:res[0])][(l:res[1])]['cand'] = [(l:res[2])]
                    call SudokuSolver#GUI#set_number(l:res[0], l:res[1], l:res[2])
                endif
            endfor
        endif
    endwhile
endfunction
