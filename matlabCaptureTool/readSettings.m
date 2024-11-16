function [cliComPortNum, deviceMode, configFileName, adcDataFileName] = readSettings(filename)
    setting = cell(1,4);
    fid = fopen(filename, 'r');
    if fid == -1
        fprintf('File %s not found!\n', filename);
        configFileName = []; cliComPortNum = []; adcDataFileName = [];
        return;
    end
    
    for k = 1:length(setting)
        setting{k} = fgetl(fid);
    end
    fclose(fid);

    tline = strsplit(setting{1});
    cliComPortNum = str2double(strtrim(extractAfter(setting{1},tline{1})));

    tline = strsplit(setting{2});
    deviceMode = str2double(extractAfter(setting{2},tline{1}));

    tline = strsplit(setting{3});
    configFileName = strtrim(extractAfter(setting{3},tline{1}));

    tline = strsplit(setting{4});
    adcDataFileName = strtrim(strtrim(extractAfter(setting{4},tline{1})));
    
end