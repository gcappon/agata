function aucGlucose = aucGlucose(data)
%aucGlucose function that computes the area under the curve (AUC) of glucose 
%concentration (ignores nan values), i.e., the area between the glucose
%trace and zero. It assumes that the glucose value between two samples is
%constant.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - aucGlucose: area under the curve of glucose concentration (mg/dl*min).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Wikipedia on AUC: https://en.wikipedia.org/wiki/Integral (Accessed: 2020-12-10).
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
        error('aucGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('aucGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('aucGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('aucGlucose: data must have a column named `glucose`.')
    end
    
    %Compute metric
    aucGlucose = aucGlucoseOverBasal(data,0);
    
end

