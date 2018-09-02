function statsCells = GenerateStats(_triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, _voiceStrings, _levelStrings)
%%  noiseGroupStrings = {"No noise", "Cafeteria noise", "Car noise", "Street noise", "Office noise", "Pink noise", "Speech noise"};
%%  snrGroupStrings = {"SNR = 18", "SNR = 9", "SNR = 6", "SNR = 3", "SNR = 0"};
%%  _voiceStrings = {"Synth Male 1", 
%%                  "Human Male 1", 
%%                  "Human Male 2", 
%%                  "Synth Female 1", 
%%                  "Synth Female 2", 
%%                  "Human Female 1",
%%                  "Human Female 2",
%%                  "Synth Male 2",
%%                  "Human Male 3",
%%                  "Human Female 3"}; %%Change this to be: Human male, female, synth male, female
%%  levelStrings = {"0 dB", "-6 dB", "-12 dB"};
  numOfRows = rows(_triggersCountPerRound);
  statsCells = cell(0);
  curStatsRow = 1;
  totalNumOfTriggers = _noiseTotalNum * _distInNoiseNum * _trigInDistNum;
  numOfTrigsPerVoice = _distInNoiseNum * _trigInDistNum;
  numOfTrigsPerVoiceLevel = _trigInDistNum * _noiseTotalNum;
  roundCol = 1;
  recCol = 2;
  unrecCol = 3;
  missCol = 4;
  
  %% Expected numbers
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(_trigInDistNum)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of voice-levels per voice"), cellstr(num2str(_distInNoiseNum)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of voices total"), cellstr(num2str(_noiseTotalNum)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice"), cellstr(num2str(numOfTrigsPerVoice)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;  
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(numOfTrigsPerVoiceLevel)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;  
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Total num of triggers"), cellstr(num2str(totalNumOfTriggers)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;  
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Overall test statsCells
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  recognizedPercentage = 0;
  unrecognizedPercentage = 0;
  missedPercentage = 0;
  for curRow = 1:numOfRows
    numOfRecognized += str2num(char(_triggersCountPerRound(curRow, recCol)));
    numOfUnrecognized += str2num(char(_triggersCountPerRound(curRow, unrecCol)));
    numOfMissed += str2num(char(_triggersCountPerRound(curRow, missCol))); 
  endfor
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Overall Results");
  ++curStatsRow;
  statsCells = WriteAllTriggerResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, numOfMissed, numOfUnrecognized, totalNumOfTriggers);
  ++curStatsRow;
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Voice  stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice Results");
  ++curStatsRow;
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  for curNoiseGroup = 1:_noiseTotalNum
    for curSNR = 1:_distInNoiseNum
      numOfRecognized += str2num(char(_triggersCountPerRound(((curNoiseGroup - 1)*_distInNoiseNum) + curSNR, recCol)));
      numOfUnrecognized += str2num(char(_triggersCountPerRound(((curNoiseGroup - 1)*_distInNoiseNum) + curSNR, unrecCol)));
      numOfMissed += str2num(char(_triggersCountPerRound(((curNoiseGroup - 1)*_distInNoiseNum) + curSNR, missCol))); 
    endfor
    statsCells = WriteVoiceResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, numOfMissed, numOfUnrecognized, numOfTrigsPerVoice, curNoiseGroup, char(_voiceStrings(curNoiseGroup, 1)));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Voice-Level stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Voice-Level Results");
  ++curStatsRow;

  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  for curSNRGroup = 1:_distInNoiseNum
    for curNoiseGroup = 1:_noiseTotalNum
      curRound = ((curNoiseGroup-1) * _distInNoiseNum) + curSNRGroup;
      numOfRecognized += str2num(char(_triggersCountPerRound(curRound, recCol)));
      numOfUnrecognized += str2num(char(_triggersCountPerRound(curRound, unrecCol)));
      numOfMissed += str2num(char(_triggersCountPerRound(curRound, missCol)));
    endfor
    statsCells = WriteVoiceLevelResultsRowToStatsCells(statsCells, curStatsRow, numOfRecognized, numOfMissed, numOfUnrecognized, numOfTrigsPerVoiceLevel, curSNRGroup, char(_levelStrings(1,curSNRGroup)));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
  
  %% BLANK-ROW
  statsCells = WriteBlankRowToStatsCells(statsCells, curStatsRow);
  ++curStatsRow;  
  
  %% Individual Round stats
  statsCells = WriteResultsHeaderRowToStatsCells(statsCells, curStatsRow, "Individual Round Results");
  ++curStatsRow;
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  for curRow = 1:numOfRows
    numOfRecognized = str2num(char(_triggersCountPerRound(curRow, recCol)));
    numOfUnrecognized = str2num(char(_triggersCountPerRound(curRow, unrecCol)));
    numOfMissed = str2num(char(_triggersCountPerRound(curRow, missCol)));
    curNoiseGroup = ceil((curRow / _distInNoiseNum));
    voiceLevelIndex = rem(curRow,3);
    if (0 == voiceLevelIndex)
      voiceLevelIndex = 3;
    endif
    statsCells = WriteRoundResultsRowToStatsCells(statsCells, curStatsRow, curRow, numOfRecognized, numOfMissed, numOfUnrecognized, _trigInDistNum, char(_voiceStrings(curNoiseGroup, 1)), char(_levelStrings(1,voiceLevelIndex)));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
endfunction




