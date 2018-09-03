function expectedTrigTimesSeconds = CreateExpectedTrigTimesCells()
  curTimeInSecs = 0;
  maxDetectionOffsetSecs = 2;
  roundTrigToFirstTrigSecs = 30;
  internalTrigToInternalTrig = 10;
  lastInternalTrigToRoundTrig = 11;
  lastInternalTrigToLastTrig = 11;
  
  numOfVoices = 10;
  numOfLevels = 3;
  numOfTrigs = 5;
  totalNumOfTriggers = numOfVoices * numOfLevels * numOfTrigs;
  curTrigNum = 1;
  
endfunction
