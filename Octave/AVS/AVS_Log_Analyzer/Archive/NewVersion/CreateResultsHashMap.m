function [resultsHashMap, duplicateCells, illegalCells] = CreateResultsHashMap(_recognizedCells, _totalNumOfTriggers, _detectionColumnNum)
  numOfRows = rows(_recognizedCells);
  resultsHashMap = cell(_totalNumOfTriggers, _totalNumOfTriggers);
  resultsMapCount = cell(_totalNumOfTriggers, 1);
  resultsMapCount(:,:) = 0;
  duplicateCells = cell(0,0);
  illegalCells = cell(0,0);
  curDuplicateRow = 1;
  curIllegalRow = 1;
  for curRow = 1:numOfRows
    curMapRow = str2num(char(_recognizedCells(curRow, _detectionColumnNum)));
    newstr = char(_recognizedCells(curRow, 1)); 
    for i = 2:_detectionColumnNum
      newstr = cstrcat(newstr, " ", char(_recognizedCells(curRow, i)));
    endfor
    if (curMapRow > _totalNumOfTriggers || 0 > curMapRow)
      illegalCells(curIllegalRow, 1) = newstr;
      ++curIllegalRow;
      continue;
    endif
    numOfElemInBucket = cell2mat(resultsMapCount(curMapRow,1));
    resultsMapCount(curMapRow,1) = numOfElemInBucket + 1; 
    if (1 == numOfElemInBucket + 1)
      resultsHashMap(curMapRow, numOfElemInBucket + 1) = newstr;
    else
      duplicateCells(curDuplicateRow, 1) = newstr;
      ++curDuplicateRow;
    endif
  endfor
endfunction