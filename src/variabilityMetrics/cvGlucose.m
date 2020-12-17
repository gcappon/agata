function cvGlucose = cvGlucose(data)
%cvGlucose function that computes the coefficient of variation of the glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - cvGlucose: coefficient of variation of the glucose concentration.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wikipedia on coefficient of variation: 
%   https://en.wikipedia.org/wiki/Coefficient_of_variation (Accessed: 2020-12-10).
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
        error('cvGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('cvGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('cvGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('cvGlucose: data must have a column named `glucose`.')
    end
    
    %Compute metric
    cvGlucose = 100 * stdGlucose(data) / meanGlucose(data);

end

