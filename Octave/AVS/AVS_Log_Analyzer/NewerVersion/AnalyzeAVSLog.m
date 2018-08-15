function [triggersCountPerRound, statsCells] = AnalyzeAVSLog (_fileNameString, _triggerWord, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)  

  totalNumOfTriggers = _trigInDistNum * _distInNoiseNum * _noiseTotalNum;
                        
  strCells = CreateStringCellArray(_fileNameString);
  
  trigCells = CreateMultiRowTrigCellArray(strCells);
  
  verifCells = CreateSingleRowTrigCellArray(trigCells, _triggerWord);
  
  dateAndDeviceCells = CreateLogDateDeviceColumns(verifCells);
  
  flippedCells = FlipCellsUpDown(dateAndDeviceCells);
  
  triggersCountPerRound = GetTriggersCountPerRound(flippedCells, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, _triggerWord);
  
  statsCells = GenerateStats(triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum);
  
  cell2csv("Results.csv", statsCells);
endfunction
