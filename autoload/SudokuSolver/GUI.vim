function! SudokuSolver#GUI#init ()
    let s:row = 0
    let s:col = 0
endfunction


function! SudokuSolver#GUI#cursor ()
    return [s:row, s:col]
endfunction


function! SudokuSolver#GUI#show_msg ()
    call SudokuSolver#Canvus#alloc_line(26)
    call setline(21, 'h/j/k/l: move cursor')
    call setline(22, 'Arrow keys: move cursor')
    call setline(23, 'Number keys: set number')
    call setline(24, '<C-r>: reset')
    call setline(25, '<CR>: start solving')
    call cursor(26, 0)
endfunction


function SudokuSolver#GUI#move_cursor_left ()
    call s:move_cursor(0, -1)
endfunction


function SudokuSolver#GUI#move_cursor_down ()
    call s:move_cursor(1, 0)
endfunction


function SudokuSolver#GUI#move_cursor_up ()
    call s:move_cursor(-1, 0)
endfunction


function SudokuSolver#GUI#move_cursor_right ()
    call s:move_cursor(0, 1)
endfunction


function! s:move_cursor (drow, dcol)
    if 0 <= s:row + a:drow && s:row + a:drow <= 8
        let s:row += a:drow
    endif

    if 0 <= s:col + a:dcol && s:col + a:dcol <= 8
        let s:col += a:dcol
    endif

    call SudokuSolver#Canvus#draw_frame()
    call SudokuSolver#Canvus#draw_numbers()
    call SudokuSolver#Canvus#draw_cursor(s:row, s:col)
endfunction


function! SudokuSolver#GUI#set_number (...)
    if a:0 == 1
        let l:row = s:row
        let l:col = s:col
        let l:num = a:1
    elseif a:0 == 3
        let l:row = a:1
        let l:col = a:2
        let l:num = a:3
    endif
    call SudokuSolver#Canvus#draw_number(l:row, l:col, l:num)
endfunction
