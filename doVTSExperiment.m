function quitProg = doVTSExperiment(params, VTSOptions, VTSDevice)

% Set screen params
params = setScreenParams(params);

% Set fixation params
params.dstRect = [592 172 1328 908]; %for NYU3T
params         = setFixationParamsVTS(params);

% WARNING! ListChar(2) enables Matlab to record keypresses while disabling
% output to the command window or editor window. This is good for running
% experiments because it prevents buttonpresses from accidentally
% overwriting text in scripts. But it is dangerous because if the code
% quits prematurely, the user may be left unable to type in the command
% window. Command window access can be restored by control-C.
ListenChar(2);

% loading mex functions for the first time can be
% extremely slow (seconds!), so we want to make sure that
% the ones we are using are loaded.
KbCheck;GetSecs;WaitSecs(0.001);

PsychDebugWindowConfiguration(0,0.5);
% Turn off screen warnings
Screen('Preference','VisualDebugLevel', 0);

% check for OpenGL
AssertOpenGL;
Screen('Preference','SkipSyncTests', params.skipSyncTests);

% Open the screen
params.display = openScreen(params.display);

% to allow blending
Screen('BlendFunction', params.display.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% set priority
Priority(params.runPriority);

%create vibrotactile stimulus
vibrotactileStimulus = createVibrotactileStimulus(params.experiment, VTSOptions);
% queue the data
queueOutputData(VTSDevice, vibrotactileStimulus);

% wait for go signal
[triggerTime, quitProg] = VTS_pressKey2Begin(params);
%
if ~quitProg
    % Do the experiment!
    [startTime,endTime] = runVibrotactileExperiment(VTSDevice, vibrotactileStimulus);
    
    fprintf(['\nstart delay (ms): ', num2str(round((startTime - triggerTime)*1000)),'\n'])
    fprintf(['\nstimulus duration (ms): ', num2str(round((endTime - startTime)*1000)),'\n'])

    % After experiment
    
    %     % Add table with elements to write to tsv file for BIDS
    %     onset       = reshape([0 round(stimulus.onsets,3)], [length(stimulus.onsets) 1]);
    %     duration    = ones(length(stimulus.onsets),1) * (length(fullCycle)/s.Rate); %seconds
    %     trial_location  = %figure out 
    %     trial_type  = repmat({orderList}, length(outputSignal),1);
    %
    %     % Write out the tsv file
    %     stimulus.tsv = table(onset, duration, trial_type, trial_name);
    
    % Reset priority
    Priority(0);
    
    %     % Save TSV
    %      if any(contains(fieldnames(stimulus), 'tsv'))
    %         numberOfEventsPerRun = size(stimulus.tsv,1);
    %         stimulus.tsv.stim_file = repmat(sprintf('%s.mat', fname), numberOfEventsPerRun,1);
    %         writetable(stimulus.tsv, fullfile(pth, sprintf('%s.tsv', fname)), ...
    %             'FileType','text', 'Delimiter', '\t')
    %      end
end
% Close the one on-screen and many off-screen windows
closeScreen(params.display);
ListenChar(1)
return;

