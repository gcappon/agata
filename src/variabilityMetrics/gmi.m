function gmi = gmi(data)
%gmi function that computes the glucose management indicator (GMI) of the
%given data (ignores nan values). Generates a warning if the given `data`
%spans less than 12 days.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - gmi: glucose management indicator if the given data (%).
%
%Preconditions:
%   - `data` must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Bergenstal et al., "Glucose Management Indicator (GMI): A new term 
%   for estimating A1C from continuous glucose monitoring", Diabetes Care, 
%   2018, vol. 41, pp. 2275-2280. DOI: 10.2337/dc18-1581.
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
        error('gmi: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('gmi: data must have a homogeneous time grid.')
    end
    
    %Generate a warning if you are trying to compute the gmi over less than
    %12 days
    if(days(data.Time(end)-data.Time(1)) < 12)
        warning('gmi: you are computing the GMI on less than 12 days of data. Results might be inaccurate.');
    end
    
    gmi = 3.31 + 0.02392 * meanGlucose(data);

end