function runVibrotactileExperiment(structureVibrotactileDevice, stimulusVibrotactileExperiment)
% Runs a simple tactile experiment, the device coded in
% stimulusVibrotactileExperiment is presented through the device connected
% to
% structureVibrotactileDevice
%

% queue the data and start the vibration
queueOutputData(structureVibrotactileDevice, stimulusVibrotactileExperiment);
fprintf('\nstart the vibrotactile stimulation\n');
structureVibrotactileDevice.startForeground;
fprintf('\nended the vibrotactile stimulation\n');


