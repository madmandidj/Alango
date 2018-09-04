function statsCells = WriteVoiceResultsRowToStatsCells(_statsCells, _rowNum, _rec, _numOfTrigs, _curNoiseGroup, _voiceStr)
  statsCells = _statsCells;
  statsCells(_rowNum,1) = cellstr(sprintf("Voice %d, %s", _curNoiseGroup, _voiceStr));
  statsCells(_rowNum,2) = cellstr(num2str(_rec));
  statsCells(_rowNum,3) = cellstr(sprintf("%.1f%%", 100 * _rec/_numOfTrigs));
endfunction