%%  DESCRIPTION: Creates new table with only relevant rows contained 
%%                (triggers and commands). Column 1-3 are identical to output 
%%                from CreateTextCells(). Column 4 contains the expected trigger
%%                number, Column 5 Contains the detected trigger number. 
%%                Column 4 and 5 will contain -1 if no text numbers 
%%                (e.g. zero, one, two..) are detected in column 1.
%%  INPUT: 'rawTextCellArray' is the initial table generated by calling 
%%            CreateTextCells(), 'lastTriggerCellNum' is the last row with 
%%            relevant information as returned from FindLastCell()     
%%  OUTPUT: 'entriesTable' is the processed table containing all relevant rows 
%%            and columns
%%  ERRORS: NA
%%  LAST MODIFIED: 25/07/2018

function entriesTable = CreateResults (rawTextCellArray, lastTriggerCellNum)
  curCellNum = 2; %%First cell contains '0', so start from cell 2
  numOfCommands = 0;
  while (curCellNum <= lastTriggerCellNum)
    entriesTable(curCellNum - 1,1) = rawTextCellArray(curCellNum,1);
    entriesTable(curCellNum - 1,2) = rawTextCellArray(curCellNum,2);
    entriesTable(curCellNum - 1,3) = rawTextCellArray(curCellNum,3);
    if (-1 != (lineTextToNum = FindAndConvertTextToNum(char(rawTextCellArray(curCellNum,1)))))
      ++numOfCommands;
      entriesTable(curCellNum - 1,4) = numOfCommands;
      entriesTable(curCellNum - 1,5) = lineTextToNum;
    else
      entriesTable(curCellNum - 1,4) = -1;
      entriesTable(curCellNum - 1,5) = -1;
    endif
    ++curCellNum;
  endwhile
endfunction


%%%%%%%%%%%%%%%%%%
%% Local Functions
%%%%%%%%%%%%%%%%%%
function parsedNum = FindAndConvertTextToNum(strLine)
  [token, remainder] = strtok(strLine, " ");
  numOfDigits = 0;
  while (0 != token)
    switch(token)
      case {"zero" "Zero"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "0";
        else
          numStr = strcat(numStr,"0");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"one" "One"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "1";
        else
          numStr = strcat(numStr,"1");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"two" "Two" "to" "To"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "2";
        else
          numStr = strcat(numStr,"2");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"three" "Three"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "3";
        else
          numStr = strcat(numStr,"3");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"four" "Four" "for" "For" "forest"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "4";
        else
          numStr = strcat(numStr,"4");
        endif
        [token, remainder] = strtok(remainder, " ");
      
      case {"five" "Five"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "5";
        else
          numStr = strcat(numStr,"5");
        endif
        [token, remainder] = strtok(remainder, " ");     
      
      case {"six" "Six"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "6";
        else
          numStr = strcat(numStr,"6");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"seven" "Seven"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "7";
        else
          numStr = strcat(numStr,"7");
        endif
        [token, remainder] = strtok(remainder, " ");
     
      case {"eight" "Eight"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "8";
        else
          numStr = strcat(numStr,"8");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      case {"nine" "Nine"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "9";
        else
          numStr = strcat(numStr,"9");
        endif
        [token, remainder] = strtok(remainder, " ");
        
      otherwise
        [token, remainder] = strtok(remainder, " ");
        continue;
        
    endswitch
  endwhile
  if (exist('numStr', 'var'))
    parsedNum = str2num(numStr);
  else
    parsedNum = -1;
  endif
endfunction