function statsCells = WriteBlankRowToStatsCells(_statsCells, _rowNum)
  statsCells =_statsCells;
  statsCells(_rowNum,1) = cellstr("");
  statsCells(_rowNum,2) = cellstr("");
  statsCells(_rowNum,3) = cellstr("");
  statsCells(_rowNum,4) = cellstr("");
  statsCells(_rowNum,5) = cellstr("");
  statsCells(_rowNum,6) = cellstr("");
  statsCells(_rowNum,7) = cellstr("");
endfunction