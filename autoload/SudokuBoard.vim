" SudokuBoard: stores the board data, i.e. the 9x9 numbers


let SudokuBoard#WHITE = 1
let SudokuBoard#PENCIAL = 2

let s:board = []


function! SudokuBoard#init ()
    echom 'SudokuBoard#init()'
    for l:row in range(9)
        call add(s:board, [])
        for l:col in range(9)
            call add(s:board[(l:row)], {'num': 0, 'color': 'white'})
        endfor
    endfor

    echom 'SudokuBoard#init() done'

endfunction


function! SudokuBoard#get_num(row, col)
    return s:board[(a:row)][(a:col)]['num']
endfunction


function! SudokuBoard#get_color(row, col)
    return s:board[(a:row)][(a:col)]['color']
endfunction


function! SudokuBoard#set_num(row, col, num, color)
    let s:board[(a:row)][(a:col)]['num'] = a:none
    let s:board[(a:row)][(a:col)]['color'] = a:color]
endfunction
