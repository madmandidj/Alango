function [voiceResults, levelResults, roundResults] = CreateIndividualResults(_resultArray, _numOfVoices, _numOfLevels, _numOfTrigs)
%%  numOfVoices = 10;
%%  numOfLevels = 3;
%%  numOfTrigs = 5;
%%  totalNumOfTriggers = numOfVoices * numOfLevels * numOfTrigs;
  curTrigNum = 0;
  curNumOfTrigsInRound = 0;
  curRound = 0;
  levelResults = zeros(_numOfLevels,1);
  voiceResults = zeros(_numOfVoices,1);
  for curVoice = 1:_numOfVoices
    for curLevel = 1:_numOfLevels
      curNumOfTrigsInRound = 0;
      ++curTrigNum;
      for curTrigger = 1:_numOfTrigs
        ++curTrigNum;
        curNumOfTrigsInRound += _resultArray(curTrigNum,1);
      endfor
      ++curRound;
      roundResults(curRound, 1) = curNumOfTrigsInRound;
      levelResults(curLevel, 1) += curNumOfTrigsInRound;
      voiceResults(curVoice, 1) += curNumOfTrigsInRound;
%%      ++curTrigNum;
    endfor
  endfor
endfunction
