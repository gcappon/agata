function sdwIndex = sdwIndex(data)
%stdWIndex function that computes the mean of within-day standard deviation
%index (SDW) (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - stdWIndex: the mean of within-day standard deviation (SDW) index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Rodbard et al., "New and improved methods to characterize glycemic 
%   variability using continuous glucose monitoring", Diabetes Technology &
%   Therapeutics, 2009, vol. 11, pp. 551-565. DOI: 10.1089/dia.2009.0015.
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
        error('sdwIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('sdwIndex: data must have a homogeneous time grid.')
    end
    
    %Compute the number of days in a safe way (but long) way
    firstDay = data.Time(1);
    firstDay.Hour = 0;
    firstDay.Minute = 0;
    firstDay.Second = 0;

    lastDay = data.Time(end);
    lastDay.Hour = 0;
    lastDay.Minute = 0;
    lastDay.Second = 0;
    lastDay = lastDay + day(1);

    nDays = days(lastDay-firstDay);
        
    sdWithin = zeros(nDays, 1);
    for d = 1:nDays

        %Get the day of data
        dayData = data((data.Time >= firstDay + day(d-1)) & data.Time < (firstDay + day(d)),:);

        %Get daily std
        sdWithin(d) = nanstd(dayData.glucose);
        
    end
    
    %Compute index
    sdwIndex = nanmean(sdWithin);
    
end

