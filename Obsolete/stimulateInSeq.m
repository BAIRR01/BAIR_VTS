% Vibrates the vibrotactile stimulators in order based on provided .txt file

function allOutputs = stimulateInSeq(s,outputSignal,nrStimulators, nrSweeps, order, blankTime)

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

outputSignalLength = length(outputSignal);
stimOutputs = zeros(outputSignalLength * length(stimOrderIdx) * nrSweeps, nrStimulators);
        
for ii = 1:nrSweeps
   
    
    for jj = 1:length(stimOrderIdx)
        % set all output channels to 0 except the selected one
        stimOutputs((1:outputSignalLength) + (jj - 1)*outputSignalLength ...
            + (ii - 1)*outputSignalLength*length(stimOrderIdx),...
            (stimOrderIdx(jj))) = outputSignal;
    end
end
    
allOutputs = [zeros(blankTime * s.Rate, nrStimulators); stimOutputs;...
    zeros(blankTime * s.Rate, nrStimulators)];
       
        
        %         % Add a listener to record timing
        %         lh = addlistener(s,'DataAvailable',@(src,event) table());
        %         s.NotifyWhenDataAvailableExceeds = 1000;
      
 
end



