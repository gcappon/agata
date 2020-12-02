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
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('timeInHypoglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInHypoglycemia: data must have a homogeneous time grid.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInHypoglycemia = 100*sum(nonNanGlucose < 70)/length(nonNanGlucose);
    
end

