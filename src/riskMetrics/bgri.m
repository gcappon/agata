function bgri = bgri(data)
%bgri function that computes the blood glucose risk index (BGRI) of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - bgri: the blood glucose risk index of the glucose concentration.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    bgri = lbgi(data) + hbgi(data);

end

