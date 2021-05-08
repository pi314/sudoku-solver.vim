" SudokuBoard: stores the board data, i.e. the 9x9 numbers

let s:COLOR_WHITE = 1
let s:COLOR_PENCIL = 2

let SudokuBoard#WHITE = s:COLOR_WHITE
let SudokuBoard#PENCIL = s:COLOR_PENCIL

let s:board = []


function! SudokuBoard#init ()
    for l:row in range(9)
        call add(s:board, [])
        for l:col in range(9)
            call add(s:board[(l:row)], {'num': 0, 'color': s:COLOR_WHITE})
        endfor
    endfor

    " to be removed
    let l:demo_data = [
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
            let s:board[(l:row)][(l:col)]['num'] = str2nr(l:demo_data[(l:row)][(l:col)])
            let s:board[(l:row)][(l:col)]['color'] = s:COLOR_WHITE
        endfor
    endfor

endfunction


function! SudokuBoard#get_num(row, col)
    return s:board[(a:row)][(a:col)]['num']
endfunction


function! SudokuBoard#get_color(row, col)
    return s:board[(a:row)][(a:col)]['color']
endfunction


function! SudokuBoard#set_num(row, col, num, color)
    let s:board[(a:row)][(a:col)]['num'] = a:num
    let s:board[(a:row)][(a:col)]['color'] = a:color
endfunction
