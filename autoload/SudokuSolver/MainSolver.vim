let s:STATE_IDLE = 'STATE_IDLE'
let s:STATE_SOLVING = 'STATE_SOLVING'


function! SudokuSolver#MainSolver#init ()
    let s:state = s:STATE_IDLE
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

    function! item.keep_only (num)
        if has_key(self._candidates, a:num)
            let self._candidates = {}
            let self._candidates[(a:num)] = v:true
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


let s:solvers = [
            \ 'SudokuSolver#RuleSolver',
            \ 'SudokuSolver#CandidateSolver',
            \ ]
function! SudokuSolver#MainSolver#solve ()
    let s:state = s:STATE_IDLE

    let s:continue = v:true
    while s:continue
        let s:continue = SudokuSolver#MainSolver#solve_one()
    endwhile

    let s:state = s:STATE_IDLE
endfunction


function! SudokuSolver#MainSolver#solve_one ()
    if s:state == s:STATE_IDLE
        let s:data = s:reset_data(SudokuSolver#GUI#data())
        let s:state = s:STATE_SOLVING
    endif

    for s:solver in s:solvers
        let l:res = function(s:solver .'#solve_one')(s:data)
        if type(l:res) != type([]) || len(l:res) != 3
        elseif l:res[0] < 0 || 9 < l:res[0]
        elseif l:res[1] < 0 || 9 < l:res[1]
        elseif l:res[2] < 0 || 9 < l:res[2]
        else
            let l:item = s:data[(l:res[0])][(l:res[1])]
            call l:item.confirmed(v:true)
            call SudokuSolver#GUI#set_number(l:res[0], l:res[1], l:res[2])
            return v:true
        endif
    endfor
    return v:false
endfunction
