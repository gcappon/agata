function numberDaysOfObservation = numberDaysOfObservation(data)
%numberDaysOfObservation function that computes the number of days of 
%observation of the given glucose trace.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - numberDaysOfObservation: number of days of observation.
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
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('numberDaysOfObservation: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('numberDaysOfObservation: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('numberDaysOfObservation: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('numberDaysOfObservation: data must have a column named `glucose`.')
    end
    
    %Compute index
    numberDaysOfObservation = days(data.Time(end) - data.Time(1));
    
end

