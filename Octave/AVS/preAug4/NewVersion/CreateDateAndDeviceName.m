function dateAndNameCells = CreateDateAndDeviceName(_verifCells)
  numOfRows = rows(_verifCells);
  for curRow =1:numOfRows
    dateAndNameCells(curRow, 1) = _verifCells(curRow, 1);
    wholeStr = strsplit(char(_verifCells(curRow,2)));
    dateStr = char(wholeStr(1, 1));
    timeStr = char(wholeStr(1, 3));
    ampmStr = char(wholeStr(1, 4));
    deviceStr = char(wholeStr(1, 6));
%%    if (strcmp(dateStr, "Today"))
%%      dateStr = date;
%%    endif
    dateAndNameCells(curRow, 2) = sprintf("%s, %s %s", dateStr, timeStr, ampmStr);
    dateAndNameCells(curRow, 3) = deviceStr;
  endfor
endfunction
