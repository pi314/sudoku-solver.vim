let s:STATE_IDLE = 'STATE_IDLE'
let s:STATE_SOLVING = 'STATE_SOLVING'


function! SudokuSolver#MainSolver#reset ()
    let s:state = s:STATE_IDLE
    let s:hypo_stack = []
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

    function! item.candidates ()
        return self._candidates
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
        let s:hypo_stack = []
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
            if len(s:hypo_stack) == 0
                call SudokuSolver#GUI#set_number(l:res[0], l:res[1], l:res[2])
            else
                call SudokuSolver#GUI#hypo_number(l:res[0], l:res[1], l:res[2])
                call add(s:hypo_stack[0]['followers'], [(l:res[0]), (l:res[1])])
            endif
            return v:true
        endif
    endfor

    " No solution found, either need to add a hypo or remove a hypo
    let l:conflict_count = 0
    let l:confirmed_count = 0
    let l:unsolved_count = 0
    let l:hypo_row = -1
    let l:hypo_col = -1
    let l:hypo_num = -1
    for l:row in range(9)
        for l:col in range(9)
            let l:item = s:data[(l:row)][(l:col)]
            if l:item.given() || l:item.confirmed()
                let l:confirmed_count += 1
                continue
            endif

            if len(l:item.candidates()) == 0
                let l:conflict_count += 1
            else
                if l:hypo_row == -1
                    let l:hypo_row = l:row
                    let l:hypo_col = l:col
                    let l:hypo_num = str2nr(keys(l:item.candidates())[0])
                endif
                let l:unsolved_count += 1
            endif
        endfor
    endfor

    if l:conflict_count != 0
        let l:hypo = remove(s:hypo_stack, 0)
        let s:data = l:hypo['data']
        let l:point = l:hypo['point']
        let l:item = s:data[(l:point[0])][(l:point[1])]
        call l:item.remove(l:point[2])
        call SudokuSolver#GUI#set_number(l:point[0], l:point[1], 0)
        for l:follower in l:hypo['followers']
            call SudokuSolver#GUI#set_number(l:follower[0], l:follower[1], 0)
        endfor
        return v:true

    elseif l:confirmed_count != 81
        let l:hypo = {}
        let l:hypo['point'] = [(l:hypo_row), (l:hypo_col), (l:hypo_num)]
        let l:hypo['data'] = deepcopy(s:data)
        let l:hypo['followers'] = []
        call insert(s:hypo_stack, l:hypo, 0)
        let l:item = s:data[(l:hypo_row)][(l:hypo_col)]
        call l:item.keep_only(l:hypo_num)
        call l:item.confirmed(v:true)
        call SudokuSolver#GUI#hypo_number((l:hypo_row), (l:hypo_col), (l:hypo_num))
        return v:true
    endif

    return v:false
endfunction
