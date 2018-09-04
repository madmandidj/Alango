function resultsFileNameAndExt = GetResultsFileNameAndExt(_pathToMuxIntLog)
  strs = strsplit(_pathToMuxIntLog, {" ","\\", "/", ",", "."});
  filenameWithoutExt = strs(1, columns(strs)-1);
  filenameWithoutExt = sprintf("%s_Duplexa", char(filenameWithoutExt));
  resultsFileNameAndExt = sprintf("%s.csv", char(filenameWithoutExt));
endfunction
