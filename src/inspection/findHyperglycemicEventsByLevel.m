function hyperglycemicEvents = findHyperglycemicEventsByLevel(data,varargin)
%findHyperglycemicEventsByLevel function that finds the hyperglycemic events in a 
%given glucose trace classifying them by level, i.e., hyper, level 1 hyper or level 2 hyper.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%   - hyperglycemicEvents: a structure containing the information on the
%   hyperglycemic events found by the function with fields:
%       - hyper: a structure containing the information on the hyper events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           hyperglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           hyperglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           hyperglycemic event;
%           - meanDuration: metric, the average duration of the events;
%           - numberPerWeek: metric, the number of events per week.
%       - l1: a structure containing the information on the L1 hyper events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           L1 hyperglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           L1 hyperglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           L1 hyperglycemic event;
%           - meanDuration: metric, the average duration of the events;
%           - numberPerWeek: metric, the number of events per week.
%       - l2: a structure containing the information on the L2 hyper events
%       with fields:
%           - timeStart: a vector containing the starting timestamps of each found 
%           L2 hyperglycemic event;
%           - timeEnd: a vector containing the ending timestamps of each found 
%           L2 hyperglycemic event;
%           - duration: a vector containing the duration (in min) of each found 
%           L2 hyperglycemic event;
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
%   Diabetes & Endocrinology, 2022, pp. 1-16.
%   DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
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
        thL1 = 180;
        thL2 = 250;
    else
        if(strcmp(glycemicTarget,'pregnancy'))
            thL1 = 140;
            thL2 = 250;
        end
    end

    %Get all hypoglycemic events
    allHyperEvents = findHyperglycemicEvents(data,'th',thL1);
    
    %Get L2 hypoglycemic events
    l2HyperEvents = findHyperglycemicEvents(data,'th',thL2);
    
    flagL1Events = true(length(allHyperEvents.timeStart),1);
    
    for h = 1:length(l2HyperEvents.timeStart)
        distances = allHyperEvents.timeStart - l2HyperEvents.timeStart(h);
        flagL1Events(find(distances < 0, 1, 'last')) = false;
    end
    
    hyperglycemicEvents.hyper = allHyperEvents;
    hyperglycemicEvents.l1.timeStart = allHyperEvents.timeStart(flagL1Events);
    hyperglycemicEvents.l1.timeEnd = allHyperEvents.timeEnd(flagL1Events);
    hyperglycemicEvents.l1.duration = allHyperEvents.duration(flagL1Events);
    hyperglycemicEvents.l1.meanDuration = mean(hyperglycemicEvents.l1.duration);
    nDays = days(data.Time(end) - data.Time(1)); 
    hyperglycemicEvents.l1.eventsPerWeek = length(hyperglycemicEvents.l1.timeStart)/nDays*7;
    hyperglycemicEvents.l2 = l2HyperEvents;
    
end
















