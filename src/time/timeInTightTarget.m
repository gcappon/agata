function timeInTightTarget = timeInTightTarget(data)
%timeInTarget function that computes the time spent in the tight target range 
%(ignoring nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - timeInTightTarget: percentage of time in hypoglycemia (i.e., 
%   between 90 and 140 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInTightTarget = 100*sum(nonNanGlucose >= 90 & nonNanGlucose <= 140)/length(nonNanGlucose);
    
end

