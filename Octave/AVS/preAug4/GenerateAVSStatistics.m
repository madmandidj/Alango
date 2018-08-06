%%  DESCRIPTION:
%%  INPUT: 
%%  OUTPUT:
%%  ERRORS: 
%%  LAST MODIFIED: 26/07/2018

function statisticsTable = GenerateAVSStatistics(resultsTable, 
                            trigNum, distNum, noiseNum)
  expectedTrigColumn = 4;
  detectedTrigColumn = 5;
  idTrigColumn = 6;
  numOfRows = rows(resultsTable);                            
  curStatTabRow = 1;                            
  totalNumOfTriggers = trigNum * distNum * noiseNum;
%%  GENERAL STATS
  statisticsTable(curStatTabRow,1) = cellstr("*** GENERAL STATS ***");
  statisticsTable(curStatTabRow,2) = cellstr("");
  
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("Expected triggers");
  statisticsTable(curStatTabRow,2) = totalNumOfTriggers;
  
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("Detected triggers");
  isFound = 0;
  curFoundRow = numOfRows;
  while (!isFound)
    if (0 == curFoundRow)
      statisticsTable(curStatTabRow,2) = 0;
      break;
    endif 
    curStr = char(resultsTable(curFoundRow, expectedTrigColumn));
    if (strcmp(curStr, "-1"))
      --curFoundRow;
    else
      statisticsTable(curStatTabRow,2) = resultsTable(curFoundRow, expectedTrigColumn);
      isFound = 1;
      break;
    endif
  endwhile
  if(!isFound)
    statisticsTable(curStatTabRow,2) = 0;
  endif
  
  ++curStatTabRow;
  numOfVerified = 0;
  statisticsTable(curStatTabRow,1) = cellstr("Verified triggers");
  for curRow = 1:numOfRows
    isVerified = IsTriggerVerified(resultsTable, curRow);
    switch (isVerified)
      case 1
        ++numOfVerified;
      otherwise
        continue;
    endswitch
  endfor
  statisticsTable(curStatTabRow,2) = numOfVerified;
  
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("Verified triggers (%)");
  statisticsTable(curStatTabRow,2) = strcat(num2str((numOfVerified / totalNumOfTriggers) * 100), "%");
  
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("Unidentified triggers");
  naTrigTable = GetAVSData(resultsTable, -1, -1, -1);
  if(iscell(naTrigTable))
    statisticsTable(curStatTabRow,2) = rows(naTrigTable);
  else
    statisticsTable(curStatTabRow,2) = 0;
  endif
  clear naTrigTable;
  
%%  NOISE GROUPS STATS
  numOfTrigsPerNoise = trigNum * distNum;
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("");
  statisticsTable(curStatTabRow,2) = cellstr("");
  ++curStatTabRow;
  statisticsTable(curStatTabRow,1) = cellstr("*** NOISE GROUPS STATS ***");
  statisticsTable(curStatTabRow,2) = cellstr("");
%%  ++curStatTabRow;
%%  statisticsTable(curStatTabRow,1) = cellstr("Verified number of triggers per noise group");
%%  statisticsTable(curStatTabRow,2) = numOfTrigsPerNoise;
  for curNoise = 1:noiseNum
    ++curStatTabRow;
    groupStr = strcat("Noise group ",num2str(curNoise));
    statisticsTable(curStatTabRow,1) = cellstr(groupStr);
    numOfVerified = 0;
    noiseTable = GetAVSData(resultsTable, -1, -1, curNoise);
    if (!iscell(noiseTable(1,1)))
      statisticsTable(curStatTabRow,2) = 0;
      ++curStatTabRow;
    statisticsTable(curStatTabRow,1) = cellstr(strcat("Verified triggers (%), ", groupStr));
    statisticsTable(curStatTabRow,2) = strcat(num2str(0), "%");
      continue;
    endif
    numOfRows = rows(noiseTable);
    for noiseTrigRow = 1:numOfRows
      isVerified = IsTriggerVerified(noiseTable, noiseTrigRow);
      switch (isVerified)
      case 1
        ++numOfVerified;
      otherwise
        continue;
      endswitch
    endfor
    statisticsTable(curStatTabRow,2) = numOfVerified;
    ++curStatTabRow;
    statisticsTable(curStatTabRow,1) = cellstr(strcat("Verified triggers (%), ", groupStr));
    statisticsTable(curStatTabRow,2) = strcat(num2str((numOfVerified / numOfTrigsPerNoise) * 100), "%");
  endfor
  
%%  DISTANCE GROUPS STATS


%%  Individual trigger percentage

endfunction    

function isVerified = IsTriggerVerified(resultsTable, curRow)
  numExpected = cell2mat(resultsTable(curRow, 4));
  numDetected = cell2mat(resultsTable(curRow, 5));
  if (-1 == numExpected)
    isVerified = -1;
  elseif (numExpected == numDetected)
    isVerified = 1;
  else
    isVerified = 0;
  endif
endfunction
