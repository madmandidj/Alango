function statsCells = WriteRowToStatsCells(_statsCells, _rowNum, _cellStr1, _cellStr2, _cellStr3)
  statsCells =_statsCells;
  statsCells(_rowNum,1) = _cellStr1;
  statsCells(_rowNum,2) = _cellStr2;
  statsCells(_rowNum,3) = _cellStr3;
endfunction