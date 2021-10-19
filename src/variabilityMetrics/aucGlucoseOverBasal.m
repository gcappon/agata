function aucGlucoseOverBasal = aucGlucoseOverBasal(data,basal)
%aucGlucoseOverBasal function that computes the area under the curve (AUC) 
%of glucose concentration over a basal value (ignores nan values). This
%means that glucose values above the given `basal` value will sum up in
%positive AUC, while glucose values below the given `basal` value will sum up
%in negative AUC. It assumes that the glucose value between two samples is
%constant.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - basal: a double defining the basal value to use (mg/dl). 
%Output:
%   - aucGlucoseOverBasal: area under the curve of glucose concentration
%   over the basal value (mg/dl*min).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`;
%   - basal must be a number.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - None.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('aucGlucoseOverBasal: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('aucGlucoseOverBasal: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('aucGlucoseOverBasal: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('aucGlucoseOverBasal: data must have a column named `glucose`.')
    end
    if(~isnumeric(basal))
        error('aucGlucoseOverBasal: basal value must be a number.')
    end
    
    %Get rid of nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Shift the trace    
    nonNanGlucose = nonNanGlucose - basal;
    
    %Compute index
    sampleTime = minutes(data.Time(2) - data.Time(1));
    
    aucGlucoseOverBasal = sum(nonNanGlucose*sampleTime);
    if(isempty(nonNanGlucose))
        aucGlucoseOverBasal = nan;
    end
    
end

