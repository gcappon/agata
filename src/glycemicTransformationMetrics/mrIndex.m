function mrIndex = mrIndex(data,r)
%mrIndex function that computes the mr value by Schlichtkrull (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - r: an optional integer that is a parameter for mr value calculation. If r is 
%   not provided, r = 100, is used as default.
%Output:
%   - mrIndex: the mr value.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - r must be an integer.
%
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - Schlichtkrull et al., "The M-value, an index of blood-sugar control in 
%  diabetics", Acta Medica Scandinavica, 1965, vol. 177, pp. 95-102. 
%  DOI: 10.1111/j.0954-6820.1965.tb01810.x.
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
        error('mrIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('mrIndex: data must have a homogeneous time grid.')
    end
    
    if(nargin == 1)
        r = 100;
    end
    
    if( ~( isnumeric(r) && ((r - round(r)) == 0) ) )
        error('mrIndex: r must be an integer.')
    end
    
    %Get rid of nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    transData = 1000 * abs(log10(nonNanGlucose/r)).^3;
    mrIndex = mean(transData);

end

