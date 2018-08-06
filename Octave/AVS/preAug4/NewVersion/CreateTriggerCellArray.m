function triggerTable = CreateTriggerCellArray(_strCells)
  numOfRows = rows(_strCells);
  curTrigTableRow = 1;
  if (!strcmp(char(_strCells(1,1)), "Home"))
    error("Amazon.Alexa.com website format has probably changed!");
  endif
  for curRow = 2:numOfRows
    curRowStr = char(_strCells(curRow, 1));
    prevRowStr = char(_strCells(curRow - 1, 1));
    if (!isempty(strfind(curRowStr, "PM")) || !isempty(strfind(curRowStr, "AM")))
      triggerTable(curTrigTableRow, 1) = _strCells(curRow - 1, 1);
      triggerTable(curTrigTableRow, 2) = _strCells(curRow, 1);
      ++curTrigTableRow;
    endif
  endfor
endfunction