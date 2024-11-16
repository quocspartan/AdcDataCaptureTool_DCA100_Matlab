function finalUartPortBaudrate = sendconfiguration(controlSerialPort, chirpConfigurationFileName, uartPortBaudrate, lowPowerDeviceFlag)
    %mmwDemoCliPrompt = char('vodDemo:/>');
    unsupported_commands = {'dynamicRACfarCfg' ...
                            'staticRACfarCfg' ...
                            'dynamicRangeAngleCfg' ...
                            'dynamic2DAngleCfg' ...
                            'staticRangeAngleCfg' ...
                            'antGeometry0' ...
                            'antGeometry1' ...
                            'antPhaseRot' ...
                            'fovCfg' ...
                            'numZones' ...
                            'totNumRows' ...
                            'sensorPosition' ...
                            'occStateMach' ...
                            'interiorBounds' ...
                            'cuboidDef' ...
                            'zoneNeighDef' ...
                            '%'};
    
    finalUartPortBaudrate = uartPortBaudrate;
    
    file = fopen(chirpConfigurationFileName, 'r');
	cliCfg = cell(0,1);
	tline = fgets(file);
	while ischar(tline)
	    cliCfg{end+1,1} = tline;
	    tline = fgets(file);
	end
    fclose(file);

    %Send Configuration Parameters to AWR68xx or AWRLx432  
    hControlSerialPort = configureControlPort(controlSerialPort, uartPortBaudrate, lowPowerDeviceFlag);
    %hDataSerialPort = hControlSerialPort;
    set(hControlSerialPort,'Timeout',10);
    fprintf('Sending configuration from %s file ...\n', chirpConfigurationFileName);
    for k=1:length(cliCfg)
        if (length(cliCfg{k}) > 1)

           % check if this commad is in the unsupported list of commands 
           C = strsplit(cliCfg{k});
           if (find(strcmp(unsupported_commands,C{1})))
            % string present in unsupported list. do not send to receiver 
                continue; 
           end
           writelineslow(hControlSerialPort, cliCfg{k}, lowPowerDeviceFlag);
           fprintf('%s\n', cliCfg{k});
           %echo = fgetl(hControlSerialPort); % Get an echo of a command
           if (find(strcmp('baudRate', C{1})))
               %delete(hControlSerialPort);
               %hControlSerialPort = configureControlPort(controlSerialPort, str2double(C{2}));
               finalUartPortBaudrate = str2double(C{2});
               set(hControlSerialPort, 'BaudRate', finalUartPortBaudrate);
               pause(.5);  
               continue;
           end           
           %done = fgetl(hControlSerialPort); % Get "Done"
           %prompt = fread(hControlSerialPort, size(mmwDemoCliPrompt,2)); % Get the prompt back
           for kk = 1:3
                cc = readline(hControlSerialPort);
                if contains(cc, 'Done')
                    fprintf('%s\n',cc);
                    break;
                elseif contains(cc, 'not recognized as a CLI command')
                    fprintf('%s\n',cc);
                elseif contains(cc, 'Debug:')
                    fprintf('%s\n',cc);
                elseif contains(cc, 'Error')
                    fprintf('%s\n',cc);
                    return;               
                end
            end
           
        end
    end
    % KNS - Close the serial port after the configuration is sent to receiver. 
    % Reconfigure control UART port as data UART port
    clear hControlSerialPort;    
end


function writelineslow(sphandle, cliCfg, lowPowerDeviceFlag)
    configureTerminator(sphandle,0);
    for n = 1:length(cliCfg) - 1
        write(sphandle,cliCfg(n),"char")
        pause(0.001);
    end
    if lowPowerDeviceFlag
        configureTerminator(sphandle,'CR/LF');
    else
        configureTerminator(sphandle,'LF');
    end
    writeline(sphandle,cliCfg(end));
end

