function timeInHyperglycemia = timeInHyperglycemia(data,varargin)
%timeInHyperglycemia function that computes the time spent in hyperglycemia
%(ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%   - timeInHyperglycemia: percentage of time in hyperglycemia (i.e., 
%   > 180 mg/dl if `GlycemicTarget` is `diabetes`, 140 mg/dl if `GlycemicTarget` is `pregnancy`).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
%   - `GlycemicTarget` can be `pregnancy` or `diabetes`.
%
% ------------------------------------------------------------------------
% 
% Reference:
%   - Battelino et al., "Continuous glucose monitoring and merics for 
%   clinical trials: An international consensus statement", The Lancet
%   Diabetes & Endocrinology, 2022, pp. 1-16.
%   DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
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
        error('timeInHyperglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInHyperglycemia: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInHyperglycemia: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInHyperglycemia: data must have a column named `glucose`.')
    end
    
    %Input parser and check preconditions
    defaultGlycemicTarget = 'diabetes';
    expectedGlycemicTarget = {'diabetes','pregnancy'};
    
    params = inputParser;
    params.CaseSensitive = false;
    
    addRequired(params,'data',@(x) true); %already checked
    addOptional(params,'GlycemicTarget',defaultGlycemicTarget, @(x) any(validatestring(x,expectedGlycemicTarget)));

    parse(params,data,varargin{:});

    %Initialization
    glycemicTarget = params.Results.GlycemicTarget;
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Set the threshold
    if(strcmp(glycemicTarget,'diabetes'))
        th = 180;
    else
        if(strcmp(glycemicTarget,'pregnancy'))
            th = 140;
        end
    end
    
    %Compute metric
    timeInHyperglycemia = 100*sum(nonNanGlucose > th)/length(nonNanGlucose);
    
end

