function timeInTarget = timeInTarget(data)
%timeInTarget function that computes the time spent in the target range 
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInTarget: percentage of time in hypoglycemia (i.e., 
%   between 70 and 180 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInTarget = 100*sum(nonNanGlucose >= 70 & nonNanGlucose <= 180)/length(nonNanGlucose);
    
end

