" SudokuBoard: stores the board data, i.e. the 9x9 numbers

let g:SUDOKU_COLOR_WHITE = 1
let g:SUDOKU_COLOR_PENCIL = 2

let s:board = []


function! SudokuBoard#init ()
    for l:row in range(9)
        call add(s:board, [])
        for l:col in range(9)
            call add(s:board[(l:row)], {'num': 0, 'color': g:SUDOKU_COLOR_WHITE})
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
            let s:board[(l:row)][(l:col)]['color'] = g:SUDOKU_COLOR_WHITE
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
    if s:board[(a:row)][(a:col)]['num'] != 0
        if s:board[(a:row)][(a:col)]['color'] != a:color
            return
        endif
    endif

    let s:board[(a:row)][(a:col)]['num'] = a:num
    let s:board[(a:row)][(a:col)]['color'] = a:color
endfunction
