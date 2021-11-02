function data = toMGDL(data)
%toMGDL function that converts a timetable with column 
%`Time` and `glucose` containing the timestamps and the respective glucose 
%data in mmol/L to mg/dL. 
%
%
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mmol/L). 
%Outputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dL). 
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
        error('toMGDL: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('toMGDL: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('toMGDL: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('toMGDL: data must have a column named `glucose`.')
    end
    
    %Conversion
    data.glucose = data.glucose*18.018;
    
end

