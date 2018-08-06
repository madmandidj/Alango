function verifiedTrigTable = CreateSingleRowTrigCellArray(_trigCells, _triggerWord)
  numOfRows = rows(_trigCells);
  curVerTrigTabRow = 1;
  shouldSkipLine = 0;
  curRow = 0;
  for curRow = 1:numOfRows-1
    if(shouldSkipLine)
      shouldSkipLine = 0;
      continue;
    endif
    curRowStr = char(_trigCells(curRow, 1));
    nextRowStr = char(_trigCells(curRow + 1, 1));
    if (isempty(strfind(curRowStr, _triggerWord)))
      if(!strcmp(nextRowStr,_triggerWord))
        error(printf("\n\n CreateSingleRowTrigCellArray Cant create verifCells, problem in _trigCells row-numbers: %d, %d\n\n\n", curRow, curRow + 1));
      endif
      verifiedTrigTable(curVerTrigTabRow, 1) = cellstr(cstrcat(nextRowStr, " ", curRowStr));
      verifiedTrigTable(curVerTrigTabRow, 2) = _trigCells(curRow + 1, 2);
      ++curVerTrigTabRow;
      curRow += 5;
      shouldSkipLine = 1;
      continue;
    endif
    verifiedTrigTable(curVerTrigTabRow, 1) = _trigCells(curRow, 1);
    verifiedTrigTable(curVerTrigTabRow, 2) = _trigCells(curRow, 2);
    ++curVerTrigTabRow;
  endfor
  if(strcmp(char(_trigCells(numOfRows,1)),_triggerWord))
    return;
  endif
  verifiedTrigTable(curVerTrigTabRow, 1) = _trigCells(numOfRows, 1);
  verifiedTrigTable(curVerTrigTabRow, 2) = _trigCells(numOfRows, 2);
endfunction
