function [resultTable, statsTable] = AnalyzeAVSLog (_fileNameString, _triggerWord, 
                        _trigInDistNum, _distInNoiseNum, _noiseTotalNum)
  strCells = FileLinesToStrLinesCellArray(_fileNameString);
  trigCells = CreateTriggerCellArray(strCells);
  verifCells = VerifyTriggerCellArrayValid(trigCells, _triggerWord);
  dateAndDeviceCells = CreateDateAndDeviceName(verifCells);
  flippedCells = FlipCellsUpDown(dateAndDeviceCells);
  expectedNumCells = CreateExpectedNumColumn(flippedCells);
  detectedNumCells = CreateDetectedNumColumn(expectedNumCells);
  resultTable = detectedNumCells;
  statsTable = trigCells;
endfunction