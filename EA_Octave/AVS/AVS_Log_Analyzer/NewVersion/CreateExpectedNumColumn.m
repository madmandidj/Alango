function expectedNumCells = CreateExpectedNumColumn(_flippedCells)
  numOfRows = rows(_flippedCells);
  for curRow = 1:numOfRows
    expectedNumCells(curRow, 1:3) = _flippedCells(curRow, 1:3); 
    expectedNumCells(curRow, 4) = cellstr(num2str(curRow));
  endfor
endfunction
