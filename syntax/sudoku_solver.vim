syn match   SudokuSolverNumberMarker    /\v_([0-9 ]_)@=/
syn match   SudokuSolverNumberMarker    /\v(_[0-9 ])@<=_/
syn match   SudokuSolverNumber          /\v(_)@<=[0-9 ](_)@=/
hi  def     SudokuSolverNumberMarker    ctermfg=black
hi  def     SudokuSolverNumber          ctermfg=darkcyan
