function iqrGlucose = iqrGlucose(data)
%iqrGlucose function that computes the interquartile range of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - iqrGlucose: interquartile range of glucose concentration.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wikipedia on IQR: https://en.wikipedia.org/wiki/Interquartile_range (Accessed: 2020-12-10).
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
        error('iqrGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('iqrGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('iqrGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('iqrGlucose: data must have a column named `glucose`.')
    end
    
    %Get rid of nan
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    iqrGlucose = iqr(nonNanGlucose);
    
end

