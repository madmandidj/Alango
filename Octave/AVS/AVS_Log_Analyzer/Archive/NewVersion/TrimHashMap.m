function trimmedResults = TrimHashMap(_resultsHashMap)
  trimmedResults = _resultsHashMap;
  numOfRows = rows(_resultsHashMap);
  numOfCols = columns(_resultsHashMap);
  for curCol = 1:numOfCols
    isColEmpty = 1;
    curCol = numOfCols - curCol + 1;
    for curRow = 1:numOfRows
      if (iscellstr(_resultsHashMap (curRow,curCol)))
%        trimmedResults = resize(trimmedResults, numOfRows, curCol + 1);
        isColEmpty = 0;
%        return;
      endif
    endfor
    if (isColEmpty)
      trimmedResults = resize(trimmedResults, numOfRows, curCol - 1);
    else
      return
    endif
  endfor
endfunction