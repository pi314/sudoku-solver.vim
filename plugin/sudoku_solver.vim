"==============================================================================
" File: sudoku_solver.vim
" Author: https://github.com/pi314
"==============================================================================


function! s:solve ()
endfunction


function! s:init ()
    if &filetype == 'sudoku_solver'
    elseif (bufname('%') == '' && &modified == 0 && line('$') == 1 && getline(1) == '')
    else
        tabedit
    endif
    set buftype=nofile
    set filetype=sudoku_solver

    call SudokuSolver#Sudoku#init()
    call SudokuSolver#GUI#init()

    call SudokuSolver#Canvus#canvas_clear()
    call SudokuSolver#Canvus#draw_frame()
    call SudokuSolver#GUI#show_msg()
    call SudokuSolver#Canvus#draw_numbers()

    let [l:row, l:col] = SudokuSolver#GUI#cursor()
    call SudokuSolver#Canvus#draw_cursor(l:row, l:col)

    mapclear <buffer>
    nnoremap h :call SudokuSolver#GUI#move_cursor_left()<CR>
    nnoremap j :call SudokuSolver#GUI#move_cursor_down()<CR>
    nnoremap k :call SudokuSolver#GUI#move_cursor_up()<CR>
    nnoremap l :call SudokuSolver#GUI#move_cursor_right()<CR>
    nnoremap <Left>     :call SudokuSolver#GUI#move_cursor_left()<CR>
    nnoremap <Down>     :call SudokuSolver#GUI#move_cursor_down()<CR>
    nnoremap <Up>       :call SudokuSolver#GUI#move_cursor_up()<CR>
    nnoremap <Right>    :call SudokuSolver#GUI#move_cursor_right()<CR>
    nnoremap <C-r>      :SudokuSolver<CR>
    nnoremap <Space>    :call SudokuSolver#Solver#solve()<CR>

    nnoremap 0 :call SudokuSolver#GUI#set_number(0)<CR>
    nnoremap 1 :call SudokuSolver#GUI#set_number(1)<CR>
    nnoremap 2 :call SudokuSolver#GUI#set_number(2)<CR>
    nnoremap 3 :call SudokuSolver#GUI#set_number(3)<CR>
    nnoremap 4 :call SudokuSolver#GUI#set_number(4)<CR>
    nnoremap 5 :call SudokuSolver#GUI#set_number(5)<CR>
    nnoremap 6 :call SudokuSolver#GUI#set_number(6)<CR>
    nnoremap 7 :call SudokuSolver#GUI#set_number(7)<CR>
    nnoremap 8 :call SudokuSolver#GUI#set_number(8)<CR>
    nnoremap 9 :call SudokuSolver#GUI#set_number(9)<CR>
endfunction

command! SudokuSolver :call <SID>init()
