function data = toMMOLL(data)
%toMMOLL function that converts a timetable with column 
%`Time` and `glucose` containing the timestamps and the respective glucose 
%data in mg/dL to mmol/L. 
%
%
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dL). 
%Outputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mmol/L). 
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - None
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('toMMOLL: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('toMMOLL: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('toMMOLL: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('toMMOLL: data must have a column named `glucose`.')
    end
    
    %Conversion
    data.glucose = data.glucose/18.018;
    
end

