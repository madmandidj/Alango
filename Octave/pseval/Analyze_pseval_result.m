function resultTable = Analyze_pseval_result(_pathToResultText)
  fidRead = fopen(_pathToResultText);
  tempTable = CreateInitialTable(fidRead);
  resultTable = ProcessInitialTable(tempTable);
  fclose(fidRead);
endfunction
