% Vibrates the vibrotactile stimulators in order based on provided .txt file

function stimulateInSeq(s,outputSignal,nrStimulators, nrReps, order)

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

for ii = 1: nrReps
    % find the length of the signal we want to use
    outputDur = length(outputSignal);
    
    for jj = 1:nrStimulators
        % set all output channels to 0 except the selected one
        allOutputs = zeros(outputDur, nrStimulators);
        allOutputs(:, (stimOrderIdx(jj))) = outputSignal;
        
        % queue the data and start the vibration
        queueOutputData(s, allOutputs);
        
        %         % Add a listener to record timing
        %         lh = addlistener(s,'DataAvailable',@(src,event) table());
        %         s.NotifyWhenDataAvailableExceeds = 1000;
        s.startBackground;
    end
end
pause(12); % pause at the end of scan
end


