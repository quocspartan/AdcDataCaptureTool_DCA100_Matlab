function [cfg] = defineCLICommands(deviceType)
    %Supports CLIs as defined in SDK 3.3.x (and later) and SDK 5.1.0.4 (and later)
    %TODO: Add support for different SDK versions
    
    cfg = struct('command', [], 'parameters', [], 'units', []);
   
    switch deviceType
        case 'xWR6843/xWR1843/xWR1642'
            i=1;
            cfg(i).command = 'dfeDataOutputMode';
            cfg(i).parameters = struct('modeType', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'channelCfg';
            cfg(i).parameters = struct('rxChannelEn', 0, 'txChannelEn', 0, 'cascading', 0);
            cfg(i).units = {'', '', ''};

            i=i+1;
            cfg(i).command = 'adcCfg';
            cfg(i).parameters = struct('numADCBits', 0, 'adcOutputFmt', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'adcbufCfg';
            cfg(i).parameters = struct('subFrameidx', 0, 'adcOutputFmt', 0, 'sampleSwap', 0, ...
                'chanInterleave', 0, 'chirpThreshold', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'profileCfg';
            cfg(i).parameters = struct('profileId', 0, 'startFreq', 0, 'idleTime', 0, ...
                'adcStartTime', 0, 'rampEndTime', 0, 'txOutPower', 0, 'txPhaseShifter', 0,...
                'freqSlopeConst', 0, 'txStartTime', 0, 'numADCSamples', 0,...
                'digOutSampleRate', 0, 'hpfCornerFreq1', 0, 'hpfCofnerFreq2', 0,...
                'rxGain', 0);
            cfg(i).units = {'-', 'GHz', 'usec', 'usec', 'usec', '-', '-', 'MHz/usec'};

            i=i+1;
            cfg(i).command = 'chirpCfg';
            cfg(i).parameters =struct('chirpStartIndex', 0, 'chirpEndIndex', 0, ...
                'profileIdentifier', 0, 'startFrequencyVariation', 0, ...
                'frequencySlopeVariation', 0, 'idleTimeVariation', 0, ...
                'adcStartTimeVariation', 0, 'txEnableMask', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'lowPower';
            cfg(i).parameters = struct('DNC', 0, 'adcMode', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'frameCfg';
            cfg(i).parameters = struct('chirpStartIndex', 0, 'chirpEndIndex', 0, ...
                'numLoops', 0, 'numFrames', 0, 'framePeriodicity', 0, ...
                'triggerSelect', 0, 'frameTriggerDelay', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'advFrameCfg';
            cfg(i).parameters = struct('numOfSubFrames', 0, 'forceProfile', 0, ...
                'numFrames', 0, 'triggerSelect', 0, 'frameTrigDelay', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'subFrameCfg';
            cfg(i).parameters = struct('subFrameNum', 0, 'forceProfileIdex', 0, ...
                'chirpStartIdx', 0, 'numOfChirps', 0, 'numLoops', 0, ...
                'burstPeriodicity', 0, 'chirpStartIdxOffset', 0, 'numOfBurst', 0,...
                'numOfBurstLoops', 0, 'subFramePeriodicity', 0);
            cfg(i).units = {};


            i=i+1;
            cfg(i).command = 'guiMonitor';
            cfg(i).parameters = struct('subFrameIdx', 0, 'detectedObjects', 0, 'logMagRange', 0,...
                'noiseProfile', 0, 'rangeAzimuthHeatMap', 0, 'rangeDopplerHeatMap', 0,...
                'statsInfo', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'cfarCfg';
            cfg(i).parameters = struct('subFrameIdx', 0, 'procDirection', 0, 'mode', 0,...
                'noiseWin', 0, 'guardLen', 0, 'divShift', 0,...
                'cyclicWrapMode', 0, 'thresholdScale', 0, 'peakGrouping', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'multiObjBeamForming';
            cfg(i).parameters = struct('subFrameIdx', 0, 'featureEnabled', 0, 'threshold', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'calibDcRangeSig';
            cfg(i).parameters = struct('subFrameIdx', 0, 'enabled', 0, 'negativeBinIdx', 0,...
                'positiveBinIdx', 0, 'numAvg', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'clutterRemoval';
            cfg(i).parameters = struct('subFrameIdx', 0, 'enabled', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'aoaFovCfg';
            cfg(i).parameters = struct('subFrameIdx', 0, 'minAzimuthDeg', 0, 'maxAzimuthDeg', 0, 'minElevationDeg', 0, 'maxElevationDeg', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'cfarFovCfg';
            cfg(i).parameters = struct('subFrameIdx', 0, 'procDirection', 0, 'min', 0, 'max', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'compRangeBiasAndRxChanPhase';
            cfg(i).parameters = struct('rangeBias', 0, 'Re_VA_1', 0, 'Im_VA_1', 0,...
                'Re_VA_2', 0, 'Im_VA_2', 0, 'Re_VA_3', 0, 'Im_VA_3', 0, 'Re_VA_4', 0,...
                'Im_VA_4', 0, 'Re_VA_5', 0, 'Im_VA_5', 0, 'Re_VA_6', 0, 'Im_VA_6', 0,...
                'Re_VA_7', 0, 'Im_VA_7', 0 ,'Re_VA_8', 0, 'Im_VA_8', 0 ,'Re_VA_9', 0,...
                'Im_VA_9', 0, 'Re_VA_10', 0, 'Im_VA_10', 0, 'Re_VA_11', 0, 'Im_VA_11', 0,...
                'Re_VA_12', 0, 'Im_VA_12', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'measureRangeBiasAndRxChanPhase';
            cfg(i).parameters = struct('enabled', 0, 'targetDistance', 0, 'searchWin', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'extendedMaxVelocity';
            cfg(i).parameters = struct('subFrameIdx', 0, 'enabled', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'CQRxSatMonitor';
            cfg(i).parameters = struct('profile', 0, 'satMonSel', 0, 'priSliceDuration', 0, 'numSlices', 0, 'rxChanMask',0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'CQSigImgMonitor';
            cfg(i).parameters = struct('profile', 0, 'numSlices', 0, 'numSamplePerSlice',0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'analogMonitor';
            cfg(i).parameters = struct('rxSaturation', 0, 'sigImgBand', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'lvdsStreamCfg';
            cfg(i).parameters = struct('subFrameIdx', 0, 'enableHeader', 0, 'dataFmt', 0, 'enableSW', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'bpmCfg';
            cfg(i).parameters = struct('subFrameIdx', 0, 'enabled', 0, 'chirp0Idx', 0, 'chirp1Idx', 0);
            cfg(i).units = {};

        case 'xWRL6432/xWRL1432' 
            i=1;
            cfg(i).command = 'channelCfg';
            cfg(i).parameters = struct('rxChannelEn', 0, 'txChannelEn', 0, 'frameTrigMode', 0);
            cfg(i).units = {'', '', ''};

            i=i+1;
            cfg(i).command = 'chirpComnCfg';
            cfg(i).parameters = struct('adcSampRatio', 0, 'digOutputBitsSel', 0, 'dfeFirSel', 0, ...
                'numOfAdcSamples', 0, 'chirpTxMimoPatSel', 0, 'chirpRampEndTime', 0, 'chirpRxHpfSel', 0);
            cfg(i).units = {'-', '-', '-', '-', '-', 'us', '-'};

            i=i+1;
            cfg(i).command = 'chirpTimingCfg';
            cfg(i).parameters =struct('chirpIdleTime', 0, 'chirpAdcSkipSamples', 0, ...
                'chirpTxStartTime', 0, 'chirpRfFreqSlope', 0, 'chirpRfFreqStart', 0);
            cfg(i).units = {};

            i=i+1;
            cfg(i).command = 'frameCfg';
            cfg(i).parameters = struct('numOfChirpsInBurst', 0, 'numOfChirpsAccum', 0, ...
                'burstPeriodicity', 0, 'numOfBurstsInFrame', 0, 'framePeriodicity', 0, ...
                'numOfFrames', 0);
            cfg(i).units = {};

        otherwise
            fprintf('Unsupported device Type');
    end
    
    
    
end

