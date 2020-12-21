function results = analyzeOneArm(arm)
%analyzeOneArm function that computes the glycemic outcomes of an arm.
%
%Inputs:
%    - arm: a cell array of timetables containing the glucose data of the 
%   arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings
%   (in mg/dl).
%Output:
%    - results: a structure with field containing the computed metrics in the arm, i.e.:
%        - `variabilityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`}) of the 
%           metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;   
%        - `riskMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`}) of the 
%           metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;   
%        - `dataQualityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           data quality metrics (i.e., {`missingGlucosePercentage`}) of 
%           the metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;  
%        - `timeMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           time related metrics (i.e., {`timeInHyperglycemia`, 
%           `timeInSevereHyperglycemia`, `timeInHypoglycemia`, 
%           `timeInSevereHypoglycemia`, `timeInTarget`, `timeInTightTarget`}) 
%           of the metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`; 
%        - `glycemicTransformationMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) of the metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`; 
%        - `eventMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           event related metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) of the metrics for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`.
%
%Preconditions:
%    - `arm` must be a cell array containing timetables;
%    - Each timetable in `arm` must have a column names `Time` and a
%    column named `glucose`.
%    - Each timetable in `arm` must have an homogeneous time grid.
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

    %Check inputs 
    if(~iscell(arm))
        error('analyzeOneArm: arm must be a cell array.');
    end
    
    for g = 1:length(arm)
        if(~istimetable(arm{g}))
            error(['analyzeOneArm: arm, timetable in position ' num2str(g) ' must be a timetable.']);
        end
        if(~any(strcmp(fieldnames(arm{g}),'glucose')))
            error(['analyzeOneArm: arm, timetable in position ' num2str(g) ' must contain a column named glucose.']);
        end
        if(~any(strcmp(fieldnames(arm{g}),'Time')))
            error(['analyzeOneArm: arm, timetable in position ' num2str(g) ' must contain a column named Time.']);
        end
        if(var(seconds(diff(arm{g}.Time))) > 0 || isnan(var(seconds(diff(arm{g}.Time)))))
            error(['analyzeOneArm: arm, timetable in position ' num2str(g) ' must have a homogeneous time grid.']);
        end
    end
    
    
    %Variability metrics
    variabilityMetrics = {'aucGlucose','CVGA','cvGlucose','efIndex','gmi','iqrGlucose',...
        'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',...
        'rangeGlucose','sddmIndex','sdwIndex','stdGlucose'};
    
    for v = variabilityMetrics
        
        %Preallocate
        results.variability.(v{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.variability.(v{:}).values(g) = feval(v{:}, arm{g});
        end
        
        %Compute metrics stats
        results.variability.(v{:}).mean = nanmean(results.variability.(v{:}).values);
        
        results.variability.(v{:}).std = nanstd(results.variability.(v{:}).values);
        
        results.variability.(v{:}).median = nanmean(results.variability.(v{:}).values);
        
        results.variability.(v{:}).prc5 = prctile(results.variability.(v{:}).values,5);
        results.variability.(v{:}).prc25 = prctile(results.variability.(v{:}).values,25);
        results.variability.(v{:}).prc75 = prctile(results.variability.(v{:}).values,75);
        results.variability.(v{:}).prc95 = prctile(results.variability.(v{:}).values,95);
        
    end
    
    %Risk metrics
    riskMetrics = {'adrr','bgri','hbgi','lbgi'};
    
    for r = riskMetrics
        
        %Preallocate
        results.risk.(r{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.risk.(r{:}).values(g) = feval(r{:}, arm{g});
        end
        
        %Compute metrics stats
        results.risk.(r{:}).mean = nanmean(results.risk.(r{:}).values);
        
        results.risk.(r{:}).std = nanstd(results.risk.(r{:}).values);
        
        results.risk.(r{:}).median = nanmean(results.risk.(r{:}).values);
        
        results.risk.(r{:}).prc5 = prctile(results.risk.(r{:}).values,5);
        results.risk.(r{:}).prc25 = prctile(results.risk.(r{:}).values,25);
        results.risk.(r{:}).prc75 = prctile(results.risk.(r{:}).values,75);
        results.risk.(r{:}).prc95 = prctile(results.risk.(r{:}).values,95);
        
    end
    
    
    %Time metrics
    timeMetrics = {'timeInHyperglycemia','timeInSevereHyperglycemia','timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
    
    for t = timeMetrics
        
        %Preallocate
        results.time.(t{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.time.(t{:}).values(g) = feval(t{:}, arm{g});
        end
        
        %Compute metrics stats
        results.time.(t{:}).mean = nanmean(results.time.(t{:}).values);
        
        results.time.(t{:}).std = nanstd(results.time.(t{:}).values);
        
        results.time.(t{:}).median = nanmean(results.time.(t{:}).values);
        
        results.time.(t{:}).prc5 = prctile(results.time.(t{:}).values,5);
        results.time.(t{:}).prc25 = prctile(results.time.(t{:}).values,25);
        results.time.(t{:}).prc75 = prctile(results.time.(t{:}).values,75);
        results.time.(t{:}).prc95 = prctile(results.time.(t{:}).values,95);
        
    end
    
    %Time metrics
    timeMetrics = {'timeInHyperglycemia','timeInSevereHyperglycemia','timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
    
    for t = timeMetrics
        
        %Preallocate
        results.time.(t{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.time.(t{:}).values(g) = feval(t{:}, arm{g});
        end
        
        %Compute metrics stats
        results.time.(t{:}).mean = nanmean(results.time.(t{:}).values);
        
        results.time.(t{:}).std = nanstd(results.time.(t{:}).values);
        
        results.time.(t{:}).median = nanmean(results.time.(t{:}).values);
        
        results.time.(t{:}).prc5 = prctile(results.time.(t{:}).values,5);
        results.time.(t{:}).prc25 = prctile(results.time.(t{:}).values,25);
        results.time.(t{:}).prc75 = prctile(results.time.(t{:}).values,75);
        results.time.(t{:}).prc95 = prctile(results.time.(t{:}).values,95);
        
    end
    
    %Data quality metrics
    dataQualityMetrics = {'missingGlucosePercentage'};
    
    for d = dataQualityMetrics
        
        %Preallocate
        results.dataQuality.(d{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.dataQuality.(d{:}).values(g) = feval(d{:}, arm{g});
        end
        
        %Compute metrics stats
        results.dataQuality.(d{:}).mean = nanmean(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).std = nanstd(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).median = nanmean(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).prc5 = prctile(results.dataQuality.(d{:}).values,5);
        results.dataQuality.(d{:}).prc25 = prctile(results.dataQuality.(d{:}).values,25);
        results.dataQuality.(d{:}).prc75 = prctile(results.dataQuality.(d{:}).values,75);
        results.dataQuality.(d{:}).prc95 = prctile(results.dataQuality.(d{:}).values,95);
        
    end
    
    
    %Event metrics
    eventMetrics = {'hyperglycemicEvents','hypoglycemicEvents','prolongedHypoglycemicEvents'};
    eventFunc = {'findHyperglycemicEvents','findHypoglycemicEvents','findProlongedHypoglycemicEvents'};
    for e = 1:length(eventMetrics)
        
        %Preallocate
        results.event.([eventMetrics{e} 'MeanDuration']).values = zeros(length(arm),1);
        results.event.([eventMetrics{e} 'PerWeek']).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            r = feval(eventFunc{e}, arm{g});
            results.event.([eventMetrics{e} 'MeanDuration']).values(g) = mean(r.duration);
            nDays = days(arm{g}.Time(end) - arm{g}.Time(1)); 
            results.event.([eventMetrics{e} 'PerWeek']).values(g) = length(r.time)/(nDays)*7;
        end

        
        %Compute metrics stats
        results.event.([eventMetrics{e} 'MeanDuration']).mean = nanmean(results.event.([eventMetrics{e} 'MeanDuration']).values);
        results.event.([eventMetrics{e} 'PerWeek']).mean = nanmean(results.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.event.([eventMetrics{e} 'MeanDuration']).std = nanstd(results.event.([eventMetrics{e} 'MeanDuration']).values);
        results.event.([eventMetrics{e} 'PerWeek']).std = nanstd(results.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.event.([eventMetrics{e} 'MeanDuration']).median = nanmean(results.event.([eventMetrics{e} 'MeanDuration']).values);
        results.event.([eventMetrics{e} 'PerWeek']).median = nanmean(results.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.event.([eventMetrics{e} 'MeanDuration']).prc5 = prctile(results.event.([eventMetrics{e} 'MeanDuration']).values,5);
        results.event.([eventMetrics{e} 'PerWeek']).prc5 = prctile(results.event.([eventMetrics{e} 'PerWeek']).values,5);
        
        results.event.([eventMetrics{e} 'MeanDuration']).prc25 = prctile(results.event.([eventMetrics{e} 'MeanDuration']).values,25);
        results.event.([eventMetrics{e} 'PerWeek']).prc25 = prctile(results.event.([eventMetrics{e} 'PerWeek']).values,25);
        
        results.event.([eventMetrics{e} 'MeanDuration']).prc75 = prctile(results.event.([eventMetrics{e} 'MeanDuration']).values,75);
        results.event.([eventMetrics{e} 'PerWeek']).prc75 = prctile(results.event.([eventMetrics{e} 'PerWeek']).values,75);
        
        results.event.([eventMetrics{e} 'MeanDuration']).prc95 = prctile(results.event.([eventMetrics{e} 'MeanDuration']).values,95);
        results.event.([eventMetrics{e} 'PerWeek']).prc95 = prctile(results.event.([eventMetrics{e} 'PerWeek']).values,95);
      
    end
    
end

