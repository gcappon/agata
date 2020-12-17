function dataRetimed = retimeGlucose(data, timestep)
%retimeGlucose function that retimes the given `data` timetable to a  
%new timetable with homogeneous `timestep`. It puts nans where glucose
%datapoints are missing and it uses mean to solve conflicts (i.e., when two
%glucose datapoints have the same retimed timestamp.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to retime (in mg/dl);
%   - timestep: an integer defining the timestep to use in the new timetable. 
%Output:
%   - dataRetimed: the retimed timetable.
%
%Preconditions:
%   - data must be a timetable;
%   - data must contain a column named `Time` and another named `glucose`;
%   - timestep must be an integer.
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
        error('retimeGlucose: data must be a timetable.');
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('retimeGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('retimeGlucose: data must have a column named `glucose`.')
    end
    if( ~( isnumeric(timestep) && ((timestep - round(timestep)) == 0) ) )
        error('retimeGlucose: timestep must be an integer.')
    end
    
    
    %Create the new timetable
    data.Time.Second(1) = round(data.Time.Second(1)/60)*60;
    newTime = data.Time(1):minutes(timestep):data.Time(end);
    dataRetimed = timetable(nan(length(newTime),1),nan(length(newTime),1),'VariableNames', {'glucose','k'}, 'RowTimes', newTime);
    
    %Remove nan entries from data
    data = data(~isnan(data.glucose),:);
    
    for t = 1:length(data.Time)
        
        %Find the nearest timestamp
        distances = abs(data.Time(t) - dataRetimed.Time);
        nearest = find(min(distances) == distances,1,'first');
        
        %Manage conflicts computing their average
        if(isnan(dataRetimed.glucose(nearest)))
            dataRetimed.glucose(nearest) = data.glucose(t);
            dataRetimed.k(nearest) = 1;
        else
            dataRetimed.glucose(nearest) = dataRetimed.glucose(nearest) + data.glucose(t);
            dataRetimed.k(nearest) = dataRetimed.k(nearest)+ 1;
        end
        
    end
    
    %Compute the average and remove column 'k'
    dataRetimed.glucose = dataRetimed.glucose ./ dataRetimed.k;
    dataRetimed.k = [];
    
end

