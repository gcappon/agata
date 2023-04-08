function results = analyzeGlucoseProfile(data, varargin)
%analyzeGlucoseProfile function that computes the glycemic outcomes of a
%glucose profile.
%
%Input:
%    - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%    - results: a structure with field containing the computed metrics of
%    the glucose profile, i.e.:
%        - `variabilityMetrics`: a structure with fields containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`,`cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) of the 
%           glucose profile; 
%        - `riskMetrics`: a structure (contains only `gri` if GlycemicTarget is `pregnancy`) with fields containing the values of the computed 
%           risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`, `gri`}) of the 
%           glucose profile;
%        - `dataQualityMetrics`: a structure with fields containing the values of the computed 
%           data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) of 
%           the glucose profile;
%        - `timeMetrics`: a structure with fields containing the values of the computed 
%           time related metrics (i.e., {`timeInHyperglycemia`, 
%           `timeInL1Hyperglycemia`, `timeInL2Hyperglycemia`, `timeInHypoglycemia`, 
%           `timeInL1Hypoglycemia`, `timeInL2Hypoglycemia`, `timeInTarget`, `timeInTightTarget`}) 
%           of the glucose profile;
%        - `glycemicTransformationMetrics`: a structure (empty if GlycemicTarget is `pregnancy`) with fields containing the values of the computed 
%           glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) of the glucose profile;
%        - `eventMetrics`: a structure with fields containing the values of the computed 
%           event related metrics (i.e., {`hypoglycemicEvents`, `hyperglycemicEvents`, 
%           `extendedHypoglycemicEvents`}) of the glucose profile.
%
%Preconditions:
%   - `data` must be a timetable having an homogeneous time grid;
%   - `data` must contain a column named `Time` and another named `glucose`.
%   - `GlycemicTarget` can be `pregnancy` or `diabetes`.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - None.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Check preconditions 
    if(~istimetable(data))
        error('analyzeGlucoseProfile: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('analyzeGlucoseProfile: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('analyzeGlucoseProfile: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('analyzeGlucoseProfile: data must have a column named `glucose`.')
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
    
    %Variability metrics
    if(strcmp(glycemicTarget,'diabetes'))
        variabilityMetrics = {'aucGlucose','CVGA','cogi','cvGlucose','efIndex','gmi','iqrGlucose',...
            'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',...
            'rangeGlucose','sddmIndex','sdwIndex','stdGlucose','conga','modd', 'stdGlucoseROC'};
    else 
        if(strcmp(glycemicTarget,'pregnancy'))
            variabilityMetrics = {'aucGlucose','CVGA','cogi','cvGlucose','efIndex','gmi','iqrGlucose',...
                'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',...
                'rangeGlucose','sddmIndex','sdwIndex','stdGlucose','conga','modd', 'stdGlucoseROC'};
        end
    end
    
    for v = variabilityMetrics
        
        %Compute metric for glucose profile
        results.variability.(v{:}) = feval(v{:}, data);
        
    end
    
    %Risk metrics
    if(strcmp(glycemicTarget,'diabetes'))
        riskMetrics = {'adrr','bgri','hbgi','lbgi','gri'};
    else 
            if(strcmp(glycemicTarget,'pregnancy'))
                riskMetrics = {'gri'};
            end
    end
    
    for r = riskMetrics
        
        %Compute metric for glucose profile
        results.risk.(r{:}) = feval(r{:}, data);
        
    end
    
    
    %Time metrics
    if(strcmp(glycemicTarget,'diabetes'))
        timeMetrics = {'timeInHyperglycemia','timeInL1Hyperglycemia','timeInL2Hyperglycemia',...
            'timeInHypoglycemia','timeInL1Hypoglycemia','timeInL2Hypoglycemia',...
            'timeInTarget','timeInTightTarget'};
    else 
            if(strcmp(glycemicTarget,'pregnancy'))
                timeMetrics = {'timeInHyperglycemia','timeInL1Hyperglycemia','timeInL2Hyperglycemia',...
                'timeInHypoglycemia','timeInL1Hypoglycemia','timeInL2Hypoglycemia',...
                'timeInTarget','timeInTightTarget'};
            end
    end
    
    for t = timeMetrics
        
        %Compute metric for glucose profile
        results.time.(t{:}) = feval(t{:}, data,'GlycemicTarget',glycemicTarget);
        
    end
    
     %Glycemic transformation metrics
    if(strcmp(glycemicTarget,'diabetes'))
        glycemicTransformationMetrics = {'gradeEuScore','gradeHyperScore','gradeHypoScore',...
             'gradeScore','hyperIndex','hypoIndex','igc','mrIndex'};
    else 
            if(strcmp(glycemicTarget,'pregnancy'))
                glycemicTransformationMetrics = {};
            end
    end
     
     for gt = glycemicTransformationMetrics
         
         %Compute metric for glucose profile
         results.glycemicTransformation.(gt{:}) = feval(gt{:}, data);
         
     end
    
    %Data quality metrics
    if(strcmp(glycemicTarget,'diabetes'))
        dataQualityMetrics = {'missingGlucosePercentage','numberDaysOfObservation'};
    else 
            if(strcmp(glycemicTarget,'pregnancy'))
                dataQualityMetrics = {'missingGlucosePercentage','numberDaysOfObservation'};
            end
    end
    
    for d = dataQualityMetrics
        
        %Compute metric for glucose profile
        results.dataQuality.(d{:}) = feval(d{:}, data);
        
    end
    
    
    %Event metrics
    if(strcmp(glycemicTarget,'diabetes'))
        eventMetrics = {'hyperglycemicEvents','hypoglycemicEvents','extendedHypoglycemicEvents'};
        eventFunc = {'findHyperglycemicEventsByLevel','findHypoglycemicEventsByLevel','findExtendedHypoglycemicEvents'};
    else 
            if(strcmp(glycemicTarget,'pregnancy'))
                eventMetrics = {'hyperglycemicEvents','hypoglycemicEvents','extendedHypoglycemicEvents'};
                eventFunc = {'findHyperglycemicEventsByLevel','findHypoglycemicEventsByLevel','findExtendedHypoglycemicEvents'};
            end
    end
    for e = 1:length(eventMetrics)
        
        %Compute metric for glucose profile
        results.event.(eventMetrics{e}) = feval(eventFunc{e}, data,'GlycemicTarget',glycemicTarget);
      
    end
    
end

