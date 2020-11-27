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
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - None
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
        error('timetableToGlucoseVector: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('timetableToGlucoseVector: data must have a homogeneous time grid.')
    end
    
    dataVector = data.glucose;
    
end

