function mageIndex = mageIndex(data)
%mageIndex function that computes the mean amplitude of glycemic excursion
%(MAGE) index (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - mageIndex: the mean amplitude of glycemic excursion (MAGE) index
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Service et al., "Mean amplitude of glycemic excursions, a measure of 
%   diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 
%   10.2337/diab.19.9.644.
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
        error('mageIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('mageIndex: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('mageIndex: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('mageIndex: data must have a column named `glucose`.')
    end
    
    %Compute index
    mageIndex = (magePlusIndex(data) + mageMinusIndex(data))/2;
    
end

