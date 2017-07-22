function! SudokuSolver#GUI#init ()
    let s:row = 0
    let s:col = 0
    let s:sudoku_data = []
    for l:row in range(9)
        call add(s:sudoku_data, [])
        for l:col in range(9)
            call add(s:sudoku_data[(l:row)], {
                        \ 'num': 0,
                        \ 'is_input': 0,
                        \ })
        endfor
    endfor

    let l:test_data = [
                \ '104963850',
                \ '280104903',
                \ '396085074',
                \ '417300285',
                \ '508407306',
                \ '639020417',
                \ '740639028',
                \ '802701609',
                \ '063852740',
                \ ]
    let s:sudoku_data = []
    for l:row in range(9)
        call add(s:sudoku_data, [])
        for l:col in range(9)
            call add(s:sudoku_data[(l:row)], {
                        \ 'num': str2nr(l:test_data[(l:row)][(l:col)]),
                        \ 'is_input': v:true,
                        \ })
        endfor
    endfor
endfunction


function! SudokuSolver#GUI#cursor ()
    return [s:row, s:col]
endfunction


function! SudokuSolver#GUI#show_msg ()
    call SudokuSolver#GUI#alloc_line(27)
    call setline(21, 'h/j/k/l: move cursor')
    call setline(22, 'Arrow keys: move cursor')
    call setline(23, 'Number keys: set number')
    call setline(24, '<C-r>: reset')
    call setline(25, '<CR>: solve')
    call setline(26, '<Space>: unsolve')
    call cursor(27, 0)
endfunction


function SudokuSolver#GUI#move_cursor_left (...)
    call s:move_cursor(0, -1 * (a:0 == 1 ? a:1 : 1))
endfunction


function SudokuSolver#GUI#move_cursor_down (...)
    call s:move_cursor(1 * (a:0 == 1 ? a:1 : 1), 0)
endfunction


function SudokuSolver#GUI#move_cursor_up (...)
    call s:move_cursor(-1 * (a:0 == 1 ? a:1 : 1), 0)
endfunction


function SudokuSolver#GUI#move_cursor_right (...)
    call s:move_cursor(0, 1 * (a:0 == 1 ? a:1 : 1))
endfunction


function! s:move_cursor (drow, dcol)
    if 0 <= s:row + a:drow && s:row + a:drow <= 8
        let s:row += a:drow
    endif

    if 0 <= s:col + a:dcol && s:col + a:dcol <= 8
        let s:col += a:dcol
    endif

    call SudokuSolver#GUI#draw_frame()
    call SudokuSolver#GUI#draw_numbers()
    call SudokuSolver#GUI#draw_cursor()
endfunction


function! SudokuSolver#GUI#set_number (...)
    if a:0 == 1
        " Called from GUI
        let l:row = s:row
        let l:col = s:col
        let l:num = a:1
        let s:sudoku_data[(l:row)][(l:col)]['is_input'] = v:true
    elseif a:0 == 3
        let l:row = a:1
        let l:col = a:2
        let l:num = a:3
    endif
    let s:sudoku_data[(l:row)][(l:col)]['num'] = l:num
    call SudokuSolver#GUI#draw_number(l:row, l:col)
endfunction


function! SudokuSolver#GUI#draw_frame ()
    call SudokuSolver#GUI#alloc_line(19)

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


function! SudokuSolver#GUI#draw_number (row, col)
    let l:val = s:sudoku_data[(a:row)][(a:col)]['num']
    let l:is_input = s:sudoku_data[(a:row)][(a:col)]['is_input']
    let l:cvs_row = (a:row + 1) * 2
    let l:cvs_col = (a:col + 1) * 4 + (a:col > 2 ? 1 : 0) + (a:col > 5 ? 1 : 0)

    let l:line = getline(l:cvs_row)

    call setline(l:cvs_row,
                \ strpart(l:line, 0, l:cvs_col - 2)
                \ . (l:is_input ? ' ' : '_') . (l:val ? l:val : ' ') . (l:is_input ? ' ' : '_') .
                \ strpart(l:line, l:cvs_col + 1))
endfunction


function! SudokuSolver#GUI#draw_numbers ()
    for l:row in range(9)
        for l:col in range(9)
            call SudokuSolver#GUI#draw_number(l:row, l:col)
        endfor
    endfor
endfunction


function! SudokuSolver#GUI#alloc_line (nr)
    while line('$') < a:nr
        call append('$', '')
    endwhile
endfunction


function! SudokuSolver#GUI#canvas_clear ()
    normal! ggdG
endfunction


function! SudokuSolver#GUI#draw_cursor ()
    let l:cvs_row = (s:row + 1) * 2
    let l:cvs_col = (s:col + 1) * 4 + (s:col > 2 ? 1 : 0) + (s:col > 5 ? 1 : 0)

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


function! SudokuSolver#GUI#data ()
    let l:data = []
    for l:row in range(9)
        call add(l:data, [])
        for l:col in range(9)
            call add(l:data[(l:row)], s:sudoku_data[(l:row)][(l:col)]['num'])
        endfor
    endfor
    return l:data
endfunction


function! SudokuSolver#GUI#solve ()
    for l:row in range(9)
        for l:col in range(9)
            if s:sudoku_data[(l:row)][(l:col)]['num'] != 0
                let s:sudoku_data[(l:row)][(l:col)]['is_input'] = v:true
            else
                let s:sudoku_data[(l:row)][(l:col)]['is_input'] = v:false
            endif
        endfor
    endfor
    call SudokuSolver#GUI#draw_numbers()
    call SudokuSolver#Solver#solve()
endfunction


function! SudokuSolver#GUI#unsolve ()
    for l:row in range(9)
        for l:col in range(9)
            if s:sudoku_data[(l:row)][(l:col)]['is_input'] == v:false
                let s:sudoku_data[(l:row)][(l:col)]['num'] = 0
            endif
        endfor
    endfor
    call SudokuSolver#GUI#draw_numbers()
endfunction
