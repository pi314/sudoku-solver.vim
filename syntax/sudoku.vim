highlight clear

syntax match  SudokuGrid  /═/
syntax match  SudokuGrid  /║/
syntax match  SudokuGrid  /╔/
syntax match  SudokuGrid  /╦/
syntax match  SudokuGrid  /╗/
syntax match  SudokuGrid  /╠/
syntax match  SudokuGrid  /╬/
syntax match  SudokuGrid  /╣/
syntax match  SudokuGrid  /╚/
syntax match  SudokuGrid  /╩/
syntax match  SudokuGrid  /╝/
syntax match  SudokuGrid  /│/
syntax match  SudokuGrid  /─/
syntax match  SudokuGrid  /┌/
syntax match  SudokuGrid  /┬/
syntax match  SudokuGrid  /┐/
syntax match  SudokuGrid  /├/
syntax match  SudokuGrid  /┼/
syntax match  SudokuGrid  /┤/
syntax match  SudokuGrid  /└/
syntax match  SudokuGrid  /┴/
syntax match  SudokuGrid  /┘/
highlight     SudokuGrid  ctermfg=DarkGray

syntax match  SudokuColorMark    /\V{white}/ conceal
syntax match  SudokuColorMark    /\V{cyan}/ conceal
syntax match  SudokuColorMark    /\V{end}/ conceal

syntax region SudokuCyanColoredText  matchgroup=SudokuColorMark start=/\V{cyan}/ end=/\V{end}/ concealends contains=SudokuColorMark
highlight     SudokuCyanColoredText  ctermfg=DarkCyan

syntax region SudokuWhiteColoredText  matchgroup=SudokuColorMark start=/\V{white}/ end=/\V{end}/ concealends contains=SudokuColorMark
highlight     SudokuWhiteColoredText  ctermfg=LightGray
