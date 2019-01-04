function [elapsedTime, datagloveValues] = sampleDataglove (glovePointer)

t0 = GetSecs();

% take dataglove measurements at these time points
sampleTimes = 0.050:0.050:10;

sensors = 3:3:15;
datagloveValues = zeros(length(sampleTimes), 5);

for ii = 1:length(sampleTimes)
    disp(sampleTimes(ii)); drawnow();
    while GetSecs-t0 < sampleTimes(ii)
        
    end
    
    t1 = GetSecs;
    for jj = 1:length(sensors)
        % Get the value of the each sensor
        datagloveValues(ii,jj) = calllib('glovelib', 'fdGetSensorRaw', glovePointer, sensors(jj));
    end
    t2 = GetSecs - t1; elapsedTime(ii) = t2;
end
