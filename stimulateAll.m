% Vibrates all vibrotactile stimulators at once based on provided .txt file

function stimulateAll(s,outputSignal,nrStimulators, pauseTime, nrReps, order)
for ii = 1: (nrReps)
    if ~contains (order ,'all')   % vibrate all stimulators at once
        error ('No finger order given')
    else
        allOutputs = outputSignal;
        
        for out = 1 : (nrStimulators-1)
            % Concatenate signal for all stimulators
            allOutputs = cat(2, allOutputs, outputSignal); 
        end
        
        % Queue the data and start the vibration
        queueOutputData(s, repmat(allOutputs, 10, 1));
        s.startForeground;
    end
    pause(pauseTime); % pause between each repetition
end
pause(pauseTime); % pause before end of scan
end

