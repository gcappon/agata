function timeInHyperglycemia = timeInHyperglycemia(data)
%timeInHyperglycemia function that computes the time spent in hyperglycemia
%(ignoring nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - timeInHyperglycemia: percentage of time in hyperglycemia (i.e., 
%   > 70 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInHyperglycemia = 100*sum(nonNanGlucose > 180)/length(nonNanGlucose);
    
end

