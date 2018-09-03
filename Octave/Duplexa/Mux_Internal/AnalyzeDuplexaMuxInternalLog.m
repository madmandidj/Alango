function [temp] = AnalyzeDuplexaMuxInternalLog(_pathToMuxIntLog)
  addpath("../Common");
  strCell = CreateStringCellArray(_pathToMuxIntLog);
  trigTimesSeconds = CreateTrigTimesSecondsCells(strCell);
  
  %%
  %%
  %%
  
endfunction
