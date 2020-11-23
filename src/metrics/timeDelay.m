function timeDelay = timeDelay(data,dataHat, sampleTime)
%timeDelay function that computes the delay of a predicted glucose trace. 
%The time delay is computed as the time shift necessary to maximize the 
%correlation between the two traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`;
%   - sampleTime: the sample time of the given data (in min).
%Output:
%   - timeDelay: the computed delay (min).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    timeDelay = finddelay( data.glucose(idx), dataHat.glucose(idx)) * sampleTime;
    
end