function trigTimesSeconds = CreateTrigTimesSecondsCells(_strCell)
  muxInternalTimeColumn = 12;
  numOfRows = rows(_strCell);
  secondsOffset = 0;
  for curRow = 1:numOfRows
    curStr = char(_strCell(curRow, 1));
    curStrSplit = strsplit(curStr, " ");
    trigTimesSeconds(curRow,1) = round(str2num(char(curStrSplit(1,muxInternalTimeColumn))) / 1000) - secondsOffset;
    if (1 == curRow)
      secondsOffset = trigTimesSeconds(curRow,1);
      trigTimesSeconds(curRow,1) = 0;
    endif
  endfor
  
endfunction
