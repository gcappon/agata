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
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('meanGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('meanGlucose: data must have a homogeneous time grid.')
    end
    
    %Remove nan values from calculation
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute mean
    meanGlucose = mean(nonNanGlucose);
    
end

