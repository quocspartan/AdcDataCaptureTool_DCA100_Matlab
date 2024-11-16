function datacardConfigJsonFileCurrent = changeFileNameInJasonFile(datacardConfigJsonFile, adcDataFileName)

[filepath,name,ext] = fileparts(adcDataFileName);
newfilepath = strrep(filepath,'\','\\');
% Read txt into cell A
fid = fopen(datacardConfigJsonFile,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);
% Change cell A
A{22} = sprintf('			"fileBasePath": "%s",',newfilepath);
A{23} = sprintf('			"filePrefix": "%s",',name);
% Write cell A into txt
datacardConfigJsonFileCurrent = '.\chirp_configs\datacard_current.json';
fid = fopen(datacardConfigJsonFileCurrent, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
return;