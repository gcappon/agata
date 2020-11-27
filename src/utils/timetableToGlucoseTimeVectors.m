function [dataVector, timeVector] = timetableToGlucoseTimeVectors(data)
%timetableToGlucoseTimeVectors function that converts a timetable with column 
%`Time` and `glucose` containing the timestamps and the respective glucose data,
%in two vectors: one containing the timestamp data in the `Time` column and
%the other containing the glucose data in the `glucose` column. 
%
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Outputs:
%   - dataVector: a vector of double containing the glucose data
%   in the `glucose` column;
%   - timeVector: a vector of datetime containing the timestamp data
%   in the `Time` column;
%
%Preconditions:
%   - `data` must be a timetable having an homogeneous time grid.
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
        error('timetableToGlucoseTimeVectors: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timetableToGlucoseTimeVectors: data must have a homogeneous time grid.')
    end
    
    dataVector = data.glucose;
    timeVector = data.Time;
    
end

