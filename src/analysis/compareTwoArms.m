function [results, stats] = compareTwoArms(arm1,arm2,isPaired,alpha,varargin)
%compareTwoArms function that compares the glycemic outcomes of two arms
%
%Inputs:
%    - arm1: a cell array of timetables containing the glucose data of the 
%   first arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
%    - arm2: a cell array of timetables containing the glucose data of the 
%   second arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
%    - isPaired: a numeric flag defining whether to run paired or unpaired 
%   analysis. Commonly paired tests are performed when data of the same 
%   patients are present in both arms, unpaired otherwise;
%    - alpha: a double representing the significance level to use.
%   - GlycemicTarget: a vector of characters defining the set of glycemic
%   targets to use. The default value is `diabetes`. It can be {`diabetes`,
%   `pregnancy`).
%Outputs;
%    - results: a structure with field `arm1` and `arm2`, that are two 
%   structures with field containing the computed metrics in the two arms, i.e.:
%        - `variabilityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`, `cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) for each glucose profile;
%            - `mean`: the mean of `values`;
%            - `median`: the median of `values`;
%            - `std`: the standard deviation of `values`;
%            - `prc5`: the 5th percentile of `values`;
%            - `prc25`: the 25th percentile of `values`;
%            - `prc75`: the 75th percentile of `values`;
%            - `prc95`: the 95th percentile of `values`;   
%        - `riskMetrics`: a structure (contains only `gri` if GlycemicTarget is `pregnancy`) with fields:
%            - `values`: a vector containing the values of the computed 
%           risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`,`gri`}) of the 
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
%            - `prc95`: the 95th percentile of `values`; 
%    - stats: a structure that contains for each of the considered metrics 
%   the result of the statistical test with field `p` (p-value value) and 
%   `h` null hypothesis accepted or rejcted. Statistical tests are: 
%        - t-test if the test `isPaired` and the samples are both gaussian 
%       distributed (checked with the Lilliefors test);
%        - unpaired t-test if the test not `isPaired` and the samples are 
%       both gaussian distributed (checked with the Lilliefors test);
%        - Wilcoxon rank test if the test `isPaired` and at least one of 
%       the samples is not gaussian distributed (checked with the Lilliefors test); 
%        - Mann-Whitney U-test if the test not `isPaired` and at least one 
%       of the samples is not gaussian distributed (checked with the Lilliefors test).
%
%Preconditions:
%    - `arm1` must be a cell array containing timetables;
%    - `arm2` must be a cell array containing timetables;
%    - Each timetable in `arm1` and `arm2` must have a column names `Time` and a
%    column named `glucose`.
%    - Each timetable in `arm1` and `arm2` must have an homogeneous time grid;
%    - `isPaired` can be 0 or 1.
%   - `GlycemicTarget` can be `pregnancy` or `diabetes`.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Lilliefors et al., "On the Kolmogorov-Smirnov test for normality with 
%   mean and variance unknown," Mathematics, vol. 62, 1967, pp. 399–402. 
%   DOI: 10.1080/01621459.1967.10482916.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Check inputs 
    if(~iscell(arm1))
        error('compareTwoArms: arm1 must be a cell array.');
    end
    if(~iscell(arm2))
        error('compareTwoArms: arm2 must be a cell array.');
    end
    
    for g = 1:length(arm1)
        if(~istimetable(arm1{g}))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must be a timetable.']);
        end
        if(~any(strcmp(fieldnames(arm1{g}),'glucose')))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must contain a column named glucose.']);
        end
        if(~any(strcmp(fieldnames(arm1{g}),'Time')))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must contain a column named Time.']);
        end
        if(var(seconds(diff(arm1{g}.Time))) > 0 || isnan(var(seconds(diff(arm1{g}.Time)))))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must have a homogeneous time grid.']);
        end
    
    end
    
    for g = 1:length(arm2)
        if(~istimetable(arm2{g}))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must be a timetable.']);
        end
        if(~any(strcmp(fieldnames(arm2{g}),'glucose')))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must contain a column named glucose.']);
        end
        if(~any(strcmp(fieldnames(arm2{g}),'Time')))
            error(['compareTwoArms: arm1, timetable in position ' num2str(g) ' must contain a column named Time.']);
        end
        if(var(seconds(diff(arm2{g}.Time))) > 0 || isnan(var(seconds(diff(arm2{g}.Time)))))
            error(['compareTwoArms: arm2, timetable in position ' num2str(g) ' must have a homogeneous time grid.']);
        end
    end
    
    
    if(~(isPaired == 0 || isPaired == 1))
        error(['compareTwoArms: isPaired must be 0 or 1.']);
    end
    
    if(isPaired && (length(arm1)~=length(arm2)))
        error(['compareTwoArms: You are trying to perform a paired test but the number of glucose profiles in the two arms is different.']);
    end
    
    %Input parser and check preconditions
    defaultGlycemicTarget = 'diabetes';
    expectedGlycemicTarget = {'diabetes','pregnancy'};
    
    params = inputParser;
    params.CaseSensitive = false;
    
    addRequired(params,'arm1',@(x) true); %already checked
    addRequired(params,'arm2',@(x) true); %already checked
    addRequired(params,'isPaired',@(x) true); %already checked
    addRequired(params,'alpha',@(x) true); %already checked
    addOptional(params,'GlycemicTarget',defaultGlycemicTarget, @(x) any(validatestring(x,expectedGlycemicTarget)));

    parse(params,arm1,arm2,isPaired,alpha,varargin{:});
    
    %Initialization
    glycemicTarget = params.Results.GlycemicTarget;
    
    results.arm1 = analyzeOneArm(arm1,'GlycemicTarget',glycemicTarget);
    results.arm2 = analyzeOneArm(arm2,'GlycemicTarget',glycemicTarget);
    
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
        
        %Perform statistical tests
        res1 = results.arm1.variability.(v{:}).values;
        res2 = results.arm2.variability.(v{:}).values;

        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.variability.(v{:}).h, stats.variability.(v{:}).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.variability.(v{:}).h, stats.variability.(v{:}).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.variability.(v{:}).p, stats.variability.(v{:}).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.variability.(v{:}).p, stats.variability.(v{:}).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
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
        
        %Perform statistical tests
        res1 = results.arm1.risk.(r{:}).values;
        res2 = results.arm2.risk.(r{:}).values;

        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  (~lillietest(res1) && ~lillietest(res2)))
            if(isPaired)
                [stats.risk.(r{:}).h, stats.risk.(r{:}).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.risk.(r{:}).h, stats.risk.(r{:}).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.risk.(r{:}).p, stats.risk.(r{:}).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.risk.(r{:}).p, stats.risk.(r{:}).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
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
        
        %Perform statistical tests
        res1 = results.arm1.time.(t{:}).values;
        res2 = results.arm2.time.(t{:}).values;

        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.time.(t{:}).h, stats.time.(t{:}).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.time.(t{:}).h, stats.time.(t{:}).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.time.(t{:}).p, stats.time.(t{:}).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.time.(t{:}).p, stats.time.(t{:}).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
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
        
        %Perform statistical tests
        res1 = results.arm1.dataQuality.(d{:}).values;
        res2 = results.arm2.dataQuality.(d{:}).values;

        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.dataQuality.(d{:}).h, stats.dataQuality.(d{:}).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.dataQuality.(d{:}).h, stats.dataQuality.(d{:}).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.dataQuality.(d{:}).p, stats.dataQuality.(d{:}).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.dataQuality.(d{:}).p, stats.dataQuality.(d{:}).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
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
        
        %Perform statistical tests
        res1 = results.arm1.glycemicTransformation.(gt{:}).values;
        res2 = results.arm2.glycemicTransformation.(gt{:}).values;

        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.glycemicTransformation.(gt{:}).h, stats.glycemicTransformation.(gt{:}).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.glycemicTransformation.(gt{:}).h, stats.glycemicTransformation.(gt{:}).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.glycemicTransformation.(gt{:}).p, stats.glycemicTransformation.(gt{:}).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.glycemicTransformation.(gt{:}).p, stats.glycemicTransformation.(gt{:}).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
    end
    
    
    %Event metrics

    %Perform statistical tests
    %Hypo - Mean duration
    res1 = results.arm1.event.hypoglycemicEvents.hypo.meanDuration.values;
    res2 = results.arm2.event.hypoglycemicEvents.hypo.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.hypo.meanDuration.h, stats.event.hypoglycemicEvents.hypo.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.hypo.meanDuration.h, stats.event.hypoglycemicEvents.hypo.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.hypo.meanDuration.p, stats.event.hypoglycemicEvents.hypo.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.hypo.meanDuration.p, stats.event.hypoglycemicEvents.hypo.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
       
    res1 = results.arm1.event.hypoglycemicEvents.l1.meanDuration.values;
    res2 = results.arm2.event.hypoglycemicEvents.l1.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.l1.meanDuration.h, stats.event.hypoglycemicEvents.l1.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l1.meanDuration.h, stats.event.hypoglycemicEvents.l1.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.l1.meanDuration.p, stats.event.hypoglycemicEvents.l1.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l1.meanDuration.p, stats.event.hypoglycemicEvents.l1.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    res1 = results.arm1.event.hypoglycemicEvents.l2.meanDuration.values;
    res2 = results.arm2.event.hypoglycemicEvents.l2.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.l2.meanDuration.h, stats.event.hypoglycemicEvents.l2.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l2.meanDuration.h, stats.event.hypoglycemicEvents.l2.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.l2.meanDuration.p, stats.event.hypoglycemicEvents.l2.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l2.meanDuration.p, stats.event.hypoglycemicEvents.l2.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    %Hyper - Mean Duration
    res1 = results.arm1.event.hyperglycemicEvents.hyper.meanDuration.values;
    res2 = results.arm2.event.hyperglycemicEvents.hyper.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.hyper.meanDuration.h, stats.event.hyperglycemicEvents.hyper.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.hyper.meanDuration.h, stats.event.hyperglycemicEvents.hyper.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.hyper.meanDuration.p, stats.event.hyperglycemicEvents.hyper.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.hyper.meanDuration.p, stats.event.hyperglycemicEvents.hyper.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
       
    res1 = results.arm1.event.hyperglycemicEvents.l1.meanDuration.values;
    res2 = results.arm2.event.hyperglycemicEvents.l1.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.l1.meanDuration.h, stats.event.hyperglycemicEvents.l1.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l1.meanDuration.h, stats.event.hyperglycemicEvents.l1.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.l1.meanDuration.p, stats.event.hyperglycemicEvents.l1.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l1.meanDuration.p, stats.event.hyperglycemicEvents.l1.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    res1 = results.arm1.event.hyperglycemicEvents.l2.meanDuration.values;
    res2 = results.arm2.event.hyperglycemicEvents.l2.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.l2.meanDuration.h, stats.event.hyperglycemicEvents.l2.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l2.meanDuration.h, stats.event.hyperglycemicEvents.l2.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.l2.meanDuration.p, stats.event.hyperglycemicEvents.l2.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l2.meanDuration.p, stats.event.hyperglycemicEvents.l2.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    %Extended Hypo - Mean duration
    res1 = results.arm1.event.extendedHypoglycemicEvents.meanDuration.values;
    res2 = results.arm2.event.extendedHypoglycemicEvents.meanDuration.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.extendedHypoglycemicEvents.meanDuration.h, stats.event.extendedHypoglycemicEvents.meanDuration.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.extendedHypoglycemicEvents.meanDuration.h, stats.event.extendedHypoglycemicEvents.meanDuration.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.extendedHypoglycemicEvents.meanDuration.p, stats.event.extendedHypoglycemicEvents.meanDuration.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.extendedHypoglycemicEvents.meanDuration.p, stats.event.extendedHypoglycemicEvents.meanDuration.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
      
        %Hypo - Events Per Week
    res1 = results.arm1.event.hypoglycemicEvents.hypo.eventsPerWeek.values;
    res2 = results.arm2.event.hypoglycemicEvents.hypo.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.hypo.eventsPerWeek.h, stats.event.hypoglycemicEvents.hypo.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.hypo.eventsPerWeek.h, stats.event.hypoglycemicEvents.hypo.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.hypo.eventsPerWeek.p, stats.event.hypoglycemicEvents.hypo.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.hypo.eventsPerWeek.p, stats.event.hypoglycemicEvents.hypo.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
       
    res1 = results.arm1.event.hypoglycemicEvents.l1.eventsPerWeek.values;
    res2 = results.arm2.event.hypoglycemicEvents.l1.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.l1.eventsPerWeek.h, stats.event.hypoglycemicEvents.l1.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l1.eventsPerWeek.h, stats.event.hypoglycemicEvents.l1.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.l1.eventsPerWeek.p, stats.event.hypoglycemicEvents.l1.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l1.eventsPerWeek.p, stats.event.hypoglycemicEvents.l1.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    res1 = results.arm1.event.hypoglycemicEvents.l2.eventsPerWeek.values;
    res2 = results.arm2.event.hypoglycemicEvents.l2.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hypoglycemicEvents.l2.eventsPerWeek.h, stats.event.hypoglycemicEvents.l2.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l2.eventsPerWeek.h, stats.event.hypoglycemicEvents.l2.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hypoglycemicEvents.l2.eventsPerWeek.p, stats.event.hypoglycemicEvents.l2.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hypoglycemicEvents.l2.eventsPerWeek.p, stats.event.hypoglycemicEvents.l2.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    %Hyper - Events Per Week
    res1 = results.arm1.event.hyperglycemicEvents.hyper.eventsPerWeek.values;
    res2 = results.arm2.event.hyperglycemicEvents.hyper.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.hyper.eventsPerWeek.h, stats.event.hyperglycemicEvents.hyper.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.hyper.eventsPerWeek.h, stats.event.hyperglycemicEvents.hyper.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.hyper.eventsPerWeek.p, stats.event.hyperglycemicEvents.hyper.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.hyper.eventsPerWeek.p, stats.event.hyperglycemicEvents.hyper.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
       
    res1 = results.arm1.event.hyperglycemicEvents.l1.eventsPerWeek.values;
    res2 = results.arm2.event.hyperglycemicEvents.l1.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.l1.eventsPerWeek.h, stats.event.hyperglycemicEvents.l1.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l1.eventsPerWeek.h, stats.event.hyperglycemicEvents.l1.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.l1.eventsPerWeek.p, stats.event.hyperglycemicEvents.l1.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l1.eventsPerWeek.p, stats.event.hyperglycemicEvents.l1.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    res1 = results.arm1.event.hyperglycemicEvents.l2.eventsPerWeek.values;
    res2 = results.arm2.event.hyperglycemicEvents.l2.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.hyperglycemicEvents.l2.eventsPerWeek.h, stats.event.hyperglycemicEvents.l2.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l2.eventsPerWeek.h, stats.event.hyperglycemicEvents.l2.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.hyperglycemicEvents.l2.eventsPerWeek.p, stats.event.hyperglycemicEvents.l2.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.hyperglycemicEvents.l2.eventsPerWeek.p, stats.event.hyperglycemicEvents.l2.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
    %Extended Hypo - Events Per Week
    res1 = results.arm1.event.extendedHypoglycemicEvents.eventsPerWeek.values;
    res2 = results.arm2.event.extendedHypoglycemicEvents.eventsPerWeek.values;

    if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
        if(isPaired)
            [stats.event.extendedHypoglycemicEvents.eventsPerWeek.h, stats.event.extendedHypoglycemicEvents.eventsPerWeek.p] = ttest(res1,res2,'Alpha',alpha);
        else
            [stats.event.extendedHypoglycemicEvents.eventsPerWeek.h, stats.event.extendedHypoglycemicEvents.eventsPerWeek.p] = ttest2(res1,res2,'Alpha',alpha);
        end
    else
        if(isPaired)
            [stats.event.extendedHypoglycemicEvents.eventsPerWeek.p, stats.event.extendedHypoglycemicEvents.eventsPerWeek.h] = signrank(res1,res2,'Alpha',alpha);
        else
            [stats.event.extendedHypoglycemicEvents.eventsPerWeek.p, stats.event.extendedHypoglycemicEvents.eventsPerWeek.h] = ranksum(res1,res2,'Alpha',alpha);
        end
    end
    
        
    
end

