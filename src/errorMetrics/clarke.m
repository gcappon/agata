function results = clarke(data,dataHat)
% clarke function that performs Clarke Error Grid Analysis (CEGA) (ignores nan values).
%
% Inputs: 
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
% Output: 
%   - results: a structure containing the results of the CEGA with fields:
%       - A: the percentage of time spent in Zone A;
%       - B: the percentage of time spent in Zone B;
%       - C: the percentage of time spent in Zone C;
%       - D: the percentage of time spent in Zone D;
%       - E: the percentage of time spent in Zone E.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    % Error checking
    if nargin == 0
     error('clarke:Inputs','There are no inputs.')
    end
    
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    y = data.glucose(idx);
    yp = dataHat.glucose(idx);
    
    if length(yp) ~= length(y)
        error('clarke:Inputs','Vectors y and yp must be the same length.')
    end
    if (max(y) > 400) || (max(yp) > 400) || (min(y) < 0) || (min(yp) < 0)
        warning('clarke:Inputs','Vectors y and yp are not in the physiological range of glucose (<400mg/dl).')
    end
    
    n = length(y);
    total = zeros(5,1);                        

    for i=1:n
        if (yp(i) <= 70 && y(i) <= 70) || (yp(i) <= 1.2*y(i) && yp(i) >= 0.8*y(i))
            total(1) = total(1) + 1;            % Zone A
        else
            if ( (y(i) >= 180) && (yp(i) <= 70) ) || ( (y(i) <= 70) && yp(i) >= 180 )
                total(5) = total(5) + 1;        % Zone E
            else
                if ((y(i) >= 70 && y(i) <= 290) && (yp(i) >= y(i) + 110) ) || ((y(i) >= 130 && y(i) <= 180)&& (yp(i) <= (7/5)*y(i) - 182))
                    total(3) = total(3) + 1;    % Zone C
                else
                    if ((y(i) >= 240) && ((yp(i) >= 70) && (yp(i) <= 180))) || (y(i) <= 175/3 && (yp(i) <= 180) && (yp(i) >= 70)) || ((y(i) >= 175/3 && y(i) <= 70) && (yp(i) >= (6/5)*y(i)))
                        total(4) = total(4) + 1;% Zone D
                    else
                        total(2) = total(2) + 1;% Zone B
                    end                     
                end                            
            end                                 
        end                                    
    end                                         
    percentage = (total/n)*100;

    results.A = percentage(1);
    results.B = percentage(2);
    results.C = percentage(3);
    results.D = percentage(4);
    results.E = percentage(5);

end