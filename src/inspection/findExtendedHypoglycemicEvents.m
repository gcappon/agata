function extendedHypoglycemicEvents = findExtendedHypoglycemicEvents(data, varargin)
%findExtendedHypoglycemicEvents function that finds the extended 
%hypoglycemic events in a given glucose trace. The definition of extended
%hypoglycemic event can be found in Battellino et al. (event begins: at least consecutive 120 minutes < threshold mg/dl, 
%event ends: at least 15 consecutive minutes > threshold mg/dl)
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%   - extendedHypoglycemicEvents: a structure containing the information on the
%   extended hypoglycemic events found by the function with fields:
%       - timeStart: a vector containing the starting timestamps of each found 
%       extended hypoglycemic event;
%       - timeEnd: a vector containing the ending timestamps of each found 
%       extended hypoglycemic event;
%       - duration: a vector containing the duration (in min) of each found 
%       extended hypoglycemic event;
%       - meanDuration: metric, the average duration of the events;
%       - numberPerWeek: metric, the number of events per week.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`;
%   - `GlycemicTarget` can be `pregnancy` or `diabetes`.
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
        error('findExtendedHypoglycemicEvents: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('findExtendedHypoglycemicEvents: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('findExtendedHypoglycemicEvents: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('findExtendedHypoglycemicEvents: data must have a column named `glucose`.')
    end
    
    %Input parser and check preconditions
    defaultGlycemicTarget = 'diabetes';
    expectedGlycemicTarget = {'diabetes','pregnancy'};
    
    params = inputParser;
    params.CaseSensitive = false;
    
    addRequired(params,'data',@(x) true); %already checked
    addOptional(params,'GlycemicTarget',defaultGlycemicTarget, @(x) any(validatestring(x,expectedGlycemicTarget)));

    parse(params,data,varargin{:});
    
    %Initialization
    glycemicTarget = params.Results.GlycemicTarget;
    
    if(strcmp(glycemicTarget,'diabetes'))
        th = 70;
    else
        if(strcmp(glycemicTarget,'pregnancy'))
            th = 63;
        end
    end
    
    k = 1; %prolongedHypoglycemicEvents vector current index
    nSamplesIn = round(120/minutes(data.Time(2) - data.Time(1))); %number of consecutive samples required to define a valid event
    nSamplesOut = round(15/minutes(data.Time(2) - data.Time(1))); %number of consecutive samples required to end a valid event
    
    count = 0; %number of current found consecutive samples
    tempStartTime = []; %preallocate the prolonged hypo event starting time;
    extendedHypoglycemicEvents.time = datetime(); %preallocate the result structure;
    extendedHypoglycemicEvents.duration = []; %preallocate the result structure;
    
    flag = 0; %state flag -> 0: no event, 1: found a valid prolonged hypo event and 
              %currently in prolonged hypo, -1: found a valid prolonged hypo event and
              %currently not in prolonged hypo.
    
    for t = 1:height(data)
        
        if( data.glucose(t) < th )
            
            %If it is a new event, reset count and set the hypothetical
            %starting time to the current timestamp
            if(count <= 0 )
                count = 0;
                tempStartTime = data.Time(t);
            end
            
            count = min([nSamplesIn count + 1]); %limit count to nSamples
            
            %if count touches the "nSamples sample goal" we found a new event
            if(count == nSamplesIn || flag == -1)
                flag = 1;
            end
            
        else
            
            if(flag == 0 && count > 0) 
                count = 0;
            end
            
            if(flag == 1)
                count = nSamplesOut;
                flag = -1;
            end
            %count down
            
            count = count - 1;
            
        end
                
        if(count == 0 && flag == -1)
            extendedHypoglycemicEvents.time(k) = tempStartTime;
            extendedHypoglycemicEvents.duration(k) = minutes(data.Time(t-(nSamplesOut-1)) - tempStartTime);
            k = k + 1;
            flag = 0;
        end

    end
    
    if(k == 1)
        extendedHypoglycemicEvents.time = [];
    end
    
    extendedHypoglycemicEvents.timeStart = extendedHypoglycemicEvents.time;
    extendedHypoglycemicEvents = rmfield(extendedHypoglycemicEvents,"time");
    extendedHypoglycemicEvents.timeEnd = extendedHypoglycemicEvents.timeStart + minutes(extendedHypoglycemicEvents.duration);
    extendedHypoglycemicEvents.meanDuration = mean(extendedHypoglycemicEvents.duration);
    nDays = days(data.Time(end) - data.Time(1)); 
    extendedHypoglycemicEvents.eventsPerWeek = length(extendedHypoglycemicEvents.timeStart)/nDays*7;
    
    
end
















