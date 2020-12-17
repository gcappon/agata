function dataTimetable = glucoseTimeVectorsToTimetable(glucose, time)
%glucoseTimeVectorsToTimetable function that converts the two given vectors
%containing the glucose samples and the corresponding timestamps, 
%respectively, in a timetable.
%
%Inputs:
%   - glucose: a vector of double containing the glucose data (in mg/dl); 
%   - time: a vector of datetime containing the timestamps of each `glucose`
%   datapoint.
%Output:
%   - dataTimetable: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%
%Preconditions:
%   - `data` and `time` must be of the same length;
%   - `glucose` must be a vector of double;
%   - `time` must be a a vector of datetime.
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
    if(~isnumeric(glucose))
        error('glucoseTimeVectorsToTimetable: glucose must be a vector of double.');
    end
    if(~isdatetime(time))
        error('glucoseTimeVectorsToTimetable: time must be a vector of datetime.');
    end
    if(length(glucose)~=length(time))
        error('glucoseTimeVectorsToTimetable: glucose and time must be of the same length.');
    end
    
    %Conversion
    dataTimetable = timetable(glucose(:),'VariableNames', {'glucose'}, 'RowTimes', time);
    
end

