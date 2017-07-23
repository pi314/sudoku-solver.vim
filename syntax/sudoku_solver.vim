syn match   SudokuSolverNumberMarker    /\v_([0-9 ]_)@=/
syn match   SudokuSolverNumberMarker    /\v(_[0-9 ])@<=_/
syn match   SudokuSolverNumber          /\v(_)@<=[0-9 ](_)@=/
hi  def     SudokuSolverNumberMarker    ctermfg=black
hi  def     SudokuSolverNumber          ctermfg=darkcyan

syn match   SudokuSolverHypoNumberMarker    /\v;([0-9 ];)@=/
syn match   SudokuSolverHypoNumberMarker    /\v(;[0-9 ])@<=;/
syn match   SudokuSolverHypoNumber          /\v(;)@<=[0-9 ](;)@=/
hi  def     SudokuSolverHypoNumberMarker    ctermfg=black
hi  def     SudokuSolverHypoNumber          ctermfg=darkgreen
