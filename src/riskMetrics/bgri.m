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
%   - `data` must be a timetable having an homogeneous time grid.
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
        error('bgri: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('bgri: data must have a homogeneous time grid.')
    end
        
    bgri = lbgi(data) + hbgi(data);

end

