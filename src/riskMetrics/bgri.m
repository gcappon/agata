function bgri = bgri(data)
%adrr function that computes the blood glucose risk index (BGRI) of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - bgri: the blood glucose risk index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Kovatchev et al., "Symmetrization of the blood glucose measurement scale and
%   its applications", Diabetes Care, 1997, vol. 20, pp. 1655-1658. DOI: 10.2337/diacare.20.11.1655.
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
        error('bgri: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('bgri: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('bgri: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('bgri: data must have a column named `glucose`.')
    end
        
    %Compute metric
    bgri = lbgi(data) + hbgi(data);

end

