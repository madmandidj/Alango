function excludedStatsCells = GenerateExcludedStats(_excludedTriggersCountPerRound, _excludeRoundsArray, _voicesNum, _levelsInVoiceNum, _trigsInLevelNum, _voiceStrings, _levelStrings)
  newNumOfRounds = rows(_excludedTriggersCountPerRound);
  excludedStatsCells = cell(0);
  curStatsRow = 1;
  roundCol = 1;
  recCol = 2;
  unrecCol = 3;
  missCol = 4;
  activeRoundsCountCol = 5;
  curRound = 1;
  curLevel = 1;
  curVoice = 1;
  
  newAllTriggerStats = cell(_voicesNum * _levelsInVoiceNum, 5);
  newAllTriggerStats(:,roundCol) = num2cell(0);
  for (curRow = 1:rows(newAllTriggerStats))
    newAllTriggerStats(curRow, recCol) = num2cell(0);
    newAllTriggerStats(curRow, missCol) = num2cell(0);
    newAllTriggerStats(curRow, unrecCol) = num2cell(0);
    newAllTriggerStats(curRow, activeRoundsCountCol) = num2cell(0);
  endfor
  
  newVoiceStats = cell(_voicesNum,5);
  newVoiceStats (:,roundCol) = num2cell(0);
  for (curRow = 1:rows(newVoiceStats))
    newVoiceStats(curRow, recCol) = num2cell(0);
    newVoiceStats(curRow, missCol) = num2cell(0);
    newVoiceStats(curRow, unrecCol) = num2cell(0);
    newVoiceStats(curRow, activeRoundsCountCol) = num2cell(0);
  endfor
  
  newLevelStats = cell(_levelsInVoiceNum,5);
  newLevelStats (:,roundCol) = num2cell(0);
  for (curRow = 1:rows(newLevelStats))
    newLevelStats(curRow, recCol) = num2cell(0);
    newLevelStats(curRow, missCol) = num2cell(0);
    newLevelStats(curRow, unrecCol) = num2cell(0);
    newLevelStats(curRow, activeRoundsCountCol) = num2cell(0);
  endfor

  newLevelStatsIndex = 1;
  newVoiceStatsIndex = 1;
  newAllTriggersStatsIndex = 1;
  
  curExcludedCountPerRoundIndex = 1;
  curNewStatsRound = 1;
  expectedRound = 1;
  excludedCountRound = 1;
  
  while(curNewStatsRound <= newNumOfRounds)
    excludedCountRound = str2num(cell2mat(_excludedTriggersCountPerRound(curExcludedCountPerRoundIndex, roundCol)));
    if (expectedRound != excludedCountRound)
      ++expectedRound;
      continue;
    endif
    curVoice = floor((excludedCountRound-1) / _levelsInVoiceNum) + 1;
    curLevel = rem(excludedCountRound, _levelsInVoiceNum);
    if (0 == curLevel)
      curLevel = 3;
    endif
    curRoundRec = cell2mat(_excludedTriggersCountPerRound(curExcludedCountPerRoundIndex, recCol));
    curRoundMissed = cell2mat(_excludedTriggersCountPerRound(curExcludedCountPerRoundIndex, missCol));
    curRoundUnrec = cell2mat(_excludedTriggersCountPerRound(curExcludedCountPerRoundIndex, unrecCol));
    newLevelStats{curLevel, roundCol} = curLevel; 
    newLevelStats{curLevel, recCol} = newLevelStats{curLevel, recCol} + str2num(curRoundRec);
    newLevelStats{curLevel, unrecCol} = newLevelStats{curLevel, unrecCol} + str2num(curRoundUnrec);
    newLevelStats{curLevel, missCol} = newLevelStats{curLevel, missCol} + str2num(curRoundMissed);
    newLevelStats{curLevel, activeRoundsCountCol} = newLevelStats{curLevel, activeRoundsCountCol} + 1;
    
    newVoiceStats{curVoice, roundCol} = curVoice; 
    newVoiceStats{curVoice, recCol} = newVoiceStats{curVoice, recCol} + str2num(curRoundRec);
    newVoiceStats{curVoice, unrecCol} = newVoiceStats{curVoice, unrecCol} + str2num(curRoundUnrec);
    newVoiceStats{curVoice, missCol} = newVoiceStats{curVoice, missCol} + str2num(curRoundMissed);
    newVoiceStats{curVoice, activeRoundsCountCol} = newVoiceStats{curVoice, activeRoundsCountCol} + 1;
    
    newAllTriggerStats(1,roundCol) = 1;
    newAllTriggerStats{1, recCol} = newAllTriggerStats{1, recCol} + str2num(curRoundRec);
    newAllTriggerStats{1, unrecCol} = newAllTriggerStats{1, unrecCol} + str2num(curRoundUnrec);
    newAllTriggerStats{1, missCol} = newAllTriggerStats{1, missCol} + str2num(curRoundMissed);
    newAllTriggerStats{1, activeRoundsCountCol} = newAllTriggerStats{1, activeRoundsCountCol} + 1;
    
    ++curExcludedCountPerRoundIndex;
    ++expectedRound;
    ++curNewStatsRound;
  endwhile
  
  newNumOfTotalTriggers = _trigsInLevelNum * rows(_excludedTriggersCountPerRound);
  curStatsRow = 1;
  statsCells = cell(0,0);
  
    
  %% Expected numbers
  excludedRoundsStr = "";
  for curExcRound = 1: columns(_excludeRoundsArray)
    curStr = num2str(_excludeRoundsArray{1,curExcRound});
    excludedRoundsStr = sprintf("%s, %s", excludedRoundsStr, curStr);
  endfor
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Excluded Rounds"), cellstr(excludedRoundsStr), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(_trigsInLevelNum)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Total num of triggers"), cellstr(num2str(newNumOfTotalTriggers)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;  
  
    %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
%%    %% Overall test statsCells
%%  numOfRecognized = 0;
%%  numOfUnrecognized = 0;
%%  numOfMissed = 0;
%%  recognizedPercentage = 0;
%%  unrecognizedPercentage = 0;
%%  missedPercentage = 0;
%%  for curRow = 1:numOfRows
%%    numOfRecognized += str2num(char(_triggersCountPerRound(curRow, recCol)));
%%    numOfUnrecognized += str2num(char(_triggersCountPerRound(curRow, unrecCol)));
%%    numOfMissed += str2num(char(_triggersCountPerRound(curRow, missCol))); 
%%  endfor
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Overall Results");
  ++curStatsRow;
  statsCells = WriteAllTriggerResultsRowToStatsCells(statsCells, curStatsRow, newAllTriggerStats{1, recCol}, newAllTriggerStats{1, missCol}, newAllTriggerStats{1, unrecCol}, newNumOfTotalTriggers);
  ++curStatsRow;
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow; 
  
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice Results");
  ++curStatsRow;
  for curRow = 1:rows(newVoiceStats)
    curLevelNumOfRec = newVoiceStats{curRow, recCol};
    curLevelNumOfMissed = newVoiceStats{curRow, missCol};
    curLevelNumOfUnrec = newVoiceStats{curRow, unrecCol};
    curLevelExpectedNumOfTrigs = newVoiceStats{curRow, activeRoundsCountCol} * _trigsInLevelNum;
    statsCells = WriteVoiceResultsRowToStatsCells(statsCells, curStatsRow, curLevelNumOfRec, curLevelNumOfMissed, curLevelNumOfUnrec, curLevelExpectedNumOfTrigs, curRow, char(_voiceStrings(curRow,1)));
    ++curStatsRow;
  endfor
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice Level Results");
  ++curStatsRow;
  for curRow = 1:rows(newLevelStats)
    curLevelNumOfRec = newLevelStats{curRow, recCol};
    curLevelNumOfMissed = newLevelStats{curRow, missCol};
    curLevelNumOfUnrec = newLevelStats{curRow, unrecCol};
    curLevelExpectedNumOfTrigs = newLevelStats{curRow, activeRoundsCountCol} * _trigsInLevelNum;
    statsCells = WriteVoiceLevelResultsRowToStatsCells(statsCells, curStatsRow, curLevelNumOfRec, curLevelNumOfMissed, curLevelNumOfUnrec, curLevelExpectedNumOfTrigs, curRow, char(_levelStrings(1,curRow)));
    ++curStatsRow;
  endfor
  
    %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Rounds Results");
  ++curStatsRow;
  
  for curRow = 1:rows(_excludedTriggersCountPerRound)
    curLevelNumOfRec = str2num(_excludedTriggersCountPerRound{curRow, recCol});
    curLevelNumOfMissed = str2num(_excludedTriggersCountPerRound{curRow, missCol});
    curLevelNumOfUnrec = str2num(_excludedTriggersCountPerRound{curRow, unrecCol});
    curLevelExpectedNumOfTrigs = _trigsInLevelNum;
    
    excludedCountRound = str2num(cell2mat(_excludedTriggersCountPerRound(curRow, roundCol)));
    curVoice = floor((excludedCountRound-1) / _levelsInVoiceNum) + 1;
    curLevel = rem(excludedCountRound, _levelsInVoiceNum);
    if (0 == curLevel)
      curLevel = 3;
    endif
    
    statsCells = WriteRoundResultsRowToStatsCells(statsCells, curStatsRow, excludedCountRound, curLevelNumOfRec, curLevelNumOfMissed, curLevelNumOfUnrec, curLevelExpectedNumOfTrigs, char(_voiceStrings(curVoice,1)), char(_levelStrings(1,curLevel)));
%%    _statsCells, _rowNum, _rec, _missed, _unrec, _numOfTrigs, _voiceStr, _voiceLevStr
    ++curStatsRow;
  endfor

  excludedStatsCells = statsCells;
endfunction
