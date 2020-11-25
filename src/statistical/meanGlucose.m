function meanGlucose = meanGlucose(data)
%meanGlucose function that computes the mean glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - meanGlucose: mean glucose concentration.
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
    if(var(seconds(diff(data.Time))) > 0)
        error('meanGlucose: data must have a homogeneous time grid.')
    end
    
    %Remove nan values from calculation
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute mean
    meanGlucose = mean(nonNanGlucose);
    
end

