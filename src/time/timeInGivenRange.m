function timeInGivenRange = timeInGivenRange(data, minValue, maxValue)
%timeInGivenRange function that computes the time spent in a given range 
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - minValue: the minimum value of the specified range (in mg/dl);
%   - maxValue: the maximum value of the specified range (in mg/dl).
%Output:
%   - timeInGivenRange: percentage of time spent in the given range (i.e.
%   >= minValue and <= maxValue).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - minValue must be smaller or equal to maxValue.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('timeInGivenRange: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInGivenRange: data must have a homogeneous time grid.')
    end
    if(minValue > maxValue)
        error('timeInGivenRange: minValue must be smaller or equal to maxValue.')
    end

    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInGivenRange = 100*sum(nonNanGlucose >= minValue & nonNanGlucose <= maxValue)/length(nonNanGlucose);
    
end
