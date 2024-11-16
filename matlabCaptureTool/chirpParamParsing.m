function radarParam = chirpParamParsing(configFileName, deviceType)


%% Read Chirp parameter
cliCfgFileId = fopen(configFileName, 'r');
if cliCfgFileId == -1
    fprintf('File %s not found!\n', configFileName);
    return
else
    fprintf('Opening configuration file %s\n', configFileName);
end
    
cliCfg=[];
tline = fgetl(cliCfgFileId);
k=1;
while ischar(tline)
    cliCfg{k} = tline;
    tline = fgetl(cliCfgFileId);
    k = k + 1;
end
fclose(cliCfgFileId);

%Define supported CLI commands
[supported_cfgs] = defineCLICommands(deviceType);
    
%Parse CLI strings and calculate derived parameters
P = parseCLICommands2Struct(cliCfg, supported_cfgs);
radarParam = calculateChirpParams(P, deviceType);

