function timeInSevereHyperglycemia = timeInSevereHyperglycemia(data)
%timeInSevereHyperglycemia function that computes the time spent in severe
%hyperglycemia (ignoring nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - timeInSevereHyperglycemia: percentage of time in hyperglycemia (i.e., 
%   > 250 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInSevereHyperglycemia = 100*sum(nonNanGlucose > 250)/length(nonNanGlucose);
    
end

