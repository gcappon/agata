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
%Preconditions:
%   - data and dataHat must be a timetable having an homogeneous time grid;
%   - data and dataHat must contain a column named `Time` and another named `glucose`;
%   - data and dataHat must start from the same timestamp;
%   - data and dataHat must end with the same timestamp;
%   - data and dataHat must have the same length.
%
% ------------------------------------------------------------------------
% 
% Reference:
%   - Gini, "Measurement of Inequality and Incomes", The Economic Journal, 
%   vol. 31, 1921, pp. 124–126. DOI:10.2307/2223319.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('mard: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('mard: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('mard: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('mard: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('mard: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('mard: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('mard: data and dataHat must have the same length.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('mard: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('mard: data must have a column named `glucose`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'Time')))
        error('mard: dataHat must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'glucose')))
        error('mard: dataHat must have a column named `glucose`.')
    end
    
    %Get indices having no nans in both timetables
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    %Compute metric
    mard = 100 * mean(abs( data.glucose(idx) - dataHat.glucose(idx) ) ./ data.glucose(idx) );
    
end