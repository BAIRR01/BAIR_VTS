% Find devices
devices = daq.getDevices;

% Initialize the session and parameters
s = daq.createSession('ni');

% Rate of operation in scans per second
s.Rate              = 10000;

nrScans       = 12000; % for computation
nrReps        = 5;    % Number of repetitions
nrStimulators = 5;    % Number of stumulators
nrFingers     = 5;    % Number of fingers to be stimulated
pauseTime     = 12;   % in seconds

% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';
%daq2 = 'cDAQ1mod2';

% Create output signal (for now, use a sin wave)
outputSignal = square(linspace(0, (2*pi*5),nrScans)');

% add all the output channels to the session
for ii = 0: (nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(s,daq1, stimName, 'Voltage');
end

%% Stimulate the piezo stimulators

% load in a list of sequence orders to go through
[fname,path] = uigetfile('.txt' ,'Select order sequence file');
orderList = importdata(fullfile (path,fname));

for jj = 1: length (orderList)
    
    choice = menu('Do you want to start the next scan?' , 'yes' , 'no');
    if choice == 0 || choice == 2; break ;
    else ; end % Otherwise continue
    
    pause(pauseTime) % Blank period prior to stimulation
    
    switch orderList{jj}
        case 'all'
            % Vibrate all the stimulators at once
            nrReps = 5; % five rounds for all fingers
            stimulateAll(s,outputSignal,nrStimulators, pauseTime, nrReps, orderList{jj})
            
        case {'random', 'ascending', 'descending'}
            % Reps per finger to match with length of stimulating all fingers at once
            reps = nrReps/nrFingers;
            
            % Check that the number of reps is divisible by the number of fingers
            if mod(nrReps,nrFingers) > 0
                error(['Number of repetitions: %d is not divisible by ' ...
                    'the number of fingers: %d'],nrReps,nrFingers );
            end
            
            % Vibrate one finger at a time in various sequences 
            stimulateInSeq(s, outputSignal, nrStimulators, pauseTime, reps, orderList{jj});
            
        otherwise
            error ( 'Order list not provided')
    end
end

