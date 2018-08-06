function resultsStats = GenerateResultsStats(_resultsWithTriggerID, _actualTrigNum, _unrecNum, _partialNum, _dupNum, _illegalNum, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)
  numOfCols = columns(_resultsWithTriggerID);
  numOfRows = rows(_resultsWithTriggerID);
  resultsStats = cell(numOfRows,3);
  resultsStats(:,:) = cellstr("");
  noiseCol = numOfCols - 2;
  distCol = numOfCols - 1;
  trigCol = numOfCols;
  curRow = 1;
  totalNumOfTriggers = _noiseTotalNum * _distInNoiseNum * _trigInDistNum;
%%  Total stats vars
  totalRecognizedNum = 0;
  totalRecognizedPercentage = 0;
  totalFailedNum = 0;
  totalFailedPercentage = 0;
%% Noise Group stats vars
  noiseRecognizedNum = cell(_noiseTotalNum,1);
  noiseRecognizedNum(:,1) = 0;
  noiseRecognizedPercentage = cell(_noiseTotalNum,1);
  noiseFailedNum = cell(_noiseTotalNum,1);
  noiseFailedNum(:,1) = 0;
  noiseFailedPercentage = cell(_noiseTotalNum,1);
  
%% Distance Group stats vars
  distRecognizedNum = cell(_distInNoiseNum,1);
  distRecognizedNum(:,1) = 0;
  distRecognizedPercentage = cell(_distInNoiseNum,1);
  distRecognizedPercentage(:,1) = 0;

