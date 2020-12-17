function hbgi = hbgi(data)
%hbgi function that computes the high blood glucose index (HBGI) of the
%glucose concentration (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - hbgi: the high blood glucose index of the glucose concentration.
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
        error('hbgi: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('hbgi: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('hbgi: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('hbgi: data must have a column named `glucose`.')
    end
    
    
    %Get rid of nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Setup the formula parameters
    alpha = 1.084;
    beta = 5.381;
    gamma = 1.509;
    th = 112.5;
    
    %Symmetrization
    f = gamma * ( log(nonNanGlucose).^alpha - beta );
    
    %Risk computation
    rh = 10 * f.^2;
    rh(nonNanGlucose < th) = 0;
    
    %Compute metric
    hbgi = mean(rh);

end

