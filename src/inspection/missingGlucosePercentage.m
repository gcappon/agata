function missingGlucosePercentage = missingGlucosePercentage(data)
%missingGlucosePercentage function that computes the percentage of missing 
%values in the given glucose trace.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - missingGlucosePercentage: percentage of missing glucsoe values.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - None.
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
        error('missingGlucosePercentage: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('missingGlucosePercentage: data must have a homogeneous time grid.')
    end
    
        
    missingGlucosePercentage = 100*sum(isnan(data.glucose))/height(data);
    
end

