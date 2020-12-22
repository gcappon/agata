function dataDetrended = detrendGlucose(data)
%detrendGlucose function that detrends glucose data. To do that, the 
%function computes the slope of the immaginary line that "links" the first
%and last glucose datapoints in the timeseries, then it "flatten" the
%entire timeseries according to that slope.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to retime (in mg/dl).
%Output:
%   - dataDetrended: the detrended timetable.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
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
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('detrendGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('detrendGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('detrendGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('detrendGlucose: data must have a column named `glucose`.')
    end

    %Compute the slope
    sampleTime = minutes(data.Time(2)-data.Time(1));
    firstPoint = find(~isnan(data.glucose),1,'first');
    lastPoint = find(~isnan(data.glucose),1,'last');
    m = ( data.glucose(lastPoint) - data.glucose(firstPoint) ) / ((lastPoint - firstPoint)*sampleTime);
    
    %Detrend the original glucose data
    dataDetrended = data;
    dataDetrended.glucose = dataDetrended.glucose(:) - m*(0:(height(data)-1))'*sampleTime;

end

