function [triggersCountPerRound, statsCells] = AnalyzeAVSLog (_fileNameString, _triggerWord, _excludeRoundsArray, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)  

  totalNumOfTriggers = _trigInDistNum * _distInNoiseNum * _noiseTotalNum;
                        
  strCells = CreateStringCellArray(_fileNameString);
  
  trigCells = CreateMultiRowTrigCellArray(strCells);
  
  verifCells = CreateSingleRowTrigCellArray(trigCells, _triggerWord);
  
  dateAndDeviceCells = CreateLogDateDeviceColumns(verifCells);
  
  flippedCells = FlipCellsUpDown(dateAndDeviceCells);

  triggersCountPerRound = GetTriggersCountPerRound(flippedCells, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, _triggerWord);
  
%%  excludedFlippedCells = ExcludeRoundsIfNeeded(flippedCells, _excludeRoundsArray);
  
  statsCells = GenerateStats(triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum);
  
  cell2csv("Results.csv", statsCells);
  
  if (0 != cell2mat(_excludeRoundsArray(1,1)))
    excludedTriggersCountPerRound = ExcludeRoundsIfNeeded(triggersCountPerRound, _excludeRoundsArray,_noiseTotalNum, _distInNoiseNum, _trigInDistNum);
%%    excludedStatsCells = GenerateExcludedStats(excludedTriggersCountPerRound, _excludeRoundsArray);
  endif
  
endfunction
