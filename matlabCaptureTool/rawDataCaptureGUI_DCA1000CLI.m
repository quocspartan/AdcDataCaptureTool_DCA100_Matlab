% configuration file name
clear, clc, close all;

settingsFileName = 'settings.txt';
%% Configuration Parameters
[COM_PORT_RADAR_CONFIG, deviceType, configFile, adcDataFileName, dataCaptureFlag, captureTimeInSecond, numFrameToProc] = configDialog(settingsFileName);    

switch deviceType
    case 'xWR6843/xWR1843/xWR1642'
        sensorRestartFile = '.\chirp_configs\sensor_restart.cfg';
        sensorStopFile = '.\chirp_configs\sensor_stop.cfg';
        datacardConfigJsonFile = '.\chirp_configs\datacard_config.json';
        lowPowerDeviceFlag = 0;
    case 'xWRL6432/xWRL1432'
        sensorRestartFile = '.\chirp_configs\sensor_restart_lowPower.cfg';
        sensorStopFile = '.\chirp_configs\sensor_stop_lowPower.cfg';
        datacardConfigJsonFile = '.\chirp_configs\datacard_config_lowPower.json';
        lowPowerDeviceFlag = 1;
end
datacardConfigJsonFileCurrent = changeFileNameInJasonFile(datacardConfigJsonFile, adcDataFileName);

uartSpeed = 115200; 
% prepare the capture
if dataCaptureFlag   
    system(['DCA1000EVM_CLI_Control.exe reset_ar_device ', datacardConfigJsonFileCurrent])
    pause(3);
    system(['DCA1000EVM_CLI_Control.exe fpga ', datacardConfigJsonFileCurrent])
    system(['DCA1000EVM_CLI_Control.exe record ', datacardConfigJsonFileCurrent]);
end 


%% one time data capture
% data file capture through DCA1000 CLI control interface
if dataCaptureFlag
    % Need to start capture before sensor start in order for DCA1000 to capture from the start of the frame
    system(['DCA1000EVM_CLI_Control.exe start_record ', datacardConfigJsonFileCurrent]);
    pause(0.5);
    uartSpeed = sendconfiguration(COM_PORT_RADAR_CONFIG, configFile, uartSpeed, lowPowerDeviceFlag);
    pause(captureTimeInSecond);
    system(['DCA1000EVM_CLI_Control.exe stop_record ', datacardConfigJsonFileCurrent]);
end
    
%% process the data and record the peak target value
PLOT_2D_FFT = 1;

% chirp configuration parsing
radarParam = chirpParamParsing(configFile, deviceType);
numADCSamples = radarParam.numADCSamples; 
numRXChannel = radarParam.numRXChannel;
numTXChannel = radarParam.numTXChannel;
numChirps = radarParam.numLoops;

