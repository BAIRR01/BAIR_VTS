function stimulus = findStimulusTiming(src, event)
if event.Data < (12 * src.Rate)
    %do nothing
else
    stimulus.onset = event.TimeStamps;
end