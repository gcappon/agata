function timeInSevereHypoglycemia = timeInSevereHypoglycemia(data)
%timeInSevereHypoglycemia function that computes the time spent in severe 
%hypoglycemia (ignoring nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - timeInHypoglycemia: percentage of time in hypoglycemia (i.e., 
%   < 50 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInSevereHypoglycemia = 100*sum(nonNanGlucose < 50)/length(nonNanGlucose);
    
end

