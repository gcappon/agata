function mard = mard(data,dataHat)
%mard function that computes the mean absolute relative difference (MARD) 
%between two glucose traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - mard: the computed mean absolute relative difference (%).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    mard = 100 * mean(abs( data.glucose(idx) - dataHat.glucose(idx) ) ./ data.glucose(idx) );
    
end