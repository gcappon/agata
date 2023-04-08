function hypoglycemicEvents = findHypoglycemicEventsByLevel(data,varargin)
%findHypoglycemicEventsByLevel function that finds the hypoglycemic events in a 
%given glucose trace classifying them by level, i.e., hypo, level 1 hypo or level 2 hypo.
%The definition of hypoglycemic event can be found in Battellino et al.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%   - hypoglycemicEvents: a structure containing the information on the
%   hypoglycemic events found by the function with fields:
%       - hypo: a structure containing the information on the hypo events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           hypoglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           hypoglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           hypoglycemic event;
%           - meanDuration: metric, the average duration of the events;
%           - numberPerWeek: metric, the number of events per week.
%       - l1: a structure containing the information on the L1 hypo events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           L1 hypoglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           L1 hypoglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           L1 hypoglycemic event;
%           - meanDuration: metric, the average duration of the events;
%           - numberPerWeek: metric, the number of events per week.
%       - l2: a structure containing the information on the L2 hypo events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           L2 hypoglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           L2 hypoglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           L2 hypoglycemic event;
%           - meanDuration: metric, the average duration of the events;
%           - numberPerWeek: metric, the number of events per week.
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
%   Diabetes & Endocrinology, 2022, pp. 1-16. DOI: 
%   https://doi.org/10.1016/S2213-8587(22)00319-9.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2023 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('findHypoglycemicEventsByLevel: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('findHypoglycemicEventsByLevel: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('findHypoglycemicEventsByLevel: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('findHypoglycemicEventsByLevel: data must have a column named `glucose`.')
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
        thL1 = 70;
        thL2 = 54;
    else
        if(strcmp(glycemicTarget,'pregnancy'))
            thL1 = 63;
            thL2 = 54;
        end
    end
    
    %Get all hypoglycemic events
    allHypoEvents = findHypoglycemicEvents(data,'th',thL1);
    
    %Get L2 hypoglycemic events
    l2HypoEvents = findHypoglycemicEvents(data,'th',thL2);
    
    flagL1Events = true(length(allHypoEvents.timeStart),1);
    
    for h = 1:length(l2HypoEvents.timeStart)
        distances = allHypoEvents.timeStart - l2HypoEvents.timeStart(h);
        flagL1Events(find(distances < 0, 1, 'last')) = false;
    end
    
    hypoglycemicEvents.hypo = allHypoEvents;
    hypoglycemicEvents.l1.timeStart = allHypoEvents.timeStart(flagL1Events);
    hypoglycemicEvents.l1.timeEnd = allHypoEvents.timeEnd(flagL1Events);
    hypoglycemicEvents.l1.duration = allHypoEvents.duration(flagL1Events);
    hypoglycemicEvents.l1.meanDuration = mean(hypoglycemicEvents.l1.duration);
    nDays = days(data.Time(end) - data.Time(1)); 
    hypoglycemicEvents.l1.eventsPerWeek = length(hypoglycemicEvents.l1.timeStart)/nDays*7;
    hypoglycemicEvents.l2 = l2HypoEvents;
    
end
















