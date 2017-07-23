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

    call SudokuSolver#MainSolver#init()
    call SudokuSolver#GUI#init()

    call SudokuSolver#GUI#canvas_clear()
    call SudokuSolver#GUI#draw_frame()
    call SudokuSolver#GUI#show_msg()
    call SudokuSolver#GUI#draw_numbers()

    call SudokuSolver#GUI#draw_cursor()

    mapclear <buffer>
    nnoremap h :call SudokuSolver#GUI#move_cursor_left()<CR>
    nnoremap j :call SudokuSolver#GUI#move_cursor_down()<CR>
    nnoremap k :call SudokuSolver#GUI#move_cursor_up()<CR>
    nnoremap l :call SudokuSolver#GUI#move_cursor_right()<CR>
    nnoremap H :call SudokuSolver#GUI#move_cursor_left(3)<CR>
    nnoremap J :call SudokuSolver#GUI#move_cursor_down(3)<CR>
    nnoremap K :call SudokuSolver#GUI#move_cursor_up(3)<CR>
    nnoremap L :call SudokuSolver#GUI#move_cursor_right(3)<CR>
    nnoremap <Left>     :call SudokuSolver#GUI#move_cursor_left()<CR>
    nnoremap <Down>     :call SudokuSolver#GUI#move_cursor_down()<CR>
    nnoremap <Up>       :call SudokuSolver#GUI#move_cursor_up()<CR>
    nnoremap <Right>    :call SudokuSolver#GUI#move_cursor_right()<CR>
    nnoremap <C-r>      :SudokuSolver<CR>
    nnoremap s          :call SudokuSolver#GUI#solve_one()<CR>
    nnoremap S          :call SudokuSolver#GUI#solve()<CR>
    nnoremap <Space>    :call SudokuSolver#GUI#unsolve()<CR>

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
