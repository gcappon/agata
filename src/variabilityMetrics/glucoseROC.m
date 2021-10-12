function glucoseROC = glucoseROC(data)
%glucoseROC function that computes the glucose rate-of-change (ROC) trace. 
%As defined in the given reference, ROC at time t is defined as the difference
%between the glucose at time t and t-15 minutes divided by 15. By
%definition, the first two samples are always nan (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - glucoseROC: a timetable with column `Time` and `glucoseROC` containing the 
%   glucose ROC (in mg/dl/min). 
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose
%   Monitor Data", Diabetes Technol Ther, 2009,
%   vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('glucoseROC: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('glucoseROC: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('glucoseROC: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('glucoseROC: data must have a column named `glucose`.')
    end
    
    %Initialize glucoseROC
    glucoseROC = data;    
    glucoseROC.glucoseROC = data.glucose*nan;
    glucoseROC.glucose = [];
    
    %Compute glucose ROC for each point
    for t = 4:length(data.Time)
        glucoseROC.glucoseROC(t) = (data.glucose(t) - data.glucose(t-3)) / 15;
    end
    
end

