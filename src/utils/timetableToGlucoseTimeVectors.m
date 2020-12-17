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
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('timetableToGlucoseTimeVectors: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timetableToGlucoseTimeVectors: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timetableToGlucoseTimeVectors: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timetableToGlucoseTimeVectors: data must have a column named `glucose`.')
    end
    
    %Conversion
    dataVector = data.glucose;
    timeVector = data.Time;
    
end

