function timeDelay = timeDelay(data,dataHat)
%timeDelay function that computes the delay of a predicted glucose trace. 
%The time delay is computed as the time shift necessary to maximize the 
%correlation between the two traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`;
%Output:
%   - timeDelay: the computed delay (min).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - dataHat must be a timetable having an homogeneous time grid;
%   - data and dataHat must start from the same timestamp;
%   - data and dataHat must end with the same timestamp;
%   - data and dataHat must have the same length.
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
        error('timeDelay: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timeDelay: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('timeDelay: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timeDelay: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('timeDelay: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('timeDelay: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('timeDelay: data and dataHat must have the same length.')
    end
    
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    timeDelay = finddelay( data.glucose(idx), dataHat.glucose(idx)) * minutes(data.Time(2)-data.Time(1));
    
end