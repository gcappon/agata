function igc = igc(data)
%igc function that computes the index of glycemic control (IGC) by Rodbard 
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - igc: the index of glycemic control.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%  - Rodbard et al., "Interpretation of continuous glucose monitoring
%  data: glycemic variability and quality of glycemic control", Diabetes 
%  Technology & Therapeutics, 2009, vol. 11, pp. S55-S67. DOI: 10.1089/dia.2008.0132.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('igc: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('igc: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('igc: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('igc: data must have a column named `glucose`.')
    end
    
    %Compute metric
    igc = hypoIndex(data) + hyperIndex(data);

end