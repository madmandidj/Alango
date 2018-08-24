function parsedNum = ParseLineTextNumToNum(_strLine)
  [token, remainder] = strtok(_strLine, " ");
  numOfDigits = 0;
  
  isTriggerWordRecognized = 0;
  isCommandFullyRecognized = 1;
  isPartialRecognized = 0;
  isStopRecognized = 0;
  textNotAvailable = "Text not available. Click to play recording.";

  if (strcmp(_strLine, textNotAvailable))
    parsedNum = -1;
    return;
  endif
  
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
        isPartialRecognized = 1;
        
      case {"one" "One"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "1";
        else
          numStr = strcat(numStr,"1");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"two" "Two" "to" "To"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "2";
        else
          numStr = strcat(numStr,"2");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"three" "Three"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "3";
        else
          numStr = strcat(numStr,"3");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"four" "Four" "for" "For" "forest"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "4";
        else
          numStr = strcat(numStr,"4");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
      
      case {"five" "Five"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "5";
        else
          numStr = strcat(numStr,"5");
        endif
        [token, remainder] = strtok(remainder, " ");    
        isPartialRecognized = 1; 
      
      case {"six" "Six"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "6";
        else
          numStr = strcat(numStr,"6");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"seven" "Seven"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "7";
        else
          numStr = strcat(numStr,"7");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
     
      case {"eight" "Eight"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "8";
        else
          numStr = strcat(numStr,"8");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"nine" "Nine"}
        ++numOfDigits;
        if (1 == numOfDigits)
          numStr = "9";
        else
          numStr = strcat(numStr,"9");
        endif
        [token, remainder] = strtok(remainder, " ");
        isPartialRecognized = 1;
        
      case {"alexa"}
        [token, remainder] = strtok(remainder, " ");
        isTriggerWordRecognized = 1;
        
      case {"stop"}
        [token, remainder] = strtok(remainder, " ");
        isStopRecognized = 1;
        
      otherwise
        isCommandFullyRecognized = 0;
        [token, remainder] = strtok(remainder, " ");
        continue;
        
    endswitch
  endwhile
  if (isCommandFullyRecognized)
    parsedNum = str2num(numStr);
  elseif (isPartialRecognized )
    parsedNum = 0;
  else
    parsedNum = -1;
  endif
endfunction
