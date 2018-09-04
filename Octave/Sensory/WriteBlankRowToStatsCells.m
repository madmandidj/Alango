function statsCells = WriteBlankRowToStatsCells(_statsCells, _rowNum)
  statsCells =_statsCells;
  statsCells(_rowNum,1) = cellstr("");
  statsCells(_rowNum,2) = cellstr("");
  statsCells(_rowNum,3) = cellstr("");
endfunction