%% Trigger Group stats vars
  triggerRecognizedNum = cell(_trigInDistNum,1);
  triggerRecognizedNum(:,1) = 0;
  triggerRecognizedPercentage = cell(_trigInDistNum,1);
  triggerRecognizedPercentage(:,1) = 0;
  
  %%  Total stats
  curStatsRow = 1;
  for curTrig = 1 : numOfRows
    if (iscellstr(_resultsWithTriggerID(curTrig, 1)))
      ++totalRecognizedNum;
    else  
      ++totalFailedNum;
    endif
  endfor
  totalRecognizedPercentage = 100 * (totalRecognizedNum / numOfRows);
  totalFailedPercentage = 100 * (totalFailedNum / numOfRows);
  resultsStats(curStatsRow,1) = cellstr("Total Statistics");
  resultsStats(curStatsRow,2:3) = cellstr("");
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Triggers Per Distance");
  resultsStats(curStatsRow,2) = cellstr(num2str(_trigInDistNum));
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Distance Per Noise");
  resultsStats(curStatsRow,2) = cellstr(num2str(_distInNoiseNum));
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Noise Groups");
  resultsStats(curStatsRow,2) = cellstr(num2str(_noiseTotalNum));
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Total Number Of Triggers");
  resultsStats(curStatsRow,2) = cellstr(num2str(totalNumOfTriggers));
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Total Actual Number Of Triggers");
  resultsStats(curStatsRow,2) = cellstr(num2str(_actualTrigNum));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Recognized Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(totalRecognizedNum));
  resultsStats(curStatsRow, 3) = cellstr(sprintf("%s%s",num2str(totalRecognizedPercentage), "%"));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Failed (Unrecognized + Partial) Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(totalFailedNum));
  resultsStats(curStatsRow, 3) = cellstr(sprintf("%s%s",num2str(totalFailedPercentage), "%"));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Partial Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(_partialNum));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Unrecognized Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(_unrecNum));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Duplicate Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(_dupNum));
  ++curStatsRow;
  resultsStats(curStatsRow, 1) = cellstr("Total Illegal Num");
  resultsStats(curStatsRow, 2) = cellstr(num2str(_illegalNum));
  ++curStatsRow;
  
  %%Two Blank Rows
  resultsStats(curStatsRow, 1:2) = {"",""};
  ++curStatsRow;
  resultsStats(curStatsRow, 1:2) = {"",""};
  ++curStatsRow;
  
  %%  Noise group stats
  curTrigger = 0;
  for curNoise = 1:_noiseTotalNum
    for curDist = 1:_distInNoiseNum
      for curTrig = 1:_trigInDistNum
        ++curTrigger;
        newCount = cell2mat(noiseRecognizedNum(curNoise,1));
        ++newCount;
        if (iscellstr(_resultsWithTriggerID(curTrigger, 1)))
          noiseRecognizedNum(curNoise,1) = newCount;
        else  
          noiseFailedNum(curNoise,1) = newCount;
        endif
      endfor
    endfor
  endfor
  for curNoise = 1:_noiseTotalNum
    recognizedForNoise = cell2mat(noiseRecognizedNum(curNoise,1));
    noiseRecognizedPercentage(curNoise,1) = 100 * (recognizedForNoise / (_trigInDistNum * _distInNoiseNum));
  endfor
  resultsStats(curStatsRow,1) = cellstr("Noise Group Statistics");
  resultsStats(curStatsRow,2) = cellstr("");
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Triggers Per Noise Group");
  resultsStats(curStatsRow,2) = cellstr(num2str(_trigInDistNum * _distInNoiseNum));
  ++curStatsRow;
  for curNoise = 1 : _noiseTotalNum
    recognizedForNoise = cell2mat(noiseRecognizedNum(curNoise,1));
    resultsStats(curStatsRow, 1) = cellstr(sprintf("%s %d Recognized Num", "Noise Group", curNoise));
    resultsStats(curStatsRow, 2) = cellstr(num2str(recognizedForNoise));
    resultsStats(curStatsRow, 3) = cellstr(sprintf("%d%s",cell2mat(noiseRecognizedPercentage(curNoise,1)), "%"));
    ++curStatsRow;
  endfor

  %%Two Blank Rows
  resultsStats(curStatsRow, 1:3) = {"","", ""};
  ++curStatsRow;
  resultsStats(curStatsRow, 1:3) = {"","", ""};
  ++curStatsRow;
  
  %%  Distance group stats
  curTrigger = 0;
  for curNoise = 1:_noiseTotalNum
    for curDist = 1:_distInNoiseNum
      for curTrig = 1:_trigInDistNum
        ++curTrigger;
        newCount = cell2mat(distRecognizedNum(curDist,1));
        ++newCount;
        if (iscellstr(_resultsWithTriggerID(curTrigger, 1)))
          distRecognizedNum(curDist,1) = newCount;
        endif
      endfor
    endfor
  endfor
  for curDist = 1:_distInNoiseNum
    recognizedForDist = cell2mat(distRecognizedNum(curDist,1));
    distRecognizedPercentage(curDist,1) = 100 * (recognizedForDist / (_noiseTotalNum * _trigInDistNum));
  endfor
  resultsStats(curStatsRow,1) = cellstr("Distance Group Statistics");
  resultsStats(curStatsRow,2:3) = cellstr("");
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Triggers Per Distance Group");
  resultsStats(curStatsRow,2) = cellstr(num2str(_noiseTotalNum * _trigInDistNum));
  resultsStats(curStatsRow,3) = cellstr("");
  ++curStatsRow;
  for curDist = 1 : _distInNoiseNum
    recognizedForDist = cell2mat(distRecognizedNum(curDist,1));
    resultsStats(curStatsRow, 1) = cellstr(sprintf("%s %d Recognized Num", "Distance Group", curDist));
    resultsStats(curStatsRow, 2) = cellstr(num2str(recognizedForDist));
    resultsStats(curStatsRow, 3) = cellstr(sprintf("%d%s",cell2mat(distRecognizedPercentage(curDist,1)), "%"));
    ++curStatsRow;
  endfor

  %%Two Blank Rows
  resultsStats(curStatsRow, 1:3) = {"","", ""};
  ++curStatsRow;
  resultsStats(curStatsRow, 1:3) = {"","", ""};
  ++curStatsRow;
  
  %%  Trigger group stats
  curTrigger = 0;
  for curNoise = 1:_noiseTotalNum
    for curDist = 1:_distInNoiseNum
      for curTrig = 1:_trigInDistNum
        ++curTrigger;
        newCount = cell2mat(triggerRecognizedNum(curTrig,1));
        ++newCount;
        if (iscellstr(_resultsWithTriggerID(curTrigger, 1)))
          triggerRecognizedNum(curTrig,1) = newCount;
        endif
      endfor
    endfor
  endfor
  for curTrig = 1:_trigInDistNum
    recognizedForTrig = cell2mat(triggerRecognizedNum(curTrig,1));
    triggerRecognizedPercentage(curTrig,1) = 100 * (recognizedForTrig / (_noiseTotalNum * _distInNoiseNum));
  endfor
  resultsStats(curStatsRow,1) = cellstr("Individual Trigger Statistics");
  resultsStats(curStatsRow,2:3) = cellstr("");
  ++curStatsRow;
  resultsStats(curStatsRow,1) = cellstr("Expected Number Of Individual Triggers");
  resultsStats(curStatsRow,2) = cellstr(num2str(_noiseTotalNum * _distInNoiseNum));
  resultsStats(curStatsRow,3) = cellstr("");
  ++curStatsRow;
  for curTrig = 1 : _trigInDistNum
    recognizedForTrig = cell2mat(triggerRecognizedNum(curTrig,1));
    resultsStats(curStatsRow, 1) = cellstr(sprintf("%s %d Recognized Num", "Individual Trigger", curTrig));
    resultsStats(curStatsRow, 2) = cellstr(num2str(recognizedForTrig));
    resultsStats(curStatsRow, 3) = cellstr(sprintf("%d%s",cell2mat(triggerRecognizedPercentage(curTrig,1)), "%"));
    ++curStatsRow;
  endfor

endfunction
