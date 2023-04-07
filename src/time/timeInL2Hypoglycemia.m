function timeInL2Hypoglycemia = timeInL2Hypoglycemia(data,varargin)
%timeInL2Hypoglycemia function that computes the time spent in level 2 
%hypoglycemia (ignoring nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%   - timeInSevereHypoglycemia: percentage of time in level 2 hypoglycemia (i.e., 
%   < 54 mg/dl if `GlycemicTarget` is `diabetes` or `pregnancy`).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`;
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
        error('timeInL2Hypoglycemia: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('timeInL2Hypoglycemia: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('timeInL2Hypoglycemia: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('timeInL2Hypoglycemia: data must have a column named `glucose`.')
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
        th = 54;
    else
        if(strcmp(glycemicTarget,'pregnancy'))
            th = 54;
        end
    end
    
    %Compute metric
    timeInL2Hypoglycemia = 100*sum(nonNanGlucose < th)/length(nonNanGlucose);
    
end

