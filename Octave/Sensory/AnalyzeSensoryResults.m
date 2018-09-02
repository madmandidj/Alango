function [numOfTrigs, trigTimes] = AnalyzeSensoryResults(_pathToFile, _resultsFileName)
  resultsFileNameAndExt = sprintf("%s.csv", _resultsFileName);
  strCell = CreateStringCellArray(_pathToFile);
  numOfRows = rows(strCell);
  curRow = 1;
  numOfTrigs = 0;
  trigTimes = cell(0);
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
    endTimeMS = str2num(char(strs(1,2)));
    trigTimes(numOfTrigs+1, 1) = floor((startTimeMS/1000)/60);
    if floor((startTimeMS/1000)/60) == 0
      trigTimes(numOfTrigs+1, 2) = floor(startTimeMS/1000);
    else
      trigTimes(numOfTrigs+1, 2) = round(rem((startTimeMS/1000),60));
    endif
    
    ++curRow;
  endwhile
  trigTimes(1,1) =sprintf("%d/181", numOfTrigs);
  trigTimes(1,2) =sprintf("%d%%", floor(100 * numOfTrigs/181));
%%  trigTimes(1,2) =0;
  cell2csv(resultsFileNameAndExt, trigTimes);
endfunction
