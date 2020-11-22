function mad = mad(data,dataHat)
%mad function that computes the mean absolute difference (MAD) 
%between two glucose traces.
%
%Inputs:
%   - data: a timeseries containing the reference (true) glucose data (in 
%   mg/dl); 
%   - dataHat: a timeseries containing the inferred glucose data (in 
%   mg/dl) to compare with data.
%Output:
%   - mad: the computed mean absolute difference (mg/dl).
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));

    mad = mean( abs( data.glucose(idx) - dataHat.glucose(idx) ) );
    
end