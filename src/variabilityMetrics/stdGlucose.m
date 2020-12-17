function stdGlucose = stdGlucose(data)
%stdGlucose function that computes the standard deviation of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - stdGlucose: standard deviation of glucose concentration.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wikipedia on standard deviation: https://en.wikipedia.org/wiki/Standard_deviation (Accessed: 2020-12-10).
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
        error('stdGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('stdGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('stdGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('stdGlucose: data must have a column named `glucose`.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    stdGlucose = std(nonNanGlucose);
    
end

