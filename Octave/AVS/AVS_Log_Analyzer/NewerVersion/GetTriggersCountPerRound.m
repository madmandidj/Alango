function triggersCountPerRound = GetTriggersCountPerRound(_flippedCells, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, _triggerWord)
  numOfRounds = _noiseTotalNum * _distInNoiseNum;
  triggersCountPerRound = cell(numOfRounds, 4);
  roundIdentifierStr = "alexa round";
  recognizedTrigIdentifierStr = "alexa stop";
  numOfRows = rows(_flippedCells);
  curRoundRow = 0;
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  
  for curRow = 1:numOfRows-1
    curRowStr = char(_flippedCells(curRow, 1));
    if (!isempty(strfind(curRowStr, roundIdentifierStr)))
      triggersCountPerRound(curRoundRow + 1, 1) = cellstr(num2str(ParseLineTextNumToNum(curRowStr)));
      if (0 != curRoundRow)
%%        triggersCountPerRound(curRoundRow, 1) = cellstr(num2str(ParseLineTextNumToNum(curRowStr)));
        triggersCountPerRound(curRoundRow, 2) = cellstr(num2str(numOfRecognized));
        triggersCountPerRound(curRoundRow, 3) = cellstr(num2str(numOfUnrecognized));
        triggersCountPerRound(curRoundRow, 4) = cellstr(num2str(_trigInDistNum - numOfRecognized));
      endif
      ++curRoundRow;
      numOfRecognized = 0;
      numOfUnrecognized = 0;
      continue;
    endif
    if (strcmp(curRowStr, recognizedTrigIdentifierStr))
      ++numOfRecognized;
    else
      ++numOfUnrecognized;
    endif
  endfor
    triggersCountPerRound(curRoundRow, 2) = cellstr(num2str(numOfRecognized));
    triggersCountPerRound(curRoundRow, 3) = cellstr(num2str(numOfUnrecognized));
    triggersCountPerRound(curRoundRow, 4) = cellstr(num2str(_trigInDistNum - numOfRecognized));
endfunction
