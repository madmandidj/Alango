function statsCells = GenerateStats(_triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)
%%  noiseGroupStrings = {"No noise", "Cafeteria noise", "Car noise", "Street noise", "Office noise", "Pink noise", "Speech noise"};
%%  snrGroupStrings = {"SNR = 18", "SNR = 9", "SNR = 6", "SNR = 3", "SNR = 0"};
  
  
  voiceStrings = {"Synth Male 1", 
                  "Human Male 1", 
                  "Human Male 2", 
                  "Synth Female 1", 
                  "Synth Female 2", 
                  "Human Female 1",
                  "Human Female 2",
                  "Synth Male 2",
                  "Human Male 3",
                  "Human Female 3"}; %%Change this to be: Human male, female, synth male, female
  levelStrings = {"0 dB", "-6 dB", "-12 dB"};
  
  
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
  
  function statsCells = WriteRowToStatsCells(_statsCells, _rowNum, _cellStr1, _cellStr2, _cellStr3, _cellStr4, _cellStr5, _cellStr6, _cellStr7)
    statsCells =_statsCells;
    statsCells(_rowNum,1) = _cellStr1;
    statsCells(_rowNum,2) = _cellStr2;
    statsCells(_rowNum,3) = _cellStr3;
    statsCells(_rowNum,4) = _cellStr4;
    statsCells(_rowNum,5) = _cellStr5;
    statsCells(_rowNum,6) = _cellStr6;
    statsCells(_rowNum,7) = _cellStr7;
  endfunction
  
  %% Expected numbers
