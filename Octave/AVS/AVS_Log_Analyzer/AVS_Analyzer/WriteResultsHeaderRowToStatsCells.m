function statsCells = WriteResultsHeaderRowToStatsCells(_statsCells, _rowNum, _str1)
  statsCells =_statsCells;
  statsCells(_rowNum,1) = cellstr(_str1);
  statsCells(_rowNum,2) = cellstr("recognized");
  statsCells(_rowNum,3) = cellstr("recognized %");
  statsCells(_rowNum,4) = cellstr("missed");
  statsCells(_rowNum,5) = cellstr("missed %");
  statsCells(_rowNum,6) = cellstr("unrecognized");
  statsCells(_rowNum,7) = cellstr("unrecognized %");
endfunction