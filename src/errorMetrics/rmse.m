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
%   - Wikipedia on RMSE: https://en.wikipedia.org/wiki/Root-mean-square_deviation. 
%   (Accessed: 2020-12-10)
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
        error('rmse: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('rmse: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('rmse: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('rmse: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('rmse: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('rmse: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('rmse: data and dataHat must have the same length.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('rmse: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('rmse: data must have a column named `glucose`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'Time')))
        error('rmse: dataHat must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'glucose')))
        error('rmse: dataHat must have a column named `glucose`.')
    end
    
    %Get indices having no nans in both timetables
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
   
    %Compute metric
    rmse = sqrt(mean((data.glucose(idx) - dataHat.glucose(idx)).^2));
    
end