function triggerTable = CreateMultiRowTrigCellArray(_strCells)
  numOfRows = rows(_strCells);
  curTrigTableRow = 1;
  expectedFirstRowStringOfFile = "Home";
  expectedLastRowIrrelevantString = "None";
  if (!strcmp(char(_strCells(1,1)), expectedFirstRowStringOfFile))
    error("\n\n\nCreateMultiRowTrigCellArray Cant create trigCells: Alexa.Amazon.com website format has probably changed!\n\n\n");
  endif
  
  prevRow = FindLastIrrelevantRow(_strCells, expectedLastRowIrrelevantString);
  if (-1 == prevRow)
    error("\n\n Couldnt find last irrelevant row \n \n");
  endif
  ++prevRow;
  while (1)
    rowStr ="";
    curRow = FindNextRelevantRow(_strCells, prevRow);
    if (numOfRows == curRow || -1 == curRow)
      break;
    endif
    for rowNum = prevRow:curRow - 1
      rowStr = cstrcat(rowStr, char(_strCells(rowNum,1)));
      rowStr = cstrcat(rowStr, " ");
    endfor
    triggerTable(curTrigTableRow, 1) = cellstr(rowStr);
    triggerTable(curTrigTableRow, 2) = _strCells(curRow, 1);
    ++curTrigTableRow;
    prevRow = curRow + 1;
  endwhile
endfunction

%%Local Functions
function lastIrrelevantRow = FindLastIrrelevantRow(_strCells, expectedLastRowIrrelevantString)
  numOfRows = rows(_strCells);
  lastIrrelevantRow = -1;
  for curRow = 1:numOfRows
    if (strcmp(char(_strCells(curRow,1)), expectedLastRowIrrelevantString))
      lastIrrelevantRow = curRow;
      return;
    endif
  endfor
endfunction

function nextRelevantRow = FindNextRelevantRow(_strCells, _prevRow)
  nextRelevantRow = -1;
  numOfRows = rows(_strCells);
  for curRow = _prevRow + 1 : numOfRows
    curRowStr = char(_strCells(curRow, 1));
    if (!isempty(strfind(curRowStr, "PM")) || !isempty(strfind(curRowStr, "AM")))
      nextRelevantRow = curRow;
      return;
    endif
  endfor
  return;
endfunction
