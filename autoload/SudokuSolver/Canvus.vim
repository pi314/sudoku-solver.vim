function! SudokuSolver#Canvus#draw_frame ()
    call SudokuSolver#Canvus#alloc_line(19)

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


function! SudokuSolver#Canvus#draw_number (row, col)
    let l:val = SudokuSolver#Solver#array(a:row, a:col)
    let l:cvs_row = (a:row + 1) * 2
    let l:cvs_col = (a:col + 1) * 4 + (a:col > 2 ? 1 : 0) + (a:col > 5 ? 1 : 0)

    let l:line = getline(l:cvs_row)

    call setline(l:cvs_row,
                \ strpart(l:line, 0, l:cvs_col - 1)
                \ . (l:val ? l:val : ' ') .
                \ strpart(l:line, l:cvs_col))
endfunction


function! SudokuSolver#Canvus#draw_numbers ()
    for l:row in range(9)
        for l:col in range(9)
            call SudokuSolver#Canvus#draw_number(l:row, l:col)
        endfor
    endfor
endfunction


function! SudokuSolver#Canvus#alloc_line (nr)
    while line('$') < a:nr
        call append('$', '')
    endwhile
endfunction


function! SudokuSolver#Canvus#canvas_clear ()
    normal! ggdG
endfunction


function! SudokuSolver#Canvus#draw_cursor (row, col)
    let l:val = SudokuSolver#Solver#array(a:row, a:col)
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
