function resultArray = CreateResultsArray(_trigTimesSeconds, _expectedTrigTimes)
  numOfExpectedTrigs = rows(_expectedTrigTimes);
  curExpected = 1;
  curActual = 1;
  validTrigOffset = 2;
  resultArray = 0;
  
  while (numOfExpectedTrigs >= curExpected)
    curValidMin = _expectedTrigTimes(curExpected,1) - validTrigOffset;
    curValidMax = _expectedTrigTimes(curExpected,1) + validTrigOffset;
    curActualValue = _trigTimesSeconds(curActual, 1);
    if (curValidMin <= curActualValue && curValidMax >= curActualValue)
      resultArray(curExpected,1) = 1;
      ++curActual;
    else
      resultArray(curExpected,1) = 0;
    endif
    ++curExpected;
  endwhile
endfunction
