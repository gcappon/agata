function timeInL2Hypoglycemia = timeInL2Hypoglycemia(data)
%timeInL2Hypoglycemia function that computes the time spent in level 2 
%hypoglycemia (ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - timeInSevereHypoglycemia: percentage of time in level 2 hypoglycemia (i.e., 
%   < 54 mg/dl).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Battelino et al., "Continuous glucose monitoring and merics for 
%   clinical trials: An international consensus statement", The Lancet
%   Diabetes & Endocrinology, 2022, pp. 1-16.
%   DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
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
        error('timeInL2Hypoglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInL2Hypoglycemia: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInL2Hypoglycemia: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInL2Hypoglycemia: data must have a column named `glucose`.')
    end
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    timeInL2Hypoglycemia = 100*sum(nonNanGlucose < 54)/length(nonNanGlucose);
    
end

