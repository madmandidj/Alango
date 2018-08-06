function cellStrLines = FileLinesToStrLinesCellArray(_pathToFile)
  fid = OpenReadFile(_pathToFile);
  curLineNum = 1;
  while (!feof(fid))
    curStr = fgetl(fid);
    if (isempty(curStr))
      continue;
    else
      curStr = strtrim(curStr);
      curStr = deblank(curStr);
      cellStrLines(curLineNum,1) = cellstr(curStr);
    endif
    ++curLineNum;
  endwhile
  CloseReadFile(fid);
  %% remember that Still need to flip upside down for alexa recognitions
endfunction

%%%%%%%%%%%%%%%%%%
%% Local Functions
%%%%%%%%%%%%%%%%%%
function fidRead = OpenReadFile(fileNameString)
  fidRead = fopen(fileNameString);
  CheckOpenFileSuccess(fidRead);
endfunction

function CloseReadFile(fidRead)
  fclose(fidRead);
endfunction

function CheckOpenFileSuccess(fileID)
  if (-1 == fileID)
    error("Failed to open file");
  endif
endfunction