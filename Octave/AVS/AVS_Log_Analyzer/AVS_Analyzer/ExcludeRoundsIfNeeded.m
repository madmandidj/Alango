function   excludedTriggersCountPerRound = ExcludeRoundsIfNeeded(_triggersCountPerRound, _excludeRoundsArray,_noiseTotalNum, _distInNoiseNum, _trigInDistNum)
    if (0 == cell2mat(_excludeRoundsArray(1,1)))
        excludedTriggersCountPerRound = _triggersCountPerRound;
        return;
    endif
    numOfRounds = rows(_triggersCountPerRound);
    numOfExcludedRounds = columns(_excludeRoundsArray);
    excludedTriggersCountPerRound = cell(0,0);
    curExcludedIndex = 1;
    curExcludedRound = cell2mat(_excludeRoundsArray(1,curExcludedIndex));
    curNewRoundNum = 0;
    curRound = 0;

    for curRound = 1:numOfRounds
      curExcludedRound = cell2mat(_excludeRoundsArray(1,curExcludedIndex));
      if (curExcludedRound != curRound)
          ++curNewRoundNum;
          excludedTriggersCountPerRound(curNewRoundNum,:) = _triggersCountPerRound(curRound,:);
      else
          if (curExcludedIndex < numOfExcludedRounds)
            ++curExcludedIndex;
          endif
        endif
    endfor

endfunction
