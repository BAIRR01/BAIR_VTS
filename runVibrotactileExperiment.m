function runVibrotactileExperiment(VTSDeviceSess, vibrotactileStimulus)
% Runs a simple tactile experiment, the signal coded in VibrotactileStimulus is presented through the device connected
% to VTSDeviceSess
%

% queue the data and start the vibration
queueOutputData(VTSDeviceSess, vibrotactileStimulus);

%VTSDeviceSess.NotifyWhenDataAvailableExceeds = 500; %hard coded for now
%VTSDeviceSess.IsContinuous = true;
%lh = addlistener(VTSDeviceSess, 'DataAvailable' , @findStumulusTiming);

fprintf('\nStarting the vibrotactile stimulation\n');
VTSDeviceSess.startForeground;
fprintf('\nEnded the vibrotactile stimulation\n');

%delete(lh)


