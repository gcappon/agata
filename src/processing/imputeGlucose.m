function dataImputed = imputeGlucose(data, maxGap)
%imputeGlucose function that imputes missing glucose data using linear 
%interpolation. The function imputes only missing data gaps of maximum
%`maxGap` minutes. Gaps longer than `maxGap` minutes are ignored.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to retime (in mg/dl);
%   - maxGap: an integer defining the maximum interpol-able missing data 
%   gaps (in min). 
%Output:
%   - dataImputed: the retimed timetable.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`;
%   - maxGap must be an integer.
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
        error('imputeGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('imputeGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('imputeGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('imputeGlucose: data must have a column named `glucose`.')
    end
    if( ~( isnumeric(maxGap) && ((maxGap - round(maxGap)) == 0) ) )
        error('imputeGlucose: maxGap must be an integer.')
    end
    
    %Get the sample time
    sampleTime = minutes(data.Time(2)-data.Time(1));
    
    %Find the interpolable gaps 
    [shortNan, longNan, nanStart, nanEnd] = findNanIslands(data,round(maxGap/sampleTime));
    
    %Impute data
    dataImputed = data;
    dataImputed.glucose(shortNan) = interp1(data.Time(~isnan(data.glucose)),data.glucose(~isnan(data.glucose)),data.Time(shortNan),'linear','extrap');

end

