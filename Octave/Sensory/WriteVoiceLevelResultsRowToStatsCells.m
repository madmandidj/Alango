function statsCells = WriteVoiceLevelResultsRowToStatsCells(_statsCells, _rowNum, _rec, _numOfTrigs, _curSNRGroup, _voiceLevStr)
  statsCells = _statsCells;
  statsCells(_rowNum,1) = cellstr(sprintf("Voice-Level %d, %s", _curSNRGroup, _voiceLevStr));
  statsCells(_rowNum,2) = cellstr(num2str(_rec));
  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
endfunction