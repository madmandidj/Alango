function statsCells = WriteRoundResultsRowToStatsCells(_statsCells, _rowNum, _roundNum, _rec, _missed, _unrec, _numOfTrigs, _voiceStr, _voiceLevStr)
  statsCells = _statsCells;
  statsCells(_rowNum,1) = cellstr(sprintf("Round %d, %s, %s", _roundNum, _voiceStr, _voiceLevStr));
  statsCells(_rowNum,2) = cellstr(num2str(_rec));
  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
  statsCells(_rowNum,4) = cellstr(num2str(_missed));
  statsCells(_rowNum,5) = cellstr(sprintf("%.1f%%", 100 * _missed/_numOfTrigs));
  statsCells(_rowNum,6) = cellstr(num2str(_unrec));
  statsCells(_rowNum,7) = cellstr(sprintf("%.1f%%", 100 * _unrec/_numOfTrigs));
endfunction