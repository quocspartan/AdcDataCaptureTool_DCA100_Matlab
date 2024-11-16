function success = sendCfg(COM_PORT,filename, uartSpeed)
%Sends Cfg data over UART to the Radar EVM
if nargin < 3
    uartSpeed = 115200; %921600;
end

success = 0;
file = fopen(filename, 'r');
cfg = cell(0,1);
tline = fgets(file);
while ischar(tline)
    cfg{end+1,1} = tline;
    tline = fgets(file);
end

SCOM = serial(COM_PORT);
set(SCOM,'BaudRate',uartSpeed,'DataBits',8,'stopbits',1);


set(SCOM,'InputBufferSize',1024000);
SCOM.BytesAvailableFcnMode='byte';
SCOM.BytesAvailableFcnCount=1; 
%SCOM.BytesAvailableFcn=@EveBytesAvailableFcn;
SCOM.OutputBufferSize = 2048;
SCOM.InputBufferSize = 2048;
fopen(SCOM); %initialize the serial port

%Send CLI configuration to XWR1xxx
%fprintf('Sending configuration to XWR1xxx %s ...\n', filename);
for index=1:length(cfg)
    cfg2send = cfg{index};
    if strcmp(cfg{index}(1),'%')
        continue;
    end
    
    fprintf(SCOM,cfg2send);
    fprintf('%s\n', cfg2send);
    for kk = 1:40
        cc = fgetl(SCOM);
        if ~isempty(strfind(cc,'Done'))
            fprintf('%s\n',cc);
            break;
        elseif ~isempty(strfind(cc, 'not recognized as a CLI command'))
            fprintf('%s\n',cc);
            fclose(SCOM);
            delete(SCOM);
            return;
        elseif ~isempty(strfind(cc, 'Error'))
            fprintf('%s\n',cc);
            fclose(SCOM);
            delete(SCOM);
            return;
        else
            fprintf('%s\n',cc);
        end
    end
end
fclose(SCOM);
delete(SCOM);

end

