function statsCells = WriteRowToStatsCells(_statsCells, _rowNum, _cellStr1, _cellStr2, _cellStr3, _cellStr4, _cellStr5, _cellStr6, _cellStr7)
  statsCells =_statsCells;
  statsCells(_rowNum,1) = _cellStr1;
  statsCells(_rowNum,2) = _cellStr2;
  statsCells(_rowNum,3) = _cellStr3;
  statsCells(_rowNum,4) = _cellStr4;
  statsCells(_rowNum,5) = _cellStr5;
  statsCells(_rowNum,6) = _cellStr6;
  statsCells(_rowNum,7) = _cellStr7;
endfunction