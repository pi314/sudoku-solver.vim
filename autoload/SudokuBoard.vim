" SudokuBoard: stores the board data, i.e. the 9x9 numbers

let g:SUDOKU_COLOR_DEFAULT = 1
let g:SUDOKU_COLOR_PENCIL = 2


let s:history = []
let s:current = v:none


function! SudokuBoard#init ()
    call add(s:history, [[], [0, 0]])
    let s:current = 0
    let l:board_ref = s:history[s:current][0]
    echom l:board_ref

    for l:row in range(9)
        call add(l:board_ref, [])
        for l:col in range(9)
            call add(l:board_ref[(l:row)], {'num': 0, 'color': g:SUDOKU_COLOR_DEFAULT})
        endfor
    endfor

    " to be removed
    let l:init_data = [
                \ '000008001',
                \ '000600007',
                \ '009010035',
                \ '000070060',
                \ '021000340',
                \ '050080000',
                \ '530040100',
                \ '800003000',
                \ '600200000',
                \ ]

    for l:row in range(9)
        for l:col in range(9)
            let l:board_ref[(l:row)][(l:col)]['num'] = str2nr(l:init_data[(l:row)][(l:col)])
            let l:board_ref[(l:row)][(l:col)]['color'] = g:SUDOKU_COLOR_DEFAULT
        endfor
    endfor

endfunction


function! SudokuBoard#snapshot (userdata)
    if s:current + 1 < len(s:history)
        call remove(s:history, s:current + 1, -1)
    endif

    let l:snapshot = deepcopy(s:history[s:current][0])

    call add(s:history, [l:snapshot, a:userdata])
    let s:current += 1
endfunction


function! SudokuBoard#rollback ()
    if s:current > 0
        let s:current -= 1
        return s:history[s:current][1]
    endif
    return v:false
endfunction


function! SudokuBoard#cancel_rollback ()
    if s:current + 1 < len(s:history)
        let s:current += 1
        return s:history[s:current][1]
    endif
    return v:false
endfunction


function! SudokuBoard#get_num (row, col)
    return s:history[s:current][0][(a:row)][(a:col)]['num']
endfunction


function! SudokuBoard#get_color (row, col)
    return s:history[s:current][0][(a:row)][(a:col)]['color']
endfunction


function! SudokuBoard#set_num (row, col, num, color)
    let l:board_ref = s:history[s:current][0]

    if l:board_ref[(a:row)][(a:col)]['num'] != 0
        if l:board_ref[(a:row)][(a:col)]['color'] != a:color
            return
        endif
    endif

    let l:board_ref[(a:row)][(a:col)]['num'] = a:num
    let l:board_ref[(a:row)][(a:col)]['color'] = a:color
endfunction
