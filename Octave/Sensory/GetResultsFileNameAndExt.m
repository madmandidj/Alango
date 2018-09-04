function resultsFileNameAndExt = GetResultsFileNameAndExt(_pathToSensoryLog)
  strs = strsplit(_pathToSensoryLog, {" ","\\", "/", ",", "."});
  filenameWithoutExt = strs(1, columns(strs)-1);
  filenameWithoutExt = sprintf("%s_Sensory", char(filenameWithoutExt));
  resultsFileNameAndExt = sprintf("%s.csv", char(filenameWithoutExt));
endfunction
