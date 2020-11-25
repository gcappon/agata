function timeInSevereHyperglycemia = timeInSevereHyperglycemia(data)
%timeInSevereHyperglycemia function that computes the time spent in severe
%hyperglycemia (ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInSevereHyperglycemia: percentage of time in hyperglycemia (i.e., 
%   > 250 mg/dl).
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
        error('timeInSevereHyperglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timeInSevereHyperglycemia: data must have a homogeneous time grid.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    timeInSevereHyperglycemia = 100*sum(nonNanGlucose > 250)/length(nonNanGlucose);
    
end

