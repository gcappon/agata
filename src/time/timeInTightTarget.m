function timeInTightTarget = timeInTightTarget(data)
%timeInTarget function that computes the time spent in the tight target range 
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInTightTarget: percentage of time in hypoglycemia (i.e., 
%   between 90 and 140 mg/dl).
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
        error('timeInTightTarget: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInTightTarget: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInTightTarget: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInTightTarget: data must have a column named `glucose`.')
    end
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    timeInTightTarget = 100*sum(nonNanGlucose >= 90 & nonNanGlucose <= 140)/length(nonNanGlucose);
    
end

