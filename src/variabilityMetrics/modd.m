function modd = modd(data)
%modd function that computes the mean of daily difference (MODD) index.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - modd: the mean of daily difference (MODD) index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Molnar et al., "Day-to-day variation of continuously monitored 
%   glycaemia: a further measure of diabetic instability", Diabetologia,
%   1972, vol. 8, pp. 342–348. DOI: 10.1007/BF01218495.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('modd: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('modd: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('modd: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('modd: data must have a column named `glucose`.')
    end
    
    %Build vectors
    yesterday = minutes(1440);
    
    n = height(data);
    
    Dm = [];

    for i = 2:n

        % Find the index referring to the same time yesterday
        j = find(data.Time <= (data.Time(i) - yesterday), 1, 'last');

        if ~isempty(j) % if there is a meaningful sample in cgmv(j)
            Dm = [Dm 
                  abs(data.glucose(i) - data.glucose(j))];
        end

    end

    if ~isempty(Dm)
        modd = nanmean(Dm);
    else
        modd = nan;
    end

end

