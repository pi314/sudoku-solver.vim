function! SudokuSolver#Solver#init ()
endfunction


function! s:item ()
    let item = {}
    let item._confirmed = v:false
    let item._given = v:false
    let item._candidates = {}

    for l:i in range(1, 9)
        let item._candidates[(l:i)] = v:true
    endfor

    function! item.confirmed (...)
        if a:0 == 1 && type(a:1) == type(v:true)
            let self._confirmed = a:1
        endif
        return self._confirmed
    endfunction

    function! item.given ()
        return self._given
    endfunction

    function! item.val ()
        if len(self._candidates) == 1
            return str2nr(keys(self._candidates)[0])
        else
            return 0
        endif
    endfunction

    function! item.has_candidate (num)
        return has_key(self._candidates, a:num)
    endfunction

    function! item.remove (num)
        if has_key(self._candidates, a:num)
            unlet! self._candidates[(a:num)]
        endif
    endfunction

    function! item.set_num (num)
        let self._candidates = {}
        let self._candidates[(a:num)] = v:true
        let self._given = v:true
    endfunction

    return item
endfunction


function! s:reset_data (...)
    let l:data = []
    for l:row in range(9)
        call add(l:data, [])
        for l:col in range(9)
            let l:item = s:item()
            if a:0 != 0 && a:1[(l:row)][(l:col)] != 0
                call l:item.set_num(a:1[(l:row)][(l:col)])
            endif
            call add(l:data[(l:row)], l:item)
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


function! SudokuSolver#Solver#RowFilter (data)
    for l:row in range(9)
        call s:line_filter(a:data[(l:row)])
    endfor
endfunction


function! SudokuSolver#Solver#ColFilter (data)
    for l:col in range(9)
        call s:line_filter(map(copy(a:data), 'v:val['. l:col .']'))
    endfor
endfunction


function! SudokuSolver#Solver#BlockFilter (data)
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
        \ function('SudokuSolver#Solver#RowFilter'),
        \ function('SudokuSolver#Solver#ColFilter'),
        \ function('SudokuSolver#Solver#BlockFilter'),
        \ ]
function! SudokuSolver#Solver#RuleSolver (data)
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


function! SudokuSolver#Solver#solve ()
    let s:data = s:reset_data(SudokuSolver#GUI#data())
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
                    let l:item = s:data[(l:res[0])][(l:res[1])]
                    call l:item.confirmed(v:true)
                    call SudokuSolver#GUI#set_number(l:res[0], l:res[1], l:res[2])
                endif
            endfor
        endif
    endwhile
endfunction
