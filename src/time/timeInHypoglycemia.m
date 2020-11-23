function timeInHypoglycemia = timeInHypoglycemia(data)
%timeInHypoglycemia function that computes the time spent in hypoglycemia
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInHypoglycemia: percentage of time in hypoglycemia (i.e., 
%   <70 mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInHypoglycemia = 100*sum(nonNanGlucose < 70)/length(nonNanGlucose);
    
end

