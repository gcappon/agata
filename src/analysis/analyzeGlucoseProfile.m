function results = analyzeGlucoseProfile(data)
%analyzeGlucoseProfile function that computes the glycemic outcomes of a
%glucose profile.
%
%Input:
%    - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%    - results: a structure with field containing the computed metrics of
%    the glucose profile, i.e.:
%        - `variabilityMetrics`: a structure with fields containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`}) of the 
%           metrics for each glucose profile; 
%        - `riskMetrics`: a structure with fields containing the values of the computed 
%           risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`}) of the 
%           metrics for each glucose profile;
%        - `dataQualityMetrics`: a structure with fields containing the values of the computed 
%           data quality metrics (i.e., {`missingGlucosePercentage`}) of 
%           the metrics for each glucose profile;
%        - `timeMetrics`: a structure with fields containing the values of the computed 
%           time related metrics (i.e., {`timeInHyperglycemia`, 
%           `timeInSevereHyperglycemia`, `timeInHypoglycemia`, 
%           `timeInSevereHypoglycemia`, `timeInTarget`, `timeInTightTarget`}) 
%           of the metrics for each glucose profile;
%        - `glycemicTransformationMetrics`: a structure with fields containing the values of the computed 
%           glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) of the metrics for each glucose profile;
%        - `eventMetrics`: a structure with fields containing the values of the computed 
%           event related metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) of the metrics for each glucose profile.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
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
    
    
    %Variability metrics
    variabilityMetrics = {'aucGlucose','CVGA','cvGlucose','efIndex','gmi','iqrGlucose',...
        'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',...
        'rangeGlucose','sddmIndex','sdwIndex','stdGlucose'};
    
    for v = variabilityMetrics
        
        %Compute metric for glucose profile
        results.variability.(v{:}) = feval(v{:}, data);
        
    end
    
    %Risk metrics
    riskMetrics = {'adrr','bgri','hbgi','lbgi'};
    
    for r = riskMetrics
        
        %Compute metric for glucose profile
        results.risk.(r{:}) = feval(r{:}, data);
        
    end
    
    
    %Time metrics
    timeMetrics = {'timeInHyperglycemia','timeInSevereHyperglycemia','timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
    
    for t = timeMetrics
        
        %Compute metric for glucose profile
        results.time.(t{:}) = feval(t{:}, data);
        
    end
    
    %Time metrics
    timeMetrics = {'timeInHyperglycemia','timeInSevereHyperglycemia','timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
    
    for t = timeMetrics
        
        %Compute metric for glucose profile
        results.time.(t{:}) = feval(t{:}, data);
        
    end
    
    %Data quality metrics
    dataQualityMetrics = {'missingGlucosePercentage'};
    
    for d = dataQualityMetrics
        
        %Compute metric for glucose profile
        results.dataQuality.(d{:}) = feval(d{:}, data);
        
    end
    
    
    %Event metrics
    eventMetrics = {'hyperglycemicEvents','hypoglycemicEvents','prolongedHypoglycemicEvents'};
    eventFunc = {'findHyperglycemicEvents','findHypoglycemicEvents','findProlongedHypoglycemicEvents'};
    for e = 1:length(eventMetrics)
        
        %Compute metric for glucose profile
        r = feval(eventFunc{e}, data);
        results.event.([eventMetrics{e} 'MeanDuration']) = mean(r.duration);
        nDays = days(data.Time(end) - data.Time(1)); 
        results.event.([eventMetrics{e} 'PerWeek']) = length(r.time)/nDays*7;
      
    end
    
end

