function parsedNum = ParseLineTextNumToNum(_strLine)
  [token, remainder] = strtok(_strLine, " ");
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
