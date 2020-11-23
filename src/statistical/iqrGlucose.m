function iqrGlucose = iqrGlucose(data)
%iqrGlucose function that computes the interquartile range of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - iqrGlucose: interquartile range of glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    iqrGlucose = iqr(nonNanGlucose);
    
end

