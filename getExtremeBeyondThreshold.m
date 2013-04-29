%% Returns max/min of all values in vals, that are above/below threshold
% If no value works, returns the value closest to threshold
% Vals - array of values
% threshold - number, minimum for min, and maximum for max
% maxOrMin - 'max' or 'min'
function[extremeVal] = getExtremeBeyondThreshold(vals, threshold, maxOrMin)

if (strcmp(maxOrMin, 'max'))
    extremeVal = -inf;
elseif (strcmp(maxOrMin, 'min'))
    extremeVal = +inf;
else
    'ERROR IN getExtremeAboveThreshold - invalid arg maxOrMin';
end

for i=1:length(vals)
    val = vals(i);
    if (strcmp(maxOrMin, 'max'))
        if (val > extremeVal && val < threshold)
            extremeVal = val;
        end
    else %Min
        if (val < extremeVal && val > threshold)
            extremeVal = val;
        end
    end
end

% If no suitable val, find closest to threshold
if (extremeVal == -inf || extremeVal == +inf)
    for i=1:length(vals)
        val = vals(i);
        if (abs(val - threshold) < abs(extremeVal - threshold))
            extremeVal = val;
        end
    end
end