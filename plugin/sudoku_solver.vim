"==============================================================================
" File: sudoku_solver.vim
" Author: https://github.com/pi314
"==============================================================================


function! s:alloc_line (nr)
    while line('$') < a:nr
        call append('$', '')
    endwhile
endfunction


function! s:canvas_clear ()
    normal! ggdG
endfunction


function! s:draw_frame ()
    call s:alloc_line(19)

    call setline(1,  ".=======================================.")
    call setline(2,  "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(3,  "||---:---:---||---:---:---||---:---:---||")
    call setline(4,  "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(5,  "||---:---:---||---:---:---||---:---:---||")
    call setline(6,  "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(7,  "|=======================================|")
    call setline(8,  "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(9,  "||---:---:---||---:---:---||---:---:---||")
    call setline(10, "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(11, "||---:---:---||---:---:---||---:---:---||")
    call setline(12, "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(13, "|=======================================|")
    call setline(14, "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(15, "||---:---:---||---:---:---||---:---:---||")
    call setline(16, "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(17, "||---:---:---||---:---:---||---:---:---||")
    call setline(18, "||   :   :   ||   :   :   ||   :   :   ||")
    call setline(19, "'======================================='")
endfunction


function! s:draw_number (row, col)
    let l:val = s:sudoku_ary[(a:row)][(a:col)]
    let l:cvs_row = (a:row + 1) * 2
    let l:cvs_col = (a:col + 1) * 4 + (a:col > 2 ? 1 : 0) + (a:col > 5 ? 1 : 0)

    let l:line = getline(l:cvs_row)

    call setline(l:cvs_row,
                \ strpart(l:line, 0, l:cvs_col - 1)
                \ . (l:val ? l:val : ' ') .
                \ strpart(l:line, l:cvs_col))
endfunction


function! s:draw_numbers ()
    for l:row in range(9)
        for l:col in range(9)
            call s:draw_number(l:row, l:col)
        endfor
    endfor
endfunction


function! s:draw_cursor (row, col)
    let l:val = s:sudoku_ary[(a:row)][(a:col)]
    let l:cvs_row = (a:row + 1) * 2
    let l:cvs_col = (a:col + 1) * 4 + (a:col > 2 ? 1 : 0) + (a:col > 5 ? 1 : 0)

    let l:line1 = getline(l:cvs_row - 1)
    let l:line2 = getline(l:cvs_row)
    let l:line3 = getline(l:cvs_row + 1)

    call setline(l:cvs_row - 1,
                \ strpart(l:line1, 0, l:cvs_col - 3)
                \ .'#####'.
                \ strpart(l:line1, l:cvs_col + 2))
    call setline(l:cvs_row,
                \ strpart(l:line2, 0, l:cvs_col - 3)
                \ .'#'. strpart(l:line2, l:cvs_col - 2, 3) .'#'.
                \ strpart(l:line2, l:cvs_col + 2))
    call setline(l:cvs_row + 1,
                \ strpart(l:line3, 0, l:cvs_col - 3)
                \ .'#####'.
                \ strpart(l:line3, l:cvs_col + 2))
endfunction


function! s:show_msg ()
    call s:alloc_line(23)

    call setline(21, 'Use h/j/k/l to move cursor')
    call setline(22, 'Use number keys to set number')
    call cursor(23, 0)
endfunction


function! s:move_cursor (drow, dcol)
    if 0 <= s:row + a:drow && s:row + a:drow <= 8
        let s:row += a:drow
    endif

    if 0 <= s:col + a:dcol && s:col + a:dcol <= 8
        let s:col += a:dcol
    endif

    call s:draw_frame()
    call s:draw_numbers()
    call s:draw_cursor(s:row, s:col)
endfunction


function! s:set_number (num)
    let s:sudoku_ary[(s:row)][(s:col)] = a:num
    call s:draw_number(s:row, s:col)
endfunction


function! s:init ()
    " if bufname('%') == '' && &modified == 0 && line('$') == 1 && getline(1) == ''
    " else
    "     tabedit
    " endif
    set buftype=nofile

    let s:sudoku_ary = []
    for l:row in range(9)
        call add(s:sudoku_ary, [])
        for l:col in range(9)
            call add(s:sudoku_ary[(l:row)], 0)
        endfor
    endfor
    let s:row = 0
    let s:col = 0

    call s:canvas_clear()
    call s:draw_frame()
    call s:show_msg()
    call s:draw_numbers()
    call s:draw_cursor(s:row, s:col)

    mapclear <buffer>
    nnoremap h :call <SID>move_cursor(0, -1)<CR>
    nnoremap j :call <SID>move_cursor(1, 0)<CR>
    nnoremap k :call <SID>move_cursor(-1, 0)<CR>
    nnoremap l :call <SID>move_cursor(0, 1)<CR>

    nnoremap 0 :call <SID>set_number(0)<CR>
    nnoremap 1 :call <SID>set_number(1)<CR>
    nnoremap 2 :call <SID>set_number(2)<CR>
    nnoremap 3 :call <SID>set_number(3)<CR>
    nnoremap 4 :call <SID>set_number(4)<CR>
    nnoremap 5 :call <SID>set_number(5)<CR>
    nnoremap 6 :call <SID>set_number(6)<CR>
    nnoremap 7 :call <SID>set_number(7)<CR>
    nnoremap 8 :call <SID>set_number(8)<CR>
    nnoremap 9 :call <SID>set_number(9)<CR>
endfunction

command! SudokuSolver :call <SID>init()
