%%  DESCRIPTION: Finds the row number of the end of relevant information. 
%%                The word 'None' in the Alexa log .txt file, is the marker for 
%%                non relevant info.
%%  INPUT: 'textCellArray' is the initial table created by calling 
%%            CreateTextCells()
%%  OUTPUT: 'lastTriggerCellNum' is the row number of the last relevant info 
%%  ERRORS: NA
%%  LAST MODIFIED: 25/07/2018

function lastTriggerCellNum = FindLastCell(textCellArray)
  curLineNum = 1;
  while (isempty(strfind(char(textCellArray(curLineNum,1)),"None")))
    ++curLineNum;
  endwhile
  lastTriggerCellNum = curLineNum - 1;
endfunction
