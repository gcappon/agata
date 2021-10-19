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
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wikipedia on range: https://en.wikipedia.org/wiki/Range_(statistics) (Accessed: 2020-12-10).
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('rangeGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('rangeGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('rangeGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('rangeGlucose: data must have a column named `glucose`.')
    end
    
    %Get rid of nan
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    rangeGlucose = max(nonNanGlucose) - min(nonNanGlucose);
    if(isempty(rangeGlucose))
        rangeGlucose = nan;
    end
    
end

