function cvGlucose = cvGlucose(data)
%cvGlucose function that computes the coefficient of variation of the glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - cvGlucose: coefficient of variation of the glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    cvGlucose = 100 * stdGlucose(data) / meanGlucose(data);

end