% data loading 
% load one frame of raw ADC data. 
switch (deviceType)
    case 'xWR6843/xWR1843/xWR1642'
        samples = numADCSamples * numRXChannel * numChirps*numTXChannel * 2; 
        [filepath,name,ext] = fileparts(adcDataFileName);
        finalAdcDataFileName = strcat(filepath, '\',name,'_Raw_0.bin');
        fid = fopen(finalAdcDataFileName,'r');
        for frameID = 1: numFrameToProc
            dataChunk = fread(fid, samples,'uint16');
            dataChunk = dataChunk - (dataChunk >= 2^15)*2^16;

            % data parsing 
            % with reorderEnable set to 1 in datacard config json file
            % the data is already in the order of complex pairs
            % the out of box demo support the adcbufCfg with Q first
            % The original data format is listed in figure 11 before reorderEnable at: 
            % http://www.ti.com/lit/an/swra581b/swra581b.pdf
            adcOut = dataChunk(2:2:end) + 1j*dataChunk(1:2:end);
            out = reshape(adcOut,  numADCSamples, numRXChannel* numTXChannel, numChirps);
            % adcOut data is in the dimension of (numADCSamples, numChirps,
            % numRXChannel* numTXChannel)
            adcOut = permute(out, [1, 3, 2]);

            % Radar signal processing
            % 1D FFT: range FFT; range FFT size is numADCSamples  
            fftSize1D = size(adcOut,1);
            radar_data_1dFFT = fft(adcOut,[], 1);%.*window_1D 

            % 2D FFT: Doppler FFT; Doppler FFT size is numChirps. 
            % without fftshift, the zero Doppler bin is index 1. 
            fftSize2D = size(adcOut, 2);
            radar_data_2dFFT = fft(radar_data_1dFFT(:,1:end, :),[], 2); %.*window_2D
            % non-coherent combination cross antenna to get ready for peak detection.
            radar_data_2dFFTMag = sum(abs(radar_data_2dFFT).^2, 3); 
            if (PLOT_2D_FFT)
                % plot ADC data for 
                figure(5); hold on; plot((abs(adcOut(:,:,1))));
                title('Absolute value of ADC samples for antenna TX1-RX1')
                % plot the 2D FFT output for sanity check
                range_axis = (0:radarParam.numADCSamples-1)*radarParam.rangeResolution_m;
                figure(7); hold on; plot(range_axis, 10*log10(abs(radar_data_2dFFTMag)));
                xlabel('range (m)')
                ylabel('Amplitude (dB)')
                title('2D FFT output with non-coherent combination cross antennas')
                grid on;   
            end    
        end
        fclose(fid);

    case 'xWRL6432/xWRL1432'
        samples = numADCSamples * numRXChannel * numChirps*numTXChannel; 
        [filepath,name,ext] = fileparts(adcDataFileName);
        finalAdcDataFileName = strcat(filepath, '\',name,'_Raw_0.bin');
        fid = fopen(finalAdcDataFileName,'r');
        for frameID = 1: numFrameToProc
            dataChunk = fread(fid, samples,'uint16');
            adcOut = dataParsing_lowPowerDevice(dataChunk);    
            out = reshape(adcOut, numRXChannel, numADCSamples, numTXChannel, numChirps);
            out = permute(out, [2, 4, 1, 3]);
            % adcOut data is in the dimension of (numADCSamples, numChirps,
            % numRXChannel* numTXChannel)
            adcOut = reshape(out,  numADCSamples, numChirps, numRXChannel* numTXChannel);

            % Radar signal processing
            % 1D FFT: range FFT; range FFT size is numADCSamples  
            fftSize1D = size(adcOut,1);
            radar_data_1dFFT = fft(adcOut,[], 1);%.*window_1D 

            % 2D FFT: Doppler FFT; Doppler FFT size is numChirps. 
            % without fftshift, the zero Doppler bin is index 1. 
            fftSize2D = size(adcOut, 2);
            radar_data_2dFFT = fft(radar_data_1dFFT(:,1:end, :),[], 2); %.*window_2D
            % non-coherent combination cross antenna to get ready for peak detection.
            radar_data_2dFFTMag = sum(abs(radar_data_2dFFT).^2, 3); 
            if (PLOT_2D_FFT)
                % plot ADC raw data to check saturation or any abnormal behavior
                figure(5); hold on; plot(((adcOut(:,:,1))));
                title('ADC samples for antenna TX1-RX1')
                % plot the 2D FFT output for sanity check
                range_axis = (0:radarParam.numADCSamples-1)*radarParam.rangeResolution_m;
                figure(7); hold on; plot(range_axis, 10*log10(abs(radar_data_2dFFTMag)));
                xlabel('range (m)')
                ylabel('Amplitude (dB)')
                title('2D FFT output with non-coherent combination cross antennas')
                grid on;   
            end    
        end
        fclose(fid);
end

function adcOut = dataParsing_lowPowerDevice(dataChunk)
    % 64xx/14xx RDIF processing (adcOut is uint16 datatype)
    dataChunk = dataChunk(1:floor(length(dataChunk) / 4) * 4);  % make sure data is multiple of 64 bits
    adcOut = reshape(dataChunk, [4 (length(dataChunk) / 4)]);  % break into chunks of 64 bits
    for block64_index = 1:size(adcOut, 2)
        bit_vector = zeros(4, 12);
        for block16_index = 1:4
            % Re-arrange the bits as per RDIF Swizzling Mode (output pattern)
            bit_vector(block16_index,:) = bitget(adcOut(block16_index, block64_index), [10:12 7:9 4:6 1:3]);
        end
        bit_vector = reshape(bit_vector, [12, 4]);  % partition into 12-bit values
        adcOut(:, block64_index) = 2.^(0:11) * bit_vector;  % convert bits to sample values
    end
    adcOut = reshape(adcOut, 1, []);
    adcOut = single(adcOut);
    
    % Convert from 2's complement
    l_max = 2^(12-1)-1;
    adcOut(adcOut > l_max) = adcOut(adcOut > l_max) - 2^12;

end


