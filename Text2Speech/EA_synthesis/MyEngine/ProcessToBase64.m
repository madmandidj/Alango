function processedBase64 = ProcessToBase64(_pathToUnprocessedTxtFile)
    fid = fopen(_pathToUnprocessedTxtFile);
    shouldStop = 0;
    fskipl(fid);
    strLine = fgetl(fid);
    [tok, rem] = strtok(strLine, '/');
    [processedBase64, rem] = strtok(rem, '"');
    fid2 = fopen("./processedBase64.txt", 'w');
    fprintf(fid2, "%s", processedBase64);
    fclose(fid2);
    fclose(fid);
endfunction