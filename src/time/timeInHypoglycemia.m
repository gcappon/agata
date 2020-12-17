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
        error('timeInHypoglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInHypoglycemia: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInHypoglycemia: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInHypoglycemia: data must have a column named `glucose`.')
    end
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    timeInHypoglycemia = 100*sum(nonNanGlucose < 70)/length(nonNanGlucose);
    
end

