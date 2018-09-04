function resultsFileNameAndExt = GetResultsFileNameAndExt(_pathToAVSLog)
  strs = strsplit(_pathToAVSLog, {" ","\\", "/", ",", "."});
  filenameWithoutExt = strs(1, columns(strs)-1);
  filenameWithoutExt = sprintf("%s_AVS", char(filenameWithoutExt));
  resultsFileNameAndExt = sprintf("%s.csv", char(filenameWithoutExt));
endfunction
