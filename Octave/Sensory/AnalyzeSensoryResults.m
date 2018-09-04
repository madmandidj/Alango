function [statsCells] = AnalyzeSensoryResults(_pathToFile, _numOfVoices, _numOfLevels, _numOfTrigs)
  voiceStrings = {"Human Male 1", 
                "Human Male 2",
                "Human Male 3",
                "Human Female 1",
                "Human Female 2",
                "Human Female 3",
                "Synth Male 1",
                "Synth Male 2",
                "Synth Female 1", 
                "Synth Female 2"};
  levelStrings = {"0 dB", "-6 dB", "-12 dB"};
%%  resultsFileNameAndExt = sprintf("%s.csv", _resultsFileName);
  resultsFileNameAndExt = GetResultsFileNameAndExt(_pathToFile);
  strCell = CreateStringCellArray(_pathToFile);
  numOfRows = rows(strCell);
  curRow = 1;
  numOfTrigs = 0;
  trigTimes = cell(0);
  trigTimesMS = cell(0);
  
  trigTimesSeconds = 0;
  secondsOffset = 0;
  
  trigTimes(1,1) ="Recognized=";
  trigTimes(1,2) =0;
  while curRow <= numOfRows
    curRowStr = char(strCell(curRow, 1));
    strs = strsplit (curRowStr, " ");
    isFirstStrNumCell = isdigit(strs(1,1));
    if (!all(cell2mat(isFirstStrNumCell)))
      ++curRow;
      continue;
    endif
    ++numOfTrigs;
    
    startTimeMS = str2num(char(strs(1,1)));
%%    endTimeMS = str2num(char(strs(1,2)));


    trigTimesSeconds(numOfTrigs,1) = (round(startTimeMS / 1000) - secondsOffset);
    if (1 == numOfTrigs)
      secondsOffset = trigTimesSeconds(numOfTrigs,1);
      trigTimesSeconds(numOfTrigs,1) = 0;
    endif
    ++curRow;

%%    if (1 == numOfTrigs)
%%      firstTrigMS = startTimeMS;  
%%    endif
%%    trigTimesMS(numOfTrigs,1) = startTimeMS - firstTrigMS;
%%    trigTimes(numOfTrigs+1, 1) = floor((startTimeMS/1000)/60);
%%    if floor((startTimeMS/1000)/60) == 0
%%      trigTimes(numOfTrigs+1, 2) = floor(startTimeMS/1000);
%%    else
%%      trigTimes(numOfTrigs+1, 2) = round(rem((startTimeMS/1000),60));
%%    endif
%%    ++curRow;
    
    
    
    
  endwhile
%%  trigTimes(1,1) =sprintf("%d/181", numOfTrigs);
%%  trigTimes(1,2) =sprintf("%d%%", 100 * numOfTrigs/181);

  expectedTrigTimes = CreateExpectedTrigTimesCells(_numOfVoices, _numOfLevels, _numOfTrigs);
  resultArray = CreateResultsArray(trigTimesSeconds, expectedTrigTimes);
  [voiceResults, levelResults, roundResults] = CreateIndividualResults(resultArray, _numOfVoices, _numOfLevels, _numOfTrigs);
  statsCells = CreateStatsCells(voiceResults, levelResults, roundResults, voiceStrings, levelStrings, _numOfVoices, _numOfLevels, _numOfTrigs);
  
  cell2csv(resultsFileNameAndExt, statsCells);
endfunction
