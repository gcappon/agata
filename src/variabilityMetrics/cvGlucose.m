function cvGlucose = cvGlucose(data)
%cvGlucose function that computes the coefficient of variation of the glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - cvGlucose: coefficient of variation of the glucose concentration.
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
        error('cvGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('cvGlucose: data must have a homogeneous time grid.')
    end
    
    
    cvGlucose = 100 * stdGlucose(data) / meanGlucose(data);

end

