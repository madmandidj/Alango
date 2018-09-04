function statsCells = CreateStatsCells(_voiceResults, _levelResults, _roundResults, _voiceStrings, _levelStrings, _numOfVoices, _numOfLevels, _numOfTrigs)
%%  numOfRows = rows(_triggersCountPerRound);
  statsCells = cell(0);
  curStatsRow = 1;
  totalNumOfTriggers = _numOfVoices * _numOfLevels * _numOfTrigs;
  numOfTrigsPerVoice = _numOfLevels * _numOfTrigs;
  numOfTrigsPerVoiceLevel = _numOfTrigs * _numOfVoices;
  roundCol = 1;
  recCol = 2;
  unrecCol = 3;
  missCol = 4;
  
  %% Expected numbers
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(_numOfTrigs)), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of voice-levels per voice"), cellstr(num2str(_numOfLevels)), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of voices total"), cellstr(num2str(_numOfVoices)), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice"), cellstr(num2str(numOfTrigsPerVoice)), cellstr(""));
  ++curStatsRow;  
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(numOfTrigsPerVoiceLevel)), cellstr(""));
  ++curStatsRow;  
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Total num of triggers"), cellstr(num2str(totalNumOfTriggers)), cellstr(""));
  ++curStatsRow;  
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;
  
  %% Overall test statsCells
  numOfRecognized = 0;
  for curRow = 1:rows(_roundResults)
    numOfRecognized += _roundResults(curRow, 1);
  endfor
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Overall Results");
  ++curStatsRow;
  statsCells = WriteAllTriggerResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, totalNumOfTriggers);
  ++curStatsRow;
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;
  
  %% Voice  stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice Results");
  ++curStatsRow;
  for curVoice = 1:_numOfVoices
    numOfRecognized = _voiceResults(curVoice,1);
    statsCells = WriteVoiceResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, numOfTrigsPerVoice, curVoice, char(_voiceStrings(curVoice, 1)));
    ++curStatsRow;
  endfor
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Voice-Level  stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice Level Results");
  ++curStatsRow;
  for curVoiceLevel = 1:_numOfLevels
    numOfRecognized = _levelResults(curVoiceLevel,1);
    statsCells = WriteVoiceLevelResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, numOfTrigsPerVoiceLevel, curVoiceLevel, char(_levelStrings(1,curVoiceLevel)));
    ++curStatsRow;
  endfor
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Round  stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Individual Round Results");
  ++curStatsRow;
  numOfRecognized = 0;
  for curRow = 1:rows(_roundResults)
    curVoice = ceil((curRow / _numOfLevels));
    curLevel = rem(curRow, 3);
    if (0 == curLevel)
      curLevel = 3;
    endif
    numOfRecognized = _roundResults(curRow, 1);
    statsCells = WriteRoundResultsRowToStatsCells(statsCells, curStatsRow, curRow, numOfRecognized, _numOfTrigs, char(_voiceStrings(curVoice, 1)), char(_levelStrings(1,curLevel)));
    ++curStatsRow;
  endfor
  
endfunction
