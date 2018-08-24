function  missingCells = CreateMissingCellsWithID(_resultsWithTriggerID)
    numOfRows = rows(_resultsWithTriggerID);
    missingCells = cell(0, 0);
    if (0 == numOfRows)
        return;
    endif
    curMissingRow = 1;
    for curRow = 1:numOfRows
        if (iscellstr(_resultsWithTriggerID(curRow,1)))
            continue;
        else
            noiseNum = num2str(cell2mat(_resultsWithTriggerID(curRow, 2)));
            distNum = num2str(cell2mat(_resultsWithTriggerID(curRow, 3)));
            trigNum = num2str(cell2mat(_resultsWithTriggerID(curRow, 4)));
            strID = strcat(noiseNum, distNum, trigNum);
            % newStr = cstrcat(char(_resultsWithTriggerID(curRow,1)), strID);
            missingCells(curMissingRow,1) = cellstr(sprintf("Index = %d", curRow));
            missingCells(curMissingRow,2) = cellstr(sprintf("ID = %s", strID));
        endif
    endfor
    
endfunction