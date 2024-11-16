function writeSettings(filename, cliComPortNum,deviceMode, configFileName, adcFileName)
    fid = fopen(filename, 'w');
    if fid == -1
        fprintf('File %s not found!\n', filename);
        return;
    end

    fprintf(fid,'cliComPortNum\t%d\n',cliComPortNum);
    fprintf(fid,'deviceMode\t%d\n',deviceMode);
    fprintf(fid,'configFileName\t%s\n',configFileName);
    fprintf(fid,'adcFileName\t%s\n',adcFileName);    
    fclose(fid);
end