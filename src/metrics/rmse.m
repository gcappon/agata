function rmse = rmse(data,dataHat)
%rmse function that computes the root mean squared error (RMSE) between two
%glucose traces (ignores nan values).
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - rmse: the computed root mean squared error (mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    rmse = sqrt(mean((data.glucose(idx) - dataHat.glucose(idx)).^2));
    
end