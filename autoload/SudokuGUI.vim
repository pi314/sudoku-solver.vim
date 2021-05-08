" SudokuGUI: handles everything related to user interface


let s:cursor = [0, 0]
let s:pencil_color = SudokuBoard#WHITE

let s:color_map = {
            \ SudokuBoard#WHITE: 'white',
            \ SudokuBoard#PENCIL: 'cyan',
            \ }

let s:grid_data = [
            \ ['╔', '═══', '═', '═══', '═', '═══', '╦', '═══', '═', '═══', '═', '═══', '╦', '═══', '═', '═══', '═', '═══', '╗'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['╠', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╣'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['╠', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╬', '═══', '═', '═══', '═', '═══', '╣'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║', '───', '┼', '───', '┼', '───', '║'],
            \ ['║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║', '   ', '│', '   ', '│', '   ', '║'],
            \ ['╚', '═══', '═', '═══', '═', '═══', '╩', '═══', '═', '═══', '═', '═══', '╩', '═══', '═', '═══', '═', '═══', '╝'],
            \ ]

let s:menu_items = [
            \ 'Control:',
            \ '',
            \ '1 ~ 9 :  Set number at cursor',
            \ 'x     :  Clear number at cursor',
            \ '',
            \ 'c : Switch between pencil colors',
            \ ['s:render_menu_item_pencil_color', [SudokuBoard#WHITE]],
            \ ['s:render_menu_item_pencil_color', [SudokuBoard#PENCIL]],
            \ '',
            \ 'Arrow keys : Move cursor',
            \ 'h/j/k/l :    Move cursor',
            \ '',
            \ 'H/J/K/L : Move cursor by 3 blocks',
            \ '',
            \ '#Space : Clear all {cyan}pencil{end} marks',
            \ '',
            \ '#R : Reset',
            \ ]


function! s:switch_to_next_pencil_color ()
    if s:pencil_color == g:SudokuBoard#WHITE
        let s:pencil_color = g:SudokuBoard#PENCIL

    elseif s:pencil_color == g:SudokuBoard#PENCIL
        let s:pencil_color = g:SudokuBoard#WHITE

    endif
    call SudokuGUI#render_all()
endfunction


function! s:render_menu_item_pencil_color (color)
    if a:color == g:SudokuBoard#WHITE
        return '    ('. (s:pencil_color == g:SudokuBoard#WHITE ? 'O' : ' ') .') white - setup quiz'
    elseif a:color == g:SudokuBoard#PENCIL
        return '    ('. (s:pencil_color == g:SudokuBoard#PENCIL ? 'O' : ' ') .') {cyan}cyan{end} - your pencil'
    endif
endfunction


function! s:render_sudoku_grid (lnum)
    if s:pencil_color == g:SudokuBoard#WHITE
        let l:color_tag = '{white}'

    elseif s:pencil_color == g:SudokuBoard#PENCIL
        let l:color_tag = '{cyan}'

    endif

    let l:ret = copy(s:grid_data[(a:lnum)])

    if a:lnum == (s:cursor[0]*2)
        let l:ret[(s:cursor[1]*2+0)] = l:color_tag . '┏'
        let l:ret[(s:cursor[1]*2+1)] = '━━━'
        let l:ret[(s:cursor[1]*2+2)] = '┓' . '{end}'

    elseif a:lnum == (s:cursor[0]*2+1)
        let l:ret[(s:cursor[1]*2+0)] = l:color_tag . '┃' . '{end}'
        let l:ret[(s:cursor[1]*2+2)] = l:color_tag . '┃' . '{end}'

    elseif a:lnum == (s:cursor[0]*2+2)
        let l:ret[(s:cursor[1]*2+0)] = l:color_tag . '┗'
        let l:ret[(s:cursor[1]*2+1)] = '━━━'
        let l:ret[(s:cursor[1]*2+2)] = '┛' . '{end}'

    endif

    if a:lnum % 2 == 1
        let l:row = (a:lnum - 1) / 2

        for l:i in range(9)
            let l:num = SudokuBoard#get_num(l:row, l:i)
            if l:num == 0
                let l:ret[1 + (l:i * 2)] = '   '
            else
                let l:ret[1 + (l:i * 2)] = ' {' . s:color_map[SudokuBoard#get_color(l:row, l:i)] . '}' . l:num . '{end} '
            endif
        endfor
    endif

    return l:ret
endfunction


function! SudokuGUI#render_line (lnum)
    if a:lnum < len(s:grid_data)
        call setline(1 + a:lnum, join(s:render_sudoku_grid(a:lnum), ''))
        return
    endif

    let l:menu_item = s:menu_items[(a:lnum - len(s:grid_data))]

    if type(l:menu_item) == v:t_string
        call setline(1 + a:lnum + len(s:grid_data), l:menu_item)
    elseif type(l:menu_item) == v:t_list
        call setline(1 + a:lnum + len(s:grid_data), call(function(l:menu_item[0]), l:menu_item[1]))
    endif

endfunction


function! SudokuGUI#render_all ()
    for l:lnum in range(19)
        call setline(l:lnum + 1, join(s:render_sudoku_grid(l:lnum), ''))
    endfor

    for l:lnum in range(len(s:menu_items))
        let l:menu_item = s:menu_items[(l:lnum)]
        if type(l:menu_item) == v:t_string
            call setline(l:lnum + 20, l:menu_item)
        elseif type(l:menu_item) == v:t_list
            call setline(l:lnum + 20, call(function(l:menu_item[0]), l:menu_item[1]))
        endif
    endfor

    call cursor('$', 1)
endfunction


function! s:move_cursor(row, col)
    let l:old_cursor_row = s:cursor[0]

    let s:cursor[0] += a:row
    let s:cursor[1] += a:col
    if (s:cursor[0] < 0) || (s:cursor[0] > 8) || (s:cursor[1] < 0) || (s:cursor[1] > 8)
        let s:cursor[0] -= a:row
        let s:cursor[1] -= a:col
    endif

    call SudokuGUI#render_line(l:old_cursor_row * 2)
    call SudokuGUI#render_line(l:old_cursor_row * 2 + 1)
    call SudokuGUI#render_line(l:old_cursor_row * 2 + 2)
    if l:old_cursor_row != s:cursor[0]
        call SudokuGUI#render_line(s:cursor[0] * 2)
        call SudokuGUI#render_line(s:cursor[0] * 2 + 1)
        call SudokuGUI#render_line(s:cursor[0] * 2 + 2)
    endif
endfunction


function! s:set_number(num)
    call SudokuBoard#set_num(s:cursor[0], s:cursor[1], a:num, s:pencil_color)
    call SudokuGUI#render_line(s:cursor[0] * 2 + 1)
endfunction


function! SudokuGUI#init ()
    mapclear
    nnoremap <silent> c :call <SID>switch_to_next_pencil_color()<CR>
    nnoremap <silent> <left>  :call <SID>move_cursor(0, -1)<CR>
    nnoremap <silent> <down>  :call <SID>move_cursor(1, 0)<CR>
    nnoremap <silent> <up>    :call <SID>move_cursor(-1, 0)<CR>
    nnoremap <silent> <right> :call <SID>move_cursor(0, 1)<CR>
    nnoremap <silent> h       :call <SID>move_cursor(0, -1)<CR>
    nnoremap <silent> j       :call <SID>move_cursor(1, 0)<CR>
    nnoremap <silent> k       :call <SID>move_cursor(-1, 0)<CR>
    nnoremap <silent> l       :call <SID>move_cursor(0, 1)<CR>
    nnoremap <silent> H :call <SID>move_cursor(0, -3)<CR>
    nnoremap <silent> J :call <SID>move_cursor(3, 0)<CR>
    nnoremap <silent> K :call <SID>move_cursor(-3, 0)<CR>
    nnoremap <silent> L :call <SID>move_cursor(0, 3)<CR>

    nnoremap <silent> x :call <SID>set_number(0)<CR>
    nnoremap <silent> 1 :call <SID>set_number(1)<CR>
    nnoremap <silent> 2 :call <SID>set_number(2)<CR>
    nnoremap <silent> 3 :call <SID>set_number(3)<CR>
    nnoremap <silent> 4 :call <SID>set_number(4)<CR>
    nnoremap <silent> 5 :call <SID>set_number(5)<CR>
    nnoremap <silent> 6 :call <SID>set_number(6)<CR>
    nnoremap <silent> 7 :call <SID>set_number(7)<CR>
    nnoremap <silent> 8 :call <SID>set_number(8)<CR>
    nnoremap <silent> 9 :call <SID>set_number(9)<CR>

    function! s:alloc_line (nr)
        while line('$') < a:nr
            call append('$', '')
        endwhile
    endfunction

    call s:alloc_line(len(s:grid_data) + 1 + len(s:menu_items))

    call SudokuGUI#render_all()
endfunction
