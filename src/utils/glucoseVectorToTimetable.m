function dataTimetable = glucoseVectorToTimetable(data, sampleTime, startTime)
%glucoseVectorToTimetable function that transform a vector containing
%glucose samples sampled on an homogeneous timegrid with, timestep
%`sampleTime`, in a timetable. The resulting timetable timestamps will 
%start from `startTime`. If startTime is not specified, 2000-01-01 00:00 is
%used as default.
%
%Input:
%   - data: a vector of doubled containing the glucose data (in mg/dl) 
%   supposed to be sampled in a homogeneous timegrid with timestep 
%   `sampleTime`; 
%   - sampleTime: an integer defining the sampleTime of data (in min);
%   - startTime: a dateTime defining the first timestamp of the resulting
%   timetable. If startTime is not provided, 2000-01-01 00:00, is used as
%   default.
%Output:
%   - dataTimetable: `data` transformed in timeTable having two columns: 
%   `Time`, which contains the timestamps, and `glucose` containing the 
%   glucose data (in mg/dl). 
%
%Preconditions:
%   - `data` must be a vector of double supposed to be sampled in a 
%   homogeneous timegrid with timestep `sampleTime`; 
%   - `sampleTime` must be an integer;
%   - `startTime` must be a datetime.
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
    if(~isnumeric(data))
        error('glucoseVectorToTimetable: data must be a vector of double.');
    end
    if( ~( isnumeric(sampleTime) && ((sampleTime - round(sampleTime)) == 0) ) )
        error('glucoseVectorToTimetable: sampleTime must be an integer.')
    end

    if(nargin == 2)
        startTime = datetime(2000,1,1,0,0,0);
    end
    
    if(~isdatetime(startTime))
        error('glucoseVectorToTimetable: startTime must be a datetime.');
    end
    
    time = startTime:minutes(sampleTime):(startTime + minutes(length(data)*sampleTime - sampleTime));
    dataTimetable = timetable(data(:),'VariableNames', {'glucose'}, 'RowTimes', time);
    
end

