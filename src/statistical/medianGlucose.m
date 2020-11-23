function medianGlucose = medianGlucose(data)
%medianGlucose function that computes the median glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - medianGlucose: median glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    medianGlucose = median(nonNanGlucose);
    
end

