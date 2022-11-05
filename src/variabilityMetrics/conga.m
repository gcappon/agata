function conga = conga(data)
%conga function that computes the Continuous Overall Net Glycemic Action
%(CONGA) index.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - conga: the Continuous Overall Net Glycemic Action
%   (CONGA) index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - McDonnell et al., "A novel approach to continuous glucose analysis 
%   utilizing glycemic variation. Diabetes Technol Ther, 2005, vol. 7,
%   pp. 253–263. DOI: 10.1089/dia.2005.7.253.
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
        error('conga: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('conga: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('conga: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('conga: data must have a column named `glucose`.')
    end

    %Set the CONGAOrd hyperparameter to 4 (number of hours in the past it
    %refers to)
    CONGAOrd = 4;
    
    %Build vectors
    delay = minutes(CONGAOrd * 60);
    
    n = height(data);
    
    Dc = [];

    for i = 2:n

        % Find the index referring to CONGAOrd hours ago
        j = find(data.Time <= (data.Time(i) - delay), 1, 'last'); 
        
        if ~isempty(j) % if there is a meaningful sample in data.glucose(j)
            Dc = [Dc 
                  data.glucose(i) - data.glucose(j)];
        end

    end

    if ~isempty(Dc)
        conga = nanstd(Dc);
    else
        conga = nan;
    end

end

