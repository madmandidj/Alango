%%  DESCRIPTION: Create initial table with all lines from log file placed into 
%%                seperate rows
%%  INPUT: 'fidRead' is the file ID of the opened log .txt file
%%  OUTPUT: 'rawTextCellArr' is the filled initial table. Column 1 contains all 
%%            lines of original .txt file column 2 contains the time of 
%%            recognition, column 3 contains device name
%%  ERRORS: NA
%%  LAST MODIFIED: 24/07/2018

function rawTextCellArr = CreateTextCells(fidRead)
  curLineNum = 1;
  timeOffset = 6;
  timeLength = 8;
  deviceOffset = 3;
  while (!feof(fidRead))
    curStr = fgetl(fidRead);
    if (isempty(curStr))
      continue;
    elseif (!isempty(strfind(curStr, "PM")) || !isempty(strfind(curStr, "AM")))
      if (isempty(AMPMindex = strfind(curStr, "PM")))
        AMPMindex = strfind(curStr, "AM");
      endif
      onIndex = strfind(curStr, "on");
      rawTextCellArr(curLineNum - 1,2) = substr(curStr, AMPMindex - timeOffset, timeLength);
      rawTextCellArr(curLineNum - 1,3) = substr(curStr, onIndex + deviceOffset);
      continue;
    else
      rawTextCellArr(curLineNum,1) = cellstr(curStr);
    endif
    ++curLineNum;
  endwhile
  rawTextCellArr = flipud(rawTextCellArr);
endfunction
