function [startTime,endTime] = runVibrotactileExperiment(VTSDeviceSess, vibrotactileStimulus)
% Runs a simple tactile experiment, the signal coded in VibrotactileStimulus is presented through the device connected
% to VTSDeviceSess
%

%VTSDeviceSess.NotifyWhenDataAvailableExceeds = 500; %hard coded for now
%VTSDeviceSess.IsContinuous = true;
%lh = addlistener(VTSDeviceSess, 'DataAvailable' , @findStumulusTiming);

fprintf('\nStarting the vibrotactile stimulation\n');
startTime = GetSecs();

[data,timeStamps,triggerTime] = VTSDeviceSess.startForeground;

endTime = GetSecs();
fprintf('\nEnded the vibrotactile stimulation\n');

%delete(lh)


