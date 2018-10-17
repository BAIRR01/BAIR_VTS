% Runs through the list of sequences from .txt file and calls the appropriate function to
%   start stimulation

function stimulateFingers(s,outputSignal,nrStimulators, nrReps,orderList, nrFingers)

for jj = 1: length (orderList)
    
%     choice = menu('Do you want to start the next scan?' , 'yes' , 'no');
%     if choice == 0 || choice == 2; break ;
%     else ; end % Otherwise continue
%     
    pause(pauseTime) % Blank period prior to stimulation
    
    switch orderList{jj}
        case 'all'
            % Vibrate all the stimulators at once
            %nrReps = nrReps * 5; % to match with other cases
            stimulateAll(s,outputSignal,nrStimulators, nrReps, orderList{jj})
            
        case {'random', 'ascending', 'descending'}
            
            % Check that the number of reps is divisible by the number of fingers
            if mod(nrStimulators,nrFingers) > 0
                error(['Number of stimulators: %d is not divisible by ' ...
                    'the number of fingers: %d'],nrStimulators,nrFingers );
            end
            
            % Vibrate one finger at a time in various sequences
            stimulateInSeq(s, outputSignal, nrStimulators, nrReps, orderList{jj});
            
        otherwise
            error ( 'Order list not provided')
    end
end
