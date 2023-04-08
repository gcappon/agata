function results = analyzeOneArm(arm,varargin)
%analyzeOneArm function that computes the glycemic outcomes of an arm.
%
%Inputs:
%    - arm: a cell array of timetables containing the glucose data of the 
%   arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings
%   (in mg/dl);
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Output:
%    - results: a structure with field containing the computed metrics in the arm, i.e.:
%        - `variabilityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`, `cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`}) for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;   
%        - `riskMetrics`: a structure (contains only `gri` is GlycemicTarget is `pregnancy`) with fields:
%            - `values`: a vector containing the values of the computed 
%           risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`,`gri`}) for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;   
%        - `dataQualityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) for each glucose profile;
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
%           `timeInL1Hyperglycemia`, `timeInL2Hyperglycemia`, `timeInHypoglycemia`, 
%           `timeInL1Hypoglycemia`, `timeInL2Hypoglycemia`, `timeInTarget`, `timeInTightTarget`}) for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`; 
%        - `glycemicTransformationMetrics`: a structure (empty if GlycemicTarget is `pregnancy`) with fields:
%            - `values`: a vector containing the values of the computed 
%           glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, 
%           `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, 
%           `igc`, `mrIndex`}) for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`; 
%        - `eventMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           event related metrics (i.e., {`hypoglycemicEvents`, `hyperglycemicEvents`, 
%           `extendedHypoglycemicEvents`}) for each glucose profile;
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
%    - `GlycemicTarget` can be `pregnancy` or `diabetes`.
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
    
    %Input parser and check preconditions
    defaultGlycemicTarget = 'diabetes';
    expectedGlycemicTarget = {'diabetes','pregnancy'};
    
    params = inputParser;
    params.CaseSensitive = false;
    
    addRequired(params,'arm',@(x) true); %already checked
    addOptional(params,'GlycemicTarget',defaultGlycemicTarget, @(x) any(validatestring(x,expectedGlycemicTarget)));

    parse(params,arm,varargin{:});

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
        
        %Preallocate
        results.variability.(v{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.variability.(v{:}).values(g) = feval(v{:}, arm{g});
        end
        
        %Compute metrics stats
        results.variability.(v{:}).mean = nanmean(results.variability.(v{:}).values);
        
        results.variability.(v{:}).std = nanstd(results.variability.(v{:}).values);
        
        results.variability.(v{:}).median = nanmedian(results.variability.(v{:}).values);
        
        results.variability.(v{:}).prc5 = prctile(results.variability.(v{:}).values,5);
        results.variability.(v{:}).prc25 = prctile(results.variability.(v{:}).values,25);
        results.variability.(v{:}).prc75 = prctile(results.variability.(v{:}).values,75);
        results.variability.(v{:}).prc95 = prctile(results.variability.(v{:}).values,95);
        
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
        
        %Preallocate
        results.risk.(r{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.risk.(r{:}).values(g) = feval(r{:}, arm{g});
        end
        
        %Compute metrics stats
        results.risk.(r{:}).mean = nanmean(results.risk.(r{:}).values);
        
        results.risk.(r{:}).std = nanstd(results.risk.(r{:}).values);
        
        results.risk.(r{:}).median = nanmedian(results.risk.(r{:}).values);
        
        results.risk.(r{:}).prc5 = prctile(results.risk.(r{:}).values,5);
        results.risk.(r{:}).prc25 = prctile(results.risk.(r{:}).values,25);
        results.risk.(r{:}).prc75 = prctile(results.risk.(r{:}).values,75);
        results.risk.(r{:}).prc95 = prctile(results.risk.(r{:}).values,95);
        
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
        
        %Preallocate
        results.time.(t{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.time.(t{:}).values(g) = feval(t{:}, arm{g},'GlycemicTarget',glycemicTarget);
        end
        
        %Compute metrics stats
        results.time.(t{:}).mean = nanmean(results.time.(t{:}).values);
        
        results.time.(t{:}).std = nanstd(results.time.(t{:}).values);
        
        results.time.(t{:}).median = nanmedian(results.time.(t{:}).values);
        
        results.time.(t{:}).prc5 = prctile(results.time.(t{:}).values,5);
        results.time.(t{:}).prc25 = prctile(results.time.(t{:}).values,25);
        results.time.(t{:}).prc75 = prctile(results.time.(t{:}).values,75);
        results.time.(t{:}).prc95 = prctile(results.time.(t{:}).values,95);
        
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
        
        %Preallocate
        results.glycemicTransformation.(gt{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.glycemicTransformation.(gt{:}).values(g) = feval(gt{:}, arm{g});
        end
        
        %Compute metrics stats
        results.glycemicTransformation.(gt{:}).mean = nanmean(results.glycemicTransformation.(gt{:}).values);
        
        results.glycemicTransformation.(gt{:}).std = nanstd(results.glycemicTransformation.(gt{:}).values);
        
        results.glycemicTransformation.(gt{:}).median = nanmedian(results.glycemicTransformation.(gt{:}).values);
        
        results.glycemicTransformation.(gt{:}).prc5 = prctile(results.glycemicTransformation.(gt{:}).values,5);
        results.glycemicTransformation.(gt{:}).prc25 = prctile(results.glycemicTransformation.(gt{:}).values,25);
        results.glycemicTransformation.(gt{:}).prc75 = prctile(results.glycemicTransformation.(gt{:}).values,75);
        results.glycemicTransformation.(gt{:}).prc95 = prctile(results.glycemicTransformation.(gt{:}).values,95);
        
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
        
        %Preallocate
        results.dataQuality.(d{:}).values = zeros(length(arm),1);
        
        %Compute metrics for arm
        for g = 1:length(arm)
            results.dataQuality.(d{:}).values(g) = feval(d{:}, arm{g});
        end
        
        %Compute metrics stats
        results.dataQuality.(d{:}).mean = nanmean(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).std = nanstd(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).median = nanmedian(results.dataQuality.(d{:}).values);
        
        results.dataQuality.(d{:}).prc5 = prctile(results.dataQuality.(d{:}).values,5);
        results.dataQuality.(d{:}).prc25 = prctile(results.dataQuality.(d{:}).values,25);
        results.dataQuality.(d{:}).prc75 = prctile(results.dataQuality.(d{:}).values,75);
        results.dataQuality.(d{:}).prc95 = prctile(results.dataQuality.(d{:}).values,95);
        
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

        for g = 1:length(arm)
        
            %Compute metric for glucose profile
            event.(eventMetrics{e}).values{g} = feval(eventFunc{e}, arm{g},'GlycemicTarget',glycemicTarget);

        end
    end
    
    
    mDHyper = zeros(length(arm),1);
    mDHypo = zeros(length(arm),1);
    mDHyperL1 = zeros(length(arm),1);
    mDHypoL1 = zeros(length(arm),1);
    mDHyperL2 = zeros(length(arm),1);
    mDHypoL2 = zeros(length(arm),1);
    mDExtendedHypo = zeros(length(arm),1);
    
    pwHyper = zeros(length(arm),1);
    pwHypo = zeros(length(arm),1);
    pwHyperL1 = zeros(length(arm),1);
    pwHypoL1 = zeros(length(arm),1);
    pwHyperL2 = zeros(length(arm),1);
    pwHypoL2 = zeros(length(arm),1);
    pwExtendedHypo = zeros(length(arm),1);
    for g = 1:length(arm)
        
        mDHyper(g) = event.hyperglycemicEvents.values{g}.hyper.meanDuration;
        mDHypo(g) = event.hypoglycemicEvents.values{g}.hypo.meanDuration;
        mDHyperL1(g) = event.hyperglycemicEvents.values{g}.l1.meanDuration;
        mDHypoL1(g) = event.hypoglycemicEvents.values{g}.l1.meanDuration;
        mDHyperL2(g) = event.hyperglycemicEvents.values{g}.l2.meanDuration;
        mDHypoL2(g) = event.hypoglycemicEvents.values{g}.l2.meanDuration;
        mDExtendedHypo(g) = event.extendedHypoglycemicEvents.values{g}.meanDuration;
        
        pwHyper(g) = event.hyperglycemicEvents.values{g}.hyper.eventsPerWeek;
        pwHypo(g) = event.hypoglycemicEvents.values{g}.hypo.eventsPerWeek;
        pwHyperL1(g) = event.hyperglycemicEvents.values{g}.l1.eventsPerWeek;
        pwHypoL1(g) = event.hypoglycemicEvents.values{g}.l1.eventsPerWeek;
        pwHyperL2(g) = event.hyperglycemicEvents.values{g}.l2.eventsPerWeek;
        pwHypoL2(g) = event.hypoglycemicEvents.values{g}.l2.eventsPerWeek;
        pwExtendedHypo(g) = event.extendedHypoglycemicEvents.values{g}.eventsPerWeek;
        
    end
    
    %Values
    results.event.hyperglycemicEvents.hyper.meanDuration.values = mDHyper;
    results.event.hypoglycemicEvents.hypo.meanDuration.values = mDHypo;
    results.event.hyperglycemicEvents.l1.meanDuration.values = mDHyperL1;
    results.event.hypoglycemicEvents.l1.meanDuration.values = mDHypoL1;
    results.event.hyperglycemicEvents.l2.meanDuration.values = mDHyperL2;
    results.event.hypoglycemicEvents.l2.meanDuration.values = mDHypoL2;
    results.event.extendedHypoglycemicEvents.meanDuration.values = mDExtendedHypo;
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.values = pwHyper;
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.values = pwHypo;
    results.event.hyperglycemicEvents.l1.eventsPerWeek.values = pwHyperL1;
    results.event.hypoglycemicEvents.l1.eventsPerWeek.values = pwHypoL1;
    results.event.hyperglycemicEvents.l2.eventsPerWeek.values = pwHyperL2;
    results.event.hypoglycemicEvents.l2.eventsPerWeek.values = pwHypoL2;
    results.event.extendedHypoglycemicEvents.eventsPerWeek.values = pwExtendedHypo;
    
    %Mean
    results.event.hyperglycemicEvents.hyper.meanDuration.mean = nanmean(mDHyper);
    results.event.hypoglycemicEvents.hypo.meanDuration.mean = nanmean(mDHypo);
    results.event.hyperglycemicEvents.l1.meanDuration.mean = nanmean(mDHyperL1);
    results.event.hypoglycemicEvents.l1.meanDuration.mean = nanmean(mDHypoL1);
    results.event.hyperglycemicEvents.l2.meanDuration.mean = nanmean(mDHyperL2);
    results.event.hypoglycemicEvents.l2.meanDuration.mean = nanmean(mDHypoL2);
    results.event.extendedHypoglycemicEvents.meanDuration.mean = nanmean(mDExtendedHypo);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.mean = nanmean(pwHyper);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.mean = nanmean(pwHypo);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.mean = nanmean(pwHyperL1);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.mean = nanmean(pwHypoL1);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.mean = nanmean(pwHyperL2);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.mean = nanmean(pwHypoL2);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.mean = nanmean(pwExtendedHypo);
    
    %Median
    results.event.hyperglycemicEvents.hyper.meanDuration.median = nanmedian(mDHyper);
    results.event.hypoglycemicEvents.hypo.meanDuration.median = nanmedian(mDHypo);
    results.event.hyperglycemicEvents.l1.meanDuration.median = nanmedian(mDHyperL1);
    results.event.hypoglycemicEvents.l1.meanDuration.median = nanmedian(mDHypoL1);
    results.event.hyperglycemicEvents.l2.meanDuration.median = nanmedian(mDHyperL2);
    results.event.hypoglycemicEvents.l2.meanDuration.median = nanmedian(mDHypoL2);
    results.event.extendedHypoglycemicEvents.meanDuration.median = nanmedian(mDExtendedHypo);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.median = nanmedian(pwHyper);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.median = nanmedian(pwHypo);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.median = nanmedian(pwHyperL1);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.median = nanmedian(pwHypoL1);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.median = nanmedian(pwHyperL2);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.median = nanmedian(pwHypoL2);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.median = nanmedian(pwExtendedHypo);

    %Std
    results.event.hyperglycemicEvents.hyper.meanDuration.std = nanstd(mDHyper);
    results.event.hypoglycemicEvents.hypo.meanDuration.std = nanstd(mDHypo);
    results.event.hyperglycemicEvents.l1.meanDuration.std = nanstd(mDHyperL1);
    results.event.hypoglycemicEvents.l1.meanDuration.std = nanstd(mDHypoL1);
    results.event.hyperglycemicEvents.l2.meanDuration.std = nanstd(mDHyperL2);
    results.event.hypoglycemicEvents.l2.meanDuration.std = nanstd(mDHypoL2);
    results.event.extendedHypoglycemicEvents.meanDuration.std = nanstd(mDExtendedHypo);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.std = nanstd(pwHyper);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.std = nanstd(pwHypo);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.std = nanstd(pwHyperL1);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.std = nanstd(pwHypoL1);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.std = nanstd(pwHyperL2);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.std = nanstd(pwHypoL2);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.std = nanstd(pwExtendedHypo);
    
    %Prc5
    results.event.hyperglycemicEvents.hyper.meanDuration.prc5 = prctile(mDHyper,5);
    results.event.hypoglycemicEvents.hypo.meanDuration.prc5 = prctile(mDHypo,5);
    results.event.hyperglycemicEvents.l1.meanDuration.prc5 = prctile(mDHyperL1,5);
    results.event.hypoglycemicEvents.l1.meanDuration.prc5 = prctile(mDHypoL1,5);
    results.event.hyperglycemicEvents.l2.meanDuration.prc5 = prctile(mDHyperL2,5);
    results.event.hypoglycemicEvents.l2.meanDuration.prc5 = prctile(mDHypoL2,5);
    results.event.extendedHypoglycemicEvents.meanDuration.prc5 = prctile(mDExtendedHypo,5);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.prc5 = prctile(pwHyper,5);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.prc5 = prctile(pwHypo,5);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.prc5 = prctile(pwHyperL1,5);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.prc5 = prctile(pwHypoL1,5);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.prc5 = prctile(pwHyperL2,5);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.prc5 = prctile(pwHypoL2,5);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.prc5 = prctile(pwExtendedHypo,5);
    
    %Prc25
    results.event.hyperglycemicEvents.hyper.meanDuration.prc25 = prctile(mDHyper,25);
    results.event.hypoglycemicEvents.hypo.meanDuration.prc25 = prctile(mDHypo,25);
    results.event.hyperglycemicEvents.l1.meanDuration.prc25 = prctile(mDHyperL1,25);
    results.event.hypoglycemicEvents.l1.meanDuration.prc25 = prctile(mDHypoL1,25);
    results.event.hyperglycemicEvents.l2.meanDuration.prc25 = prctile(mDHyperL2,25);
    results.event.hypoglycemicEvents.l2.meanDuration.prc25 = prctile(mDHypoL2,25);
    results.event.extendedHypoglycemicEvents.meanDuration.prc25 = prctile(mDExtendedHypo,25);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.prc25 = prctile(pwHyper,25);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.prc25 = prctile(pwHypo,25);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.prc25 = prctile(pwHyperL1,25);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.prc25 = prctile(pwHypoL1,25);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.prc25 = prctile(pwHyperL2,25);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.prc25 = prctile(pwHypoL2,25);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.prc25 = prctile(pwExtendedHypo,25);
    
    %Prc75
    results.event.hyperglycemicEvents.hyper.meanDuration.prc75 = prctile(mDHyper,75);
    results.event.hypoglycemicEvents.hypo.meanDuration.prc75 = prctile(mDHypo,75);
    results.event.hyperglycemicEvents.l1.meanDuration.prc75 = prctile(mDHyperL1,75);
    results.event.hypoglycemicEvents.l1.meanDuration.prc75 = prctile(mDHypoL1,75);
    results.event.hyperglycemicEvents.l2.meanDuration.prc75 = prctile(mDHyperL2,75);
    results.event.hypoglycemicEvents.l2.meanDuration.prc75 = prctile(mDHypoL2,75);
    results.event.extendedHypoglycemicEvents.meanDuration.prc75 = prctile(mDExtendedHypo,75);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.prc75 = prctile(pwHyper,75);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.prc75 = prctile(pwHypo,75);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.prc75 = prctile(pwHyperL1,75);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.prc75 = prctile(pwHypoL1,75);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.prc75 = prctile(pwHyperL2,75);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.prc75 = prctile(pwHypoL2,75);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.prc75 = prctile(pwExtendedHypo,75);
    
    %Prc95
    results.event.hyperglycemicEvents.hyper.meanDuration.prc95 = prctile(mDHyper,95);
    results.event.hypoglycemicEvents.hypo.meanDuration.prc95 = prctile(mDHypo,95);
    results.event.hyperglycemicEvents.l1.meanDuration.prc95 = prctile(mDHyperL1,95);
    results.event.hypoglycemicEvents.l1.meanDuration.prc95 = prctile(mDHypoL1,95);
    results.event.hyperglycemicEvents.l2.meanDuration.prc95 = prctile(mDHyperL2,95);
    results.event.hypoglycemicEvents.l2.meanDuration.prc95 = prctile(mDHypoL2,95);
    results.event.extendedHypoglycemicEvents.meanDuration.prc95 = prctile(mDExtendedHypo,95);
    
    results.event.hyperglycemicEvents.hyper.eventsPerWeek.prc95 = prctile(pwHyper,95);
    results.event.hypoglycemicEvents.hypo.eventsPerWeek.prc95 = prctile(pwHypo,95);
    results.event.hyperglycemicEvents.l1.eventsPerWeek.prc95 = prctile(pwHyperL1,95);
    results.event.hypoglycemicEvents.l1.eventsPerWeek.prc95 = prctile(pwHypoL1,95);
    results.event.hyperglycemicEvents.l2.eventsPerWeek.prc95 = prctile(pwHyperL2,95);
    results.event.hypoglycemicEvents.l2.eventsPerWeek.prc95 = prctile(pwHypoL2,95);
    results.event.extendedHypoglycemicEvents.eventsPerWeek.prc95 = prctile(pwExtendedHypo,95);

end

