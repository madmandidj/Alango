function detectedNumCells = CreateDetectedNumColumn(_expectedNumCells)
  numOfRows = rows(_expectedNumCells);
  for curRow = 1:numOfRows
    detectedNumCells(curRow, 1:4) = _expectedNumCells(curRow, 1:4); 
    detectedNumCells(curRow, 5) = cellstr(num2str(ParseLineTextNumToNum(char(_expectedNumCells(curRow, 1)))));
  endfor
endfunction
