function trigTimesSeconds = CreateTrigTimesSecondsCells(_strCell)
  muxInternalTimeColumn = 12;
  numOfRows = rows(_strCell);
  for curRow = 1:numOfRows
    curStr = char(_strCell(curRow, 1));
    curStrSplit = strsplit(curStr, " ");
    trigTimesSeconds(curRow,1) = round(str2num(char(curStrSplit(1,muxInternalTimeColumn))) / 1000);
  endfor
  
endfunction
