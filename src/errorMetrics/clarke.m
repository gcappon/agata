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
%   -  Clarke et al., "Evaluating clinical accuracy of systems for self-monitoring 
%   of blood glucose", Diabetes Care, 1987, vol. 10, pp. 622–628. DOI: 10.2337/diacare.10.5.622.
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
        error('clarke: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('clarke: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('clarke: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('clarke: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('clarke: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('clarke: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('clarke: data and dataHat must have the same length.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('clarke: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('clarke: data must have a column named `glucose`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'Time')))
        error('clarke: dataHat must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'glucose')))
        error('clarke: dataHat must have a column named `glucose`.')
    end
    
    %Get indices having no nans in both timetables
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    y = data.glucose(idx);
    yp = dataHat.glucose(idx);
    
    n = length(y);
    total = zeros(5,1);                        
    
    %Assign points to zones
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

    %Compute metrics
    results.A = percentage(1);
    results.B = percentage(2);
    results.C = percentage(3);
    results.D = percentage(4);
    results.E = percentage(5);

end