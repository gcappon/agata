function iqrGlucose = iqrGlucose(data)
%iqrGlucose function that computes the interquartile range of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - iqrGlucose: interquartile range of glucose concentration.
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
        error('iqrGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('iqrGlucose: data must have a homogeneous time grid.')
    end
    
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    iqrGlucose = iqr(nonNanGlucose);
    
end

