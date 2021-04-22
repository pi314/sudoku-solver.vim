let s:cursor = [0, 0]
let s:pencil_color = 'white'

let s:sudoku_buffer = []


let s:menu_items = [
            \ 'Control:',
            \ '',
            \ '1 ~ 9 :  Set number at cursor',
            \ '0     :  Clear number at cursor',
            \ '',
            \ 'c : Switch between pencil colors',
            \ ['s:render_menu_item_pencil_color', ['white']],
            \ ['s:render_menu_item_pencil_color', ['cyan']],
            \ '',
            \ 'Arrow keys : Move cursor',
            \ 'h/j/k/l :    Move cursor',
            \ '',
            \ 'H/J/K/L : Move cursor by 3 blocks',
            \ '',
            \ 'Space : Clear all {cyan}pencil{end} marks',
            \ '',
            \ 's : Try to solve the cell at cursor?',
            \ 'S : Solve all',
            \ '',
            \ 'R : Reset',
            \ ]


function! s:switch_to_next_pencil_color ()
    if s:pencil_color == 'white'
        let s:pencil_color = 'cyan'
    elseif s:pencil_color == 'cyan'
        let s:pencil_color = 'white'
    endif
    call SudokuGUI#render_all()
endfunction


function! s:render_menu_item_pencil_color (color)
    if a:color == 'white'
        return '    ('. (s:pencil_color == 'white' ? 'O' : ' ') .') white - quiz preset'
    elseif a:color == 'cyan'
        return '    ('. (s:pencil_color == 'cyan' ? 'O' : ' ') .') {cyan}cyan{end} - your pencil'
    endif
endfunction


function! s:render_sudoku_grid ()
    let l:ret = []

    call add(l:ret, ['╔', '═══', '═', '═══', '═', '═══', '╦', '═══', '═', '═══', '═', '═══', '╦', '═══', '═', '═══', '═', '═══', '╗'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['╠', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╣'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['╠', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╣'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'])
    call add(l:ret, ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'])
    call add(l:ret, ['╚', '═══', '═', '═══', '═', '═══', '╩', '═══', '═', '═══', '═', '═══', '╩', '═══', '═', '═══', '═', '═══', '╝'])

    let l:pencil_color_tag = '{' . s:pencil_color . '}'

    let l:ret[(s:cursor[0]*2)][(s:cursor[1]*2)] = l:pencil_color_tag . '┏' . '{end}'
    let l:ret[(s:cursor[0]*2)][(s:cursor[1]*2+1)] = l:pencil_color_tag . '━━━' . '{end}'
    let l:ret[(s:cursor[0]*2)][(s:cursor[1]*2+2)] = l:pencil_color_tag . '┓' . '{end}'
    let l:ret[(s:cursor[0]*2+1)][(s:cursor[1]*2)] = l:pencil_color_tag . '┃' . '{end}'
    let l:ret[(s:cursor[0]*2+1)][(s:cursor[1]*2+2)] = l:pencil_color_tag . '┃' . '{end}'
    let l:ret[(s:cursor[0]*2+2)][(s:cursor[1]*2)] = l:pencil_color_tag . '┗' . '{end}'
    let l:ret[(s:cursor[0]*2+2)][(s:cursor[1]*2+1)] = l:pencil_color_tag . '━━━' . '{end}'
    let l:ret[(s:cursor[0]*2+2)][(s:cursor[1]*2+2)] = l:pencil_color_tag . '┛' . '{end}'

    return l:ret
endfunction


function! SudokuGUI#render_all ()
    normal! ggdG

    for l:line in s:render_sudoku_grid()
        call append('$', join(l:line, ''))
    endfor

    for l:menu_item in s:menu_items
        if type(l:menu_item) == v:t_string
            call append('$', l:menu_item)
        elseif type(l:menu_item) == v:t_list
            call append('$', call(function(l:menu_item[0]), l:menu_item[1]))
        endif
    endfor

    normal! ggdd

    call append('$', '')
    call cursor('$', 1)
endfunction


function! s:move_cursor(row, col)
    let s:cursor[0] += a:row
    let s:cursor[1] += a:col
    if (s:cursor[0] < 0) || (s:cursor[0] > 8) || (s:cursor[1] < 0) || (s:cursor[1] > 8)
        let s:cursor[0] -= a:row
        let s:cursor[1] -= a:col
    endif
    call SudokuGUI#render_all()
endfunction


function! SudokuGUI#init ()
    nmapclear
    nnoremap c :call <SID>switch_to_next_pencil_color()<CR>
    nnoremap <left> :call <SID>move_cursor(0, -1)<CR>
    nnoremap <down> :call <SID>move_cursor(1, 0)<CR>
    nnoremap <up> :call <SID>move_cursor(-1, 0)<CR>
    nnoremap <right> :call <SID>move_cursor(0, 1)<CR>
    nnoremap H :call <SID>move_cursor(0, -3)<CR>
    nnoremap J :call <SID>move_cursor(3, 0)<CR>
    nnoremap K :call <SID>move_cursor(-3, 0)<CR>
    nnoremap L :call <SID>move_cursor(0, 3)<CR>

    call SudokuGUI#render_all()

endfunction
