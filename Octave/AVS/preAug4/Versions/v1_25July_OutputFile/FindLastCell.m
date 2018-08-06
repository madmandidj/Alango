%%  DESCRIPTION: Finds the row number of the end of relevant information. 
%%                The word 'None' in the Alexa log .txt file, is the marker for 
%%                non relevant info.
%%  INPUT: 'textCellArray' is the initial table created by calling 
%%            CreateTextCells()
%%  OUTPUT: 'lastTriggerCellNum' is the row number of the last relevant info 
%%  ERRORS: NA
%%  LAST MODIFIED: 24/07/2018

function lastTriggerCellNum = FindLastCell(textCellArray)
  curLineNum = 1;
%  numOfFoundTriggers = 1; %%TriggerLineNums starts from line 1 regardless if alexa was there
%  alexaLineNums(1,1) = 1;
%  totalLineNum = rows(textCellArray);
  while (isempty(strfind(char(textCellArray(curLineNum,1)),"None")))
    ++curLineNum;
  endwhile
  lastTriggerCellNum = curLineNum - 1;
endfunction
