function tempTable = CreateInitialTable(fidRead)
  curLineNum = 1;
  newBeamToken = "*beam";
  while (!feof(fidRead))
    curStr = fgetl(fidRead);
    while(!isempty(strfind(curStr, newBeamToken)))
      if (isempty(curStr))
        continue;
      else
        tokens = strsplit(curStr, {"*", " "});
        if (isstrprop(tokens(1,1), 'digit'))
          
        endif
      endif
    endwhile
    
    ++curLineNum;
  endwhile
endfunction
