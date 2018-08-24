%%function [recognizedCells, partialCells, unrecognizedCells, duplicateCells, resultsWithTriggerID, resultsStats] = AnalyzeAVSLog (_fileNameString, _triggerWord, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)
function [recognizedCells, missingCells, partialCells, unrecognizedCells, duplicateCells, illegalCells, resultsWithTriggerID, resultsStats] = AnalyzeAVSLog (_fileNameString, _triggerWord, 
                        _noiseTotalNum, _distInNoiseNum, _trigInDistNum)
                        
  detectionColumnNum = 5;

  totalNumOfTriggers = _trigInDistNum * _distInNoiseNum * _noiseTotalNum;
                        
  strCells = CreateStringCellArray(_fileNameString);
  
  trigCells = CreateMultiRowTrigCellArray(strCells);
  
  verifCells = CreateSingleRowTrigCellArray(trigCells, _triggerWord);
  
  dateAndDeviceCells = CreateLogDateDeviceColumns(verifCells);
  
  flippedCells = FlipCellsUpDown(dateAndDeviceCells);
  
  expectedNumCells = CreateExpectedNumColumn(flippedCells);
  
  detectedNumCells = CreateDetectedNumColumn(expectedNumCells);
  
  [recognizedCells, partialCells, unrecognizedCells] = ProcessCells(detectedNumCells, detectionColumnNum);
  
  [resultsHashMap, duplicateCells, illegalCells] = CreateResultsHashMap(recognizedCells, totalNumOfTriggers, detectionColumnNum);
  
  trimmedResults = TrimHashMap(resultsHashMap);
  
  resultsWithTriggerID = AddIDToResults(trimmedResults, _noiseTotalNum, _distInNoiseNum, _trigInDistNum);

  missingCells = CreateMissingCellsWithID(resultsWithTriggerID);
  
  resultsStats = GenerateResultsStats(resultsWithTriggerID, rows(detectedNumCells), rows(unrecognizedCells), rows(partialCells), 
                  rows(duplicateCells), rows(illegalCells), _noiseTotalNum, _distInNoiseNum, _trigInDistNum);

endfunction
