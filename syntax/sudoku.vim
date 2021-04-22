highlight clear

syntax match  SudokuGrid  /\v[═║╔╦╗╠╬╣╚╩╝│─┌┬┐├┼┤└┴┘]/
highlight def SudokuGrid  ctermfg=DarkGray

syntax match  SudokuColorMark    /\V{white}/ conceal
syntax match  SudokuColorMark    /\V{cyan}/ conceal
syntax match  SudokuColorMark    /\V{end}/ conceal
syntax match  SudokuCyanColoredText  /\v(\V{cyan}\v)@<=([^}]*)(\V{end}\v)@=/
highlight def SudokuCyanColoredText  ctermfg=DarkCyan

syntax match  SudokuWhiteColoredText  /\v(\V{white}\v)@<=([^}]*)(\V{end}\v)@=/
highlight def SudokuWhiteColoredText  ctermfg=LightGray
