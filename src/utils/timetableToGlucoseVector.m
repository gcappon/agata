function dataVector = timetableToGlucoseVector(data)
%timetableToGlucoseVector function that converts a timetable with column 
%`Time` and `glucose` containing the glucose data, in a double
%vector containing the glucose data in the `glucose` column. 
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data (in mg/dl). 
%Output:
%   - dataVector: a vector of double containing the glucose data
%   in the `glucose` column.
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
        error('timetableToGlucoseVector: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timetableToGlucoseVector: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timetableToGlucoseVector: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timetableToGlucoseVector: data must have a column named `glucose`.')
    end
    
    %Conversion
    dataVector = data.glucose;
    
end

