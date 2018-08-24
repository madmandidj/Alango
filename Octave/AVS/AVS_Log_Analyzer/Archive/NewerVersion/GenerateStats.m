function statsCells = GenerateStats(_triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)
  noiseGroupStrings = {"No noise", "Cafeteria noise", "Car noise", "Street noise", "Office noise", "Pink noise", "Speech noise"};
  snrGroupStrings = {"SNR = 18", "SNR = 9", "SNR = 6", "SNR = 3", "SNR = 0"};
  numOfRows = rows(_triggersCountPerRound);
  statsCells = cell(0);
  curStatsRow = 1;
  totalNumOfTriggers = _noiseTotalNum * _distInNoiseNum * _trigInDistNum;
  numOfTrigsPerNoiseGroup = _distInNoiseNum * _trigInDistNum;
  numOfTrigsPerSNRGroup = _trigInDistNum * (_noiseTotalNum - 1); %%first noise group doesnt count;
  roundCol = 1;
  recCol = 2;
  unrecCol = 3;
  missCol = 4;
  
  %% Expected numbers
  statsCells(curStatsRow,1) = cellstr("Num of triggers per SNR (""distance"") group");
  statsCells(curStatsRow,2) = cellstr(num2str(_trigInDistNum));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Num of SNR groups per noise group");
  statsCells(curStatsRow,2) = cellstr(num2str(_distInNoiseNum));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Num of noise groups");
  statsCells(curStatsRow,2) = cellstr(num2str(_noiseTotalNum));
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
  statsCells(curStatsRow,1) = cellstr("Total num of triggers per noise group");
  statsCells(curStatsRow,2) = cellstr(num2str(numOfTrigsPerNoiseGroup));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
  ++curStatsRow;
  statsCells(curStatsRow,1) = cellstr("Total num of triggers per SNR group");
  statsCells(curStatsRow,2) = cellstr(num2str(numOfTrigsPerSNRGroup));
  statsCells(curStatsRow,3) = cellstr("");
  statsCells(curStatsRow,4) = cellstr("");
  statsCells(curStatsRow,5) = cellstr("");
  statsCells(curStatsRow,6) = cellstr("");
  statsCells(curStatsRow,7) = cellstr("");
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
%%  ++curStatsRow;
%%  statsCells(curStatsRow,1) = cellstr("Total missed triggers");
  statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
  statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/totalNumOfTriggers));
%%    ++curStatsRow;
%%  statsCells(curStatsRow,1) = cellstr("Total unrecognized triggers");
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
  
  %% Noise group stats
  statsCells(curStatsRow,1) = cellstr("Noise group Results");
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
    statsCells(curStatsRow,1) = cellstr(sprintf("Noise Group %d, %s", curNoiseGroup, char(noiseGroupStrings(1,curNoiseGroup))));
    statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
    statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/numOfTrigsPerNoiseGroup));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("Noise Group %d missed", curNoiseGroup));
    statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
    statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/numOfTrigsPerNoiseGroup));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("Noise Group %d unrecognized", curNoiseGroup));
    statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
    statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/numOfTrigsPerNoiseGroup));
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
  
  %% SNR group stats
  statsCells(curStatsRow,1) = cellstr("SNR group Results");
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
    statsCells(curStatsRow,1) = cellstr(sprintf("SNR Group %d, %s", curSNRGroup, char(snrGroupStrings(1,curSNRGroup))));
    statsCells(curStatsRow,2) = cellstr(num2str(numOfRecognized));
    statsCells(curStatsRow, 3) = cellstr(sprintf("%.1f%%", 100 * numOfRecognized/numOfTrigsPerSNRGroup));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("SNR Group %d missed", curSNRGroup));
    statsCells(curStatsRow,4) = cellstr(num2str(numOfMissed));
    statsCells(curStatsRow,5) = cellstr(sprintf("%.1f%%", 100 * numOfMissed/numOfTrigsPerSNRGroup));
%%    ++curStatsRow;
%%    statsCells(curStatsRow,1) = cellstr(sprintf("SNR Group %d unrecognized", curSNRGroup));
    statsCells(curStatsRow,6) = cellstr(num2str(numOfUnrecognized));
    statsCells(curStatsRow,7) = cellstr(sprintf("%.1f%%", 100 * numOfUnrecognized/numOfTrigsPerSNRGroup));
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
%%    curSNRGroup = (curRow / _distInNoiseNum) + 1;
    statsCells(curStatsRow,1) = cellstr(sprintf("Round %d, %s", curRow, char(noiseGroupStrings(1,curNoiseGroup))));
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
