% Vibrates all vibrotactile stimulators at once based on provided .txt file
function stimulateAll(s,outputSignal,nrStimulators, nrReps,order, blankTime)

if ~contains (order ,'all')   % vibrate all stimulators at once
    error ('No finger order given')
else
    allOutputs = outputSignal;
    pause(12); % pause at the start of scan
    for out = 1 : (nrStimulators-1)
        % Concatenate signal for all stimulators
        allOutputs = cat(2, allOutputs, outputSignal);
    end
    
%     for ii = 1: nrReps
%         % Queue the data and start the vibration
%         queueOutputData(s, allOutputs);
%       
%     end
end
end


