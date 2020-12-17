function timeInSevereHypoglycemia = timeInSevereHypoglycemia(data)
%timeInSevereHypoglycemia function that computes the time spent in severe 
%hypoglycemia (ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInHypoglycemia: percentage of time in hypoglycemia (i.e., 
%   < 54 mg/dl).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - None
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('timeInSevereHypoglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInSevereHypoglycemia: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInSevereHypoglycemia: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInSevereHypoglycemia: data must have a column named `glucose`.')
    end
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    timeInSevereHypoglycemia = 100*sum(nonNanGlucose < 54)/length(nonNanGlucose);
    
end

