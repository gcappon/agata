function jIndex = jIndex(data)
%jIndex function that computes the jIndex of the glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - jIndex: jIndex of the glucose concentration.
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
        error('jIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('jIndex: data must have a homogeneous time grid.')
    end
    
    
    jIndex = 1e-3 * (meanGlucose(data) + stdGlucose(data)) ^ 2;
    
end