%%function statsCells = WriteRowToStatsCells(_statsCells, _rowNum, _cellStr1, _cellStr2, _cellStr3, _cellStr4, _cellStr5, _cellStr6, _cellStr7)
%%  statsCells =_statsCells;
%%  statsCells(_rowNum,1) = _cellStr1;
%%  statsCells(_rowNum,2) = _cellStr2;
%%  statsCells(_rowNum,3) = _cellStr3;
%%  statsCells(_rowNum,4) = _cellStr4;
%%  statsCells(_rowNum,5) = _cellStr5;
%%  statsCells(_rowNum,6) = _cellStr6;
%%  statsCells(_rowNum,7) = _cellStr7;
%%endfunction

%%function statsCells = WriteBlankRowToStatsCells(_statsCells, _rowNum)
%%  statsCells =_statsCells;
%%  statsCells(_rowNum,1) = cellstr("");
%%  statsCells(_rowNum,2) = cellstr("");
%%  statsCells(_rowNum,3) = cellstr("");
%%  statsCells(_rowNum,4) = cellstr("");
%%  statsCells(_rowNum,5) = cellstr("");
%%  statsCells(_rowNum,6) = cellstr("");
%%  statsCells(_rowNum,7) = cellstr("");
%%endfunction

%%function statsCells = WriteResultsHeaderRowToStatsCells(_statsCells, _rowNum, _str1)
%%  statsCells =_statsCells;
%%  statsCells(_rowNum,1) = cellstr(_str1);
%%  statsCells(_rowNum,2) = cellstr("recognized");
%%  statsCells(_rowNum,3) = cellstr("recognized %");
%%  statsCells(_rowNum,4) = cellstr("missed");
%%  statsCells(_rowNum,5) = cellstr("missed %");
%%  statsCells(_rowNum,6) = cellstr("unrecognized");
%%  statsCells(_rowNum,7) = cellstr("unrecognized %");
%%endfunction

%%function statsCells = WriteAllTriggerResultsRowToStatsCells(_statsCells, _rowNum, _rec, _missed, _unrec, _numOfTrigs)
%%  statsCells = _statsCells;
%%  statsCells(_rowNum,1) = cellstr("All triggers");
%%  statsCells(_rowNum,2) = cellstr(num2str(_rec));
%%  statsCells(_rowNum, 3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
%%  statsCells(_rowNum,4) = cellstr(num2str(_missed));
%%  statsCells(_rowNum,5) = cellstr(sprintf("%.1f%%", 100 * _missed/_numOfTrigs));
%%  statsCells(_rowNum,6) = cellstr(num2str(_unrec));
%%  statsCells(_rowNum,7) = cellstr(sprintf("%.1f%%", 100 * _unrec/_numOfTrigs));
%%endfunction

%%function statsCells = WriteVoiceResultsRowToStatsCells(_statsCells, _rowNum, _rec, _missed, _unrec, _numOfTrigs, _curNoiseGroup, _voiceStr)
%%  statsCells = _statsCells;
%%  statsCells(_rowNum,1) = cellstr(sprintf("Voice %d, %s", _curNoiseGroup, _voiceStr));
%%  statsCells(_rowNum,2) = cellstr(num2str(_rec));
%%  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
%%  statsCells(_rowNum,4) = cellstr(num2str(_missed));
%%  statsCells(_rowNum,5) = cellstr(sprintf("%.1f%%", 100 * _missed/_numOfTrigs));
%%  statsCells(_rowNum,6) = cellstr(num2str(_unrec));
%%  statsCells(_rowNum,7) = cellstr(sprintf("%.1f%%", 100 * _unrec/_numOfTrigs));
%%endfunction

%%function statsCells = WriteVoiceLevelResultsRowToStatsCells(_statsCells, _rowNum, _rec, _missed, _unrec, _numOfTrigs, _curSNRGroup, _voiceLevStr)
%%  statsCells = _statsCells;
%%  statsCells(_rowNum,1) = cellstr(sprintf("Voice-Level %d, %s", _curSNRGroup, _voiceLevStr));
%%  statsCells(_rowNum,2) = cellstr(num2str(_rec));
%%  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
%%  statsCells(_rowNum,4) = cellstr(num2str(_missed));
%%  statsCells(_rowNum,5) = cellstr(sprintf("%.1f%%", 100 * _missed/_numOfTrigs));
%%  statsCells(_rowNum,6) = cellstr(num2str(_unrec));
%%  statsCells(_rowNum,7) = cellstr(sprintf("%.1f%%", 100 * _unrec/_numOfTrigs));
%%endfunction

%%function statsCells = WriteRoundResultsRowToStatsCells(_statsCells, _rowNum, _rec, _missed, _unrec, _numOfTrigs, _voiceStr, _voiceLevStr)
%%  statsCells = _statsCells;
%%  statsCells(_rowNum,1) = cellstr(sprintf("Round %d, %s, %s", _rowNum, _voiceStr, _voiceLevStr));
%%  statsCells(_rowNum,2) = cellstr(num2str(_rec));
%%  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
%%  statsCells(_rowNum,4) = cellstr(num2str(_missed));
%%  statsCells(_rowNum,5) = cellstr(sprintf("%.1f%%", 100 * _missed/_numOfTrigs));
%%  statsCells(_rowNum,6) = cellstr(num2str(_unrec));
%%  statsCells(_rowNum,7) = cellstr(sprintf("%.1f%%", 100 * _unrec/_numOfTrigs));
%%endfunction