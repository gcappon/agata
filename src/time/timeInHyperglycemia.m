function timeInHyperglycemia = timeInHyperglycemia(data)
%timeInHyperglycemia function that computes the time spent in hyperglycemia
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInHyperglycemia: percentage of time in hyperglycemia (i.e., 
%   > 180 mg/dl).
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
        error('timeInHyperglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timeInHyperglycemia: data must have a homogeneous time grid.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInHyperglycemia = 100*sum(nonNanGlucose > 180)/length(nonNanGlucose);
    
end

