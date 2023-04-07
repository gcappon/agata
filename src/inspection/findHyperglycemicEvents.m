function hyperglycemicEvents = findHyperglycemicEvents(data, varargin)
%findHyperglycemicEvents function that finds the hyperglycemic events in a 
%given glucose trace. The definition of hyperglycemic event can be found 
%in Battellino et al. (event begins: at least consecutive 15 minutes > threshold mg/dl, 
%event ends: at least 15 consecutive minutes < threshold mg/dl)
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl).
%   - th: an integer with the selected hyperglycemia threshold (in mg/dl)
%   the default value is 180 mg/dl.
%Output:
%   - hyperglycemicEvents: a structure containing the information on the
%   hyperglycemic events found by the function with fields:
%       - timeStart: a vector containing the starting timestamps of each found 
%       hyperglycemic event;
%       - timeEnd: a vector containing the ending timestamps of each found 
%       hyperglycemic event;
%       - duration: a vector containing the duration (in min) of each found 
%       hyperglycemic event;
%       - meanDuration: metric, the average duration of the events;
%       - numberPerWeek: metric, the number of events per week.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Battelino et al., "Continuous glucose monitoring and merics for 
%   clinical trials: An international consensus statement", The Lancet
%   Diabetes & Endocrinology, 2022, pp. 1-16.
%   DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
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
        error('findHyperglycemicEvents: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('findHyperglycemicEvents: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('findHyperglycemicEvents: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('findHyperglycemicEvents: data must have a column named `glucose`.')
    end
    
    defaultThreshold = 180;
    params = inputParser;
    params.CaseSensitive = false;
    addOptional(params,'th',defaultThreshold,@(x) x > 30 && x < 1000);
    parse(params,varargin{:});

    th = params.Results.th;
    
    
    k = 1; %hyperglycemicEvent vector current index
    sampleTime = minutes(data.Time(2) - data.Time(1));
    nSamples = round(15/sampleTime); %number of consecutive samples required to define a valid event
    
    count = 0; %number of current found consecutive samples
    tempStartTime = []; %preallocate the hyper event starting time;
    hyperglycemicEvents.time = datetime(); %preallocate the result structure;
    hyperglycemicEvents.duration = []; %preallocate the result structure;
    
    flag = 0; %state flag -> 0: no event, 1: found a valid hyper event and 
              %currently in hyper, -1: found a valid hyper event and
              %currently not in hyper.
    
    for t = 1:height(data)
        
        if( data.glucose(t) > th )
            
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
    
    
    %Manage the case in which the hyperglycemic event has been found (at
    %least nSamples > th) but the 'post hyperglycemic window' has not finshed
    %yet.
    if((count > 0 && flag == -1))
        hyperglycemicEvents.time(k) = tempStartTime;
        hyperglycemicEvents.duration(k) = minutes(data.Time(t-(nSamples-count-1)) - tempStartTime);
        k = k +  1;
    end
    if((count == nSamples && flag == 1))
        hyperglycemicEvents.time(k) = tempStartTime;
        hyperglycemicEvents.duration(k) = minutes(data.Time(t) - tempStartTime) + sampleTime;
        k = k +  1;
    end
    
    %If no events have been found...
    if(k == 1 )
        hyperglycemicEvents.time = [];
        hyperglycemicEvents.duration = [];
    end
    
    hyperglycemicEvents.timeStart = hyperglycemicEvents.time;
    hyperglycemicEvents = rmfield(hyperglycemicEvents,"time");
    hyperglycemicEvents.timeEnd = hyperglycemicEvents.timeStart + minutes(hyperglycemicEvents.duration);
    hyperglycemicEvents.meanDuration = mean(hyperglycemicEvents.duration);
    nDays = days(data.Time(end) - data.Time(1)); 
    hyperglycemicEvents.eventsPerWeek = length(hyperglycemicEvents.timeStart)/nDays*7;
    
end
