%%  statsCells(curStatsRow,1) = cellstr("Num of triggers per voice-level");
%%  statsCells(curStatsRow,2) = cellstr(num2str(_trigInDistNum));
%%  statsCells(curStatsRow,3) = cellstr("");
%%  statsCells(curStatsRow,4) = cellstr("");
%%  statsCells(curStatsRow,5) = cellstr("");
%%  statsCells(curStatsRow,6) = cellstr("");
%%  statsCells(curStatsRow,7) = cellstr("");
  
  statsCells = WriteRowToStatsCells(statsCells, curStatsRow, cellstr("Num of triggers per voice-level"), cellstr(num2str(_trigInDistNum)), cellstr(""), cellstr(""), cellstr(""), cellstr(""), cellstr(""));
  ++curStatsRow;
  
  statsCells(curStatsRow,1) = cellstr("Num of voice-levels per voice");
  statsCells(curStatsRow,2) = cellstr(num2str(_distInNoiseNum));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Num of voices total");
  statsCells(curStatsRow,2) = cellstr(num2str(_noiseTotalNum));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Num of triggers per voice");
  statsCells(curStatsRow,2) = cellstr(num2str(numOfTrigsPerVoice));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Num of triggers per voice-level");
  statsCells(curStatsRow,2) = cellstr(num2str(numOfTrigsPerVoiceLevel));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Total num of triggers");
  statsCells(curStatsRow,2) = cellstr(num2str(totalNumOfTriggers));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  
  %% BLANK ROW
  statsCells(curStatsRow,1) = cellstr("");
  statsCells(curStatsRow,2) = cellstr("");
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
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
  statsCells(curStatsRow,1) = cellstr("Overall Results");
  statsCells(curStatsRow,2) = cellstr("recognized");
  statsCells(curStatsRow,3) = cellstr("recognized %");
  statsCells(curStatsRow,4) = cellstr("missed");
  statsCells(curStatsRow,5) = cellstr("missed %");
  statsCells(curStatsRow,6) = cellstr("unrecognized");
  statsCells(curStatsRow,7) = cellstr("unrecognized %");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("All triggers");
  statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
  statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/totalNumOfTriggers));
  statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
  statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/totalNumOfTriggers));
  statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
  statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/totalNumOfTriggers));
  
  %% BLANK ROW
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("");
  statsCells(curStatsRow,2) = cellstr("");
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  
  %% Voice  stats
  statsCells(curStatsRow,1) = cellstr("Voice Results");
  statsCells(curStatsRow,2) = cellstr("recognized");
  statsCells(curStatsRow,3) = cellstr("recognized %");
  statsCells(curStatsRow,4) = cellstr("missed");
  statsCells(curStatsRow,5) = cellstr("missed %");
  statsCells(curStatsRow,6) = cellstr("unrecognized");
  statsCells(curStatsRow,7) = cellstr("unrecognized %");
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
    statsCells(curStatsRow,1) = cellstr(sprintf("Voice %d, %s", curNoiseGroup, char(voiceStrings(curNoiseGroup, 1))));
    statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
    statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/numOfTrigsPerVoice));
    statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
    statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/numOfTrigsPerVoice));
    statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
    statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/numOfTrigsPerVoice));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
  
  %% BLANK ROW
  statsCells(curStatsRow,1) = cellstr("");
  statsCells(curStatsRow,2) = cellstr("");
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  
  %% Voice-Level stats
  statsCells(curStatsRow,1) = cellstr("Voice-Level Results");
  statsCells(curStatsRow,2) = cellstr("recognized");
  statsCells(curStatsRow,3) = cellstr("recognized %");
  statsCells(curStatsRow,4) = cellstr("missed");
  statsCells(curStatsRow,5) = cellstr("missed %");
  statsCells(curStatsRow,6) = cellstr("unrecognized");
  statsCells(curStatsRow,7) = cellstr("unrecognized %");
  ++curStatsRow;
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  for curSNRGroup = 1:_distInNoiseNum
    for curNoiseGroup = 1:_noiseTotalNum - 1
      curRound = (curNoiseGroup * _distInNoiseNum) + curSNRGroup;
      numOfRecognized += str2num(char(_triggersCountPerRound(curRound, recCol)));
      numOfUnrecognized += str2num(char(_triggersCountPerRound(curRound, unrecCol)));
      numOfMissed += str2num(char(_triggersCountPerRound(curRound, missCol)));
    endfor
    statsCells(curStatsRow,1) = cellstr(sprintf("Voice-Level %d, %s", curSNRGroup, char(levelStrings(1,curSNRGroup))));
    statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
    statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/numOfTrigsPerVoiceLevel));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("SNR Group %d missed", curSNRGroup));
    statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
    statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/numOfTrigsPerVoiceLevel));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("SNR Group %d unrecognized", curSNRGroup));
    statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
    statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/numOfTrigsPerVoiceLevel));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
  
    %% BLANK ROW
  statsCells(curStatsRow,1) = cellstr("");
  statsCells(curStatsRow,2) = cellstr("");
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  
  %% Individual Round stats
  statsCells(curStatsRow,1) = cellstr("Individual Round Results");
  statsCells(curStatsRow,2) = cellstr("recognized");
  statsCells(curStatsRow,3) = cellstr("recognized %");
  statsCells(curStatsRow,4) = cellstr("missed");
  statsCells(curStatsRow,5) = cellstr("missed %");
  statsCells(curStatsRow,6) = cellstr("unrecognized");
  statsCells(curStatsRow,7) = cellstr("unrecognized %");
  ++curStatsRow;
  numOfRecognized = 0;
  numOfUnrecognized = 0;
  numOfMissed = 0;
  for curRow = 1:numOfRows
    numOfRecognized = str2num(char(_triggersCountPerRound(curRow, recCol)));
    numOfUnecognized = str2num(char(_triggersCountPerRound(curRow, unrecCol)));
    numOfMissed = str2num(char(_triggersCountPerRound(curRow, missCol)));
    curNoiseGroup = ceil((curRow / _distInNoiseNum));
    voiceLevelIndex = rem(curRow,3);
    if (0 == voiceLevelIndex)
      voiceLevelIndex = 3;
    endif
    statsCells(curStatsRow,1) = cellstr(sprintf("Round %d, %s, %s", curRow, char(voiceStrings(curNoiseGroup, 1)), char(levelStrings(1,voiceLevelIndex))));
    statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
    statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/_trigInDistNum));
    statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
    statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/_trigInDistNum));
    statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
    statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/_trigInDistNum));
    ++curStatsRow;
    numOfRecognized = 0;
    numOfUnrecognized = 0;
    numOfMissed = 0;
  endfor
endfunction
