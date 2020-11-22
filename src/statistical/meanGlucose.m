function meanGlucose = meanGlucose(data)
%meanGlucose function that computes the mean glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - meanGlucose: mean glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    meanGlucose = mean(nonNanGlucose);
    
end

