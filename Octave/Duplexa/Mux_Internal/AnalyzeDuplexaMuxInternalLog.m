function [statsCells] = AnalyzeDuplexaMuxInternalLog(_pathToMuxIntLog, _numOfVoices, _numOfLevels, _numOfTrigs)
  addpath("../Common");
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
%%  resultsFileNameAndExt = sprintf("%s.csv", _resultsFileName);
%%  excludeFileNameAndExt = sprintf("%s_excluded.csv", _resultsFileName);
  resultsFileNameAndExt = GetResultsFileNameAndExt(_pathToMuxIntLog);
  strCell = CreateStringCellArray(_pathToMuxIntLog);
  trigTimesSeconds = CreateTrigTimesSecondsCells(strCell);
  expectedTrigTimes = CreateExpectedTrigTimesCells(_numOfVoices, _numOfLevels, _numOfTrigs);
  resultArray = CreateResultsArray(trigTimesSeconds, expectedTrigTimes);
  [voiceResults, levelResults, roundResults] = CreateIndividualResults(resultArray, _numOfVoices, _numOfLevels, _numOfTrigs);
  statsCells = CreateStatsCells(voiceResults, levelResults, roundResults, voiceStrings, levelStrings, _numOfVoices, _numOfLevels, _numOfTrigs);
  cell2csv(resultsFileNameAndExt, statsCells);
  
endfunction
