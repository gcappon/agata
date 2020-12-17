function cod = cod(data,dataHat)
%cod function that computes the coefficient of determination (COD) between 
%two glucose traces.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - dataHat: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - cod: the computed coefficient of determination (%).
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
%   - Wright, "Correlation and causation", Journal of Agricultural Research, vol. 20, 1921, pp. 557–585.
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
        error('cod: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('cod: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('cod: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('cod: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('cod: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('cod: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('cod: data and dataHat must have the same length.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('cod: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('cod: data must have a column named `glucose`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'Time')))
        error('cod: dataHat must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'glucose')))
        error('cod: dataHat must have a column named `glucose`.')
    end
    
    %Get indices having no nans in both timetables
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    %Compute residuals
    residuals = data.glucose(idx) - dataHat.glucose(idx);
    
    %Compute metric
    cod = 100 * ( 1 - norm(residuals,2)^2 ./ norm( data.glucose(idx) - mean(data.glucose(idx)), 2)^2 );
    
end