function [time0, quitProg] = VTS_pressKey2Begin(params)
% [time0, quitProg] = pressKey2Begin(params)
%   Displays 'please press any key to begin' on the SCREEN
%   just below the center of the screen and waits for the
%   user to press a key.
% returns the current time at start of scan, and ok (true if experiment is
%       started, false if the quit key is pressed)


if ischar(params.triggerKey)
    promptString = sprintf('Running pattern:%s run %d. Please press %s key to begin, or %s to quit.', ...
        params.experiment, params.runID, params.triggerKey, params.quitProgKey);
else
    promptString = sprintf('Running pattern:%s run %d. Experiment will begin when trigger is received.', ...
        params.experiment, params.runID);
end

Screen('FillRect', params.display.windowPtr, params.display.backColorRgb);
drawFixation(params);

dispStringInCenter(params, promptString, 0.55);

iwait = true;

while iwait
    WaitSecs(0.01);
       
    % KbWait and KbCheck are device dependent. We use KbCheck in a
    % while loop instead of KbWait, as KbWait is reported to be
    % unreliable and would need a device input as well.
    
    [ssKeyIsDown, ~, ssKeyCode] = KbCheck(-1);
    
    if ssKeyIsDown
        str = KbName(find(ssKeyCode));
        if iscell(str), str = str{1}; end
        
        % we just query the first element in str because  KbName
        % and KbCheck when used together can return unwanted
        % characters (for example, KbName(KbCheck) return '5%' when
        % only the '5' key is pressed).
        str = str(1);
        
        switch str
            case params.quitProgKey
                % Quit the experiment gracefully
                quitProg = true;
                break;
                
            case params.triggerKey
                iwait = false;
                quitProg = false;
                drawFixation(params);
                Screen('Flip',display.windowPtr);
            otherwise
                % do nothing
        end
    end
end

time0 = GetSecs;

return;


