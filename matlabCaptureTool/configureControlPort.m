function sphandle = configureControlPort(comPortNum,baudrate, lowPowerDeviceFlag)
    comPortsAvailable = serialportlist("available");
    comPortString = ['COM' num2str(comPortNum)];
    if any(contains(comPortsAvailable,comPortString))
        sphandle = serialport(comPortString,baudrate,'Parity','none','Timeout',10);%REMOVE_THIS 10); 
        if lowPowerDeviceFlag
            configureTerminator(sphandle,'CR/LF');
        else
            configureTerminator(sphandle,'LF');
        end
        flush(sphandle);
    else
        sphandle = [];
        fprintf('Serial port is already open. Power cycle the device and re-run the application...\n');
    end
end