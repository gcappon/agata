function sddmIndex = sddmIndex(data)
%sddmIndex function that computes the standard deviation of within-day
%means index (SDDM) (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - sddmIndex: the standard deviation of within-day means index (SDDM) index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
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
        error('sddmIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('sddmIndex: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('sddmIndex: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('sddmIndex: data must have a column named `glucose`.')
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
    lastDay = lastDay + days(1);

    nDays = days(lastDay-firstDay);
        
    meanWithin = zeros(nDays, 1);
    
    for d = 1:nDays

        %Get the day of data
        dayData = data((data.Time >= firstDay + days(d-1)) & data.Time < (firstDay + days(d)),:);

        %Get daily mean and std
        meanWithin(d) = nanmean(dayData.glucose);
        
    end
    
    %Compute index
    sddmIndex = nanstd(meanWithin);
    
end

