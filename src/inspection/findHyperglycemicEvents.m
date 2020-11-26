function hyperglycemicEvents = findHyperglycemicEvents(data)
%findHyperglycemicEvents function that finds the hyperglycemic events in a 
%given glucose trace. The definition of hyperglycemic event can be found 
%in Danne et al.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl).
%Output:
%   - hyperglycemicEvents: a structure containing the information on the
%   hyperglycemic events found by the function with fields:
%       - time: a vector containing the starting timestamps of each found 
%       hyperglycemic event;
%       - duration: a vector containing the duration of each found 
%       hyperglycemic event;
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Danne et al., "International consensus on use of continuous glucose
%   monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: 
%   10.2337/dc17-1600.
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
        error('findHyperglycemicEvents: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('findHyperglycemicEvents: data must have a homogeneous time grid.')
    end
    
    
    k = 1; %hyperglycemicEvent vector current index
    nSamples = round(15/minutes(data.Time(2) - data.Time(1))); %number of consecutive samples required to define a valid event
    TH = 180; %set the hyperglycemic threshold 
    
    count = 0; %number of current found consecutive samples
    tempStartTime = []; %preallocate the hyper event starting time;
    hyperglycemicEvents.time = datetime(); %preallocate the result structure;
    hyperglycemicEvents.duration = []; %preallocate the result structure;
    
    flag = 0; %state flag -> 0: no event, 1: found a valid hyper event and 
              %currently in hyper, -1: found a valid hyper event and
              %currently not in hyper.
    
    for t = 1:height(data)
        
        if( data.glucose(t) > TH )
            
            %If it is a new event, reset count and set the hypothetical
            %starting time to the current timestamp
            if(count <= 0 )
                count = 0;
                tempStartTime = data.Time(t);
            end
            
            count = min([nSamples count + 1]); %limit count to nSamples
            
            %if count touches the "nSamples sample goal" we found a new event
            if(count == nSamples || flag == -1)
                flag = 1;
            end
            
        else
            
            
            if(flag == 0 && count > 0) 
                count = 0;
            end
            
            if(flag == 1)
                count = nSamples;
                flag = -1;
            end
            %count down
            
            count = count - 1;
            
        end
                
        if(count == 0 && flag == -1)
            hyperglycemicEvents.time(k) = tempStartTime;
            hyperglycemicEvents.duration(k) = minutes(data.Time(t-(nSamples-1)) - tempStartTime);
            k = k + 1;
            flag = 0;
        end

    end
    
    if(k == 1)
        hyperglycemicEvents.time = [];
    end
    
end
















