% Vibrates the vibrotactile stimulators in order based on provided .txt file

function stimulateInSeq(s,outputSignal,nrStimulators, pauseTime, nrReps, order)
for ii = 1: nrReps
    
    switch order
        case 'random'     % random sampling of fingers
            stimOrderIdx = randperm (nrStimulators);
        case 'ascending'  % from thumb towards pinky
            stimOrderIdx = sort((1:nrStimulators), 'ascend');
        case 'descending' % from pinky towards thumb
            stimOrderIdx = sort((1:nrStimulators), 'descend');
        otherwise
            error ('No order sequence specified')
    end
    
    % find the length of the signal we want to use
    outputDur = length(outputSignal);
    
    for jj = 1:nrStimulators
        % set all output channels to 0 except the selected one
        allOutputs = zeros(outputDur, nrStimulators);
        allOutputs(:, (stimOrderIdx(jj))) = outputSignal;
        
        % queue the data and start the vibration
        queueOutputData(s, repmat(allOutputs, 10, 1));
        s.startForeground;
        
        pause(pauseTime); % pause between fingers
    end
end
pause(pauseTime); % pause at the end of scan
end


