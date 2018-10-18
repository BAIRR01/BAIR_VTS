% Runs through the list of sequences from .txt file and calls the appropriate function to
%   start stimulation

function allOutputs = stimulateFingers(s,outputSignal,nrStimulators, nrSweeps,orderList, nrFingers, blankTime)

for jj = 1: length (orderList)
    
    %     choice = menu('Do you want to start the next scan?' , 'yes' , 'no');
    %     if choice == 0 || choice == 2; break ;
    %     else ; end % Otherwise continue
    
    switch orderList{jj}
        case 'all'
            % Vibrate all the stimulators at once
            %nrReps = nrReps * 5; % to match with other cases
            stimulateAll(s,outputSignal,nrStimulators, nrSweeps, orderList{jj}, blankTime)
            
        case {'random', 'ascending', 'descending'}
            
            % Check that the number of reps is divisible by the number of fingers
            if mod(nrStimulators,nrFingers) > 0
                error(['Number of stimulators: %d is not divisible by ' ...
                    'the number of fingers: %d'],nrStimulators,nrFingers );
            end
            
            % Vibrate one finger at a time in various sequences
            allOutputs = stimulateInSeq(s, outputSignal, nrStimulators, nrSweeps, orderList{jj},blankTime);
            
        otherwise
            error ( 'Order list not provided')
    end
    pause(12); % pause at the end of scan
end
