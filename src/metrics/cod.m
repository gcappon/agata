function cod = cod(data,dataHat)
%cod function that computes the coefficient of determination (COD) between 
%two glucose traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - cod: the computed coefficient of determination (%).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    residuals = data.glucose(idx) - dataHat.glucose(idx);
    
    cod = 100 * ( 1 - norm(residuals,2)^2 ./ norm( data.glucose(idx) - mean(data.glucose(idx)), 2)^2 );
    
end