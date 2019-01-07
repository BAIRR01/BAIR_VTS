% Load the library with the alias glovelib
[result, warnings] = loadlibrary('fglove64', 'fglove.h', 'alias', 'glovelib');

% Open the glove on device usb0 (this can be replaced with a com port eg. COM1)
glovePointer = calllib('glovelib', 'fdOpen', 'usb0');
% Check the number of sensors
numSensors = calllib('glovelib', 'fdGetNumSensors', glovePointer);

%%

t0 = GetSecs();

sampleTimes = 0.050:0.050:10;

storedValues = zeros(length(sampleTimes), 5);

for ii = 1:length(sampleTimes)
    disp(sampleTimes(ii)); drawnow(); 
    while GetSecs-t0 < sampleTimes(ii)
   
    end
    
    t1 = GetSecs;
    for jj = 1:5
        sensor = (jj-1)*3;
        % Get the value of the each sensor
        storedValues(ii,jj) = calllib('glovelib', 'fdGetSensorRaw', glovePointer, sensor);
    end
    t2 = GetSecs - t1; elapsedTime(ii) = t2;
end






