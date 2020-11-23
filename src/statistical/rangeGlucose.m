function rangeGlucose = rangeGlucose(data)
%rangeGlucose function that computes the range spanned by the glucose
%concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - rangeGlucose: range spanned by the glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    rangeGlucose = max(nonNanGlucose) - min(nonNanGlucose);
    
end

