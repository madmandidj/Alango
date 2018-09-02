function [triggersCountPerRound, statsCells] = AnalyzeAVSLog (_pathString, _resultsFileName, _triggerWord, _excludeRoundsArray, _noiseTotalNum, _distInNoiseNum, _trigInDistNum)  

%%  voiceStrings = {"Synth Male 1", 
%%                  "Human Male 1", 
%%                  "Human Male 2", 
%%                  "Synth Female 1", 
%%                  "Synth Female 2", 
%%                  "Human Female 1",
%%                  "Human Female 2",
%%                  "Synth Male 2",
%%                  "Human Male 3",
%%                  "Human Female 3"}; %%Change this to be: Human male, female, synth male, female
  voiceStrings = {"Human Male 1", 
                  "Human Male 2",
                  "Human Male 3",
                  "Human Female 1",
                  "Human Female 2",
                  "Human Female 3",
                  "Synth Male 1",
                  "Synth Male 2",
                  "Synth Female 1", 
                  "Synth Female 2"};
  levelStrings = {"0 dB", "-6 dB", "-12 dB"};
  resultsFileNameAndExt = sprintf("%s.csv", _resultsFileName);
  excludeFileNameAndExt = sprintf("%s_excluded.csv", _resultsFileName);

  totalNumOfTriggers = _trigInDistNum * _distInNoiseNum * _noiseTotalNum;
                        
  strCells = CreateStringCellArray(_pathString);
  
  trigCells = CreateMultiRowTrigCellArray(strCells);
  
  verifCells = CreateSingleRowTrigCellArray(trigCells, _triggerWord);
  
  dateAndDeviceCells = CreateLogDateDeviceColumns(verifCells);
  
  flippedCells = FlipCellsUpDown(dateAndDeviceCells);

  triggersCountPerRound = GetTriggersCountPerRound(flippedCells, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, _triggerWord);
  
  statsCells = GenerateStats(triggersCountPerRound, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, voiceStrings, levelStrings);
  
  cell2csv(resultsFileNameAndExt, statsCells);
  
  if (0 != cell2mat(_excludeRoundsArray(1,1)))
    excludedTriggersCountPerRound = ExcludeRoundsIfNeeded(triggersCountPerRound, _excludeRoundsArray,_noiseTotalNum, _distInNoiseNum, _trigInDistNum);
    excludedStatsCells = GenerateExcludedStats(excludedTriggersCountPerRound, _excludeRoundsArray, _noiseTotalNum, _distInNoiseNum, _trigInDistNum, voiceStrings, levelStrings);
    cell2csv(excludeFileNameAndExt, excludedStatsCells);
  endif
  
endfunction
