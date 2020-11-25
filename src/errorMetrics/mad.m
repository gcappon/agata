function mad = mad(data,dataHat)
%mad function that computes the mean absolute difference (MAD) 
%between two glucose traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - mad: the computed mean absolute difference (mg/dl).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - dataHat must be a timetable having an homogeneous time grid;
%   - data and dataHat must start from the same timestamp;
%   - data and dataHat must end with the same timestamp;
%   - data and dataHat must have the same length.
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
        error('mad: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('mad: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('mad: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('mad: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('mad: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('mad: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('mad: data and dataHat must have the same length.')
    end
    
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));

    mad = mean( abs( data.glucose(idx) - dataHat.glucose(idx) ) );
    
end