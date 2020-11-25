function rangeGlucose = rangeGlucose(data)
%rangeGlucose function that computes the range spanned by the glucose
%concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - rangeGlucose: range spanned by the glucose concentration.
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
        error('rangeGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('rangeGlucose: data must have a homogeneous time grid.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    rangeGlucose = max(nonNanGlucose) - min(nonNanGlucose);
    
end

