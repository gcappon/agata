function jIndex = jIndex(data)
%jIndex function that computes the jIndex of the glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - jIndex: jIndex of the glucose concentration.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wójcicki, "J-index. A new proposition of the assessment of current 
%   glucose control in diabetic patients", Hormone and Metabolic Reseach, 
%   1995, vol. 27, pp. 41-42. DOI: 10.1055/s-2007-979906.
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
        error('jIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('jIndex: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('jIndex: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('jIndex: data must have a column named `glucose`.')
    end
    
    %Compute metric
    jIndex = 1e-3 * (meanGlucose(data) + stdGlucose(data)) ^ 2;
    
end

