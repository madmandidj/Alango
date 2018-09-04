function expectedTrigTimesSeconds = CreateExpectedTrigTimesCells(_numOfVoices, _numOfLevels, _numOfTrigs)
  curTimeInSecs = 0;
%%  maxDetectionOffsetSecs = 2;
  roundTrigToFirstTrigSecs = 30;
  internalTrigToInternalTrigSecs = 10;
  lastInternalTrigToRoundTrigSecs = 11;
%%  lastInternalTrigToLastTrigSecs = 11;
  
%%  numOfVoices = 10;
%%  numOfLevels = 3;
%%  numOfTrigs = 5;
%%  totalNumOfTriggers = numOfVoices * numOfLevels * numOfTrigs;
  
  curTrigNum = 1;
  expectedTrigTimesSeconds(curTrigNum,1) = 0;
  for curVoice = 1:_numOfVoices
    for curLevel = 1:_numOfLevels
      ++curTrigNum;
      curTimeInSecs += roundTrigToFirstTrigSecs;
      expectedTrigTimesSeconds(curTrigNum,1) = curTimeInSecs;
      for curTrigger = 1:_numOfTrigs-1
        ++curTrigNum;
        curTimeInSecs += internalTrigToInternalTrigSecs;
        expectedTrigTimesSeconds(curTrigNum,1) = curTimeInSecs;
      endfor
      ++curTrigNum;
      curTimeInSecs += lastInternalTrigToRoundTrigSecs;
      expectedTrigTimesSeconds(curTrigNum,1) = curTimeInSecs;
    endfor
  endfor
endfunction
