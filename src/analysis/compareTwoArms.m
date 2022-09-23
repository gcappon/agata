function [results, stats] = compareTwoArms(arm1,arm2,isPaired,alpha)
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
%Outputs;
%    - results: a structure with field `arm1` and `arm2`, that are two 
%   structures with field containing the computed metrics in the two arms, i.e.:
%        - `variabilityMetrics`: a structure with fields:
%            - `values`: a vector containing the values of the computed 
%           variability metrics (i.e., {`aucGlucose`, `CVGA`, `cvGlucose`, 
%           `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, 
%           `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, 
%           `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) of the 
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
%           data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) of 
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
    
    %Variability metrics
    variabilityMetrics = {'aucGlucose','CVGA','cvGlucose','efIndex','gmi','iqrGlucose',...
        'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',...
        'rangeGlucose','sddmIndex','sdwIndex','stdGlucose','conga','modd', 'stdGlucoseROC'};
    
    for v = variabilityMetrics
        
        %Preallocate
        results.arm1.variability.(v{:}).values = zeros(length(arm1),1);
        results.arm2.variability.(v{:}).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.variability.(v{:}).values(g1) = feval(v{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.variability.(v{:}).values(g2) = feval(v{:}, arm2{g2});
        end
        
        %Compute metrics stats
        results.arm1.variability.(v{:}).mean = nanmean(results.arm1.variability.(v{:}).values);
        results.arm2.variability.(v{:}).mean = nanmean(results.arm2.variability.(v{:}).values);
        
        results.arm1.variability.(v{:}).std = nanstd(results.arm1.variability.(v{:}).values);
        results.arm2.variability.(v{:}).std = nanstd(results.arm2.variability.(v{:}).values);
        
        results.arm1.variability.(v{:}).median = nanmedian(results.arm1.variability.(v{:}).values);
        results.arm2.variability.(v{:}).median = nanmedian(results.arm2.variability.(v{:}).values);
        
        results.arm1.variability.(v{:}).prc5 = prctile(results.arm1.variability.(v{:}).values,5);
        results.arm2.variability.(v{:}).prc5 = prctile(results.arm2.variability.(v{:}).values,5);
        results.arm1.variability.(v{:}).prc25 = prctile(results.arm1.variability.(v{:}).values,25);
        results.arm2.variability.(v{:}).prc25 = prctile(results.arm2.variability.(v{:}).values,25);
        results.arm1.variability.(v{:}).prc75 = prctile(results.arm1.variability.(v{:}).values,75);
        results.arm2.variability.(v{:}).prc75 = prctile(results.arm2.variability.(v{:}).values,75);
        results.arm1.variability.(v{:}).prc95 = prctile(results.arm1.variability.(v{:}).values,95);
        results.arm2.variability.(v{:}).prc95 = prctile(results.arm2.variability.(v{:}).values,95);
    
        
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
    riskMetrics = {'adrr','bgri','hbgi','lbgi','gri'};
    
    for r = riskMetrics
        
        %Preallocate
        results.arm1.risk.(r{:}).values = zeros(length(arm1),1);
        results.arm2.risk.(r{:}).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.risk.(r{:}).values(g1) = feval(r{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.risk.(r{:}).values(g2) = feval(r{:}, arm2{g2});
        end
        
        %Compute metrics stats
        results.arm1.risk.(r{:}).mean = nanmean(results.arm1.risk.(r{:}).values);
        results.arm2.risk.(r{:}).mean = nanmean(results.arm2.risk.(r{:}).values);
        
        results.arm1.risk.(r{:}).std = nanstd(results.arm1.risk.(r{:}).values);
        results.arm2.risk.(r{:}).std = nanstd(results.arm2.risk.(r{:}).values);
        
        results.arm1.risk.(r{:}).median = nanmedian(results.arm1.risk.(r{:}).values);
        results.arm2.risk.(r{:}).median = nanmedian(results.arm2.risk.(r{:}).values);
        
        results.arm1.risk.(r{:}).prc5 = prctile(results.arm1.risk.(r{:}).values,5);
        results.arm2.risk.(r{:}).prc5 = prctile(results.arm2.risk.(r{:}).values,5);
        results.arm1.risk.(r{:}).prc25 = prctile(results.arm1.risk.(r{:}).values,25);
        results.arm2.risk.(r{:}).prc25 = prctile(results.arm2.risk.(r{:}).values,25);
        results.arm1.risk.(r{:}).prc75 = prctile(results.arm1.risk.(r{:}).values,75);
        results.arm2.risk.(r{:}).prc75 = prctile(results.arm2.risk.(r{:}).values,75);
        results.arm1.risk.(r{:}).prc95 = prctile(results.arm1.risk.(r{:}).values,95);
        results.arm2.risk.(r{:}).prc95 = prctile(results.arm2.risk.(r{:}).values,95);
        
        
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
    timeMetrics = {'timeInHyperglycemia','timeInSevereHyperglycemia','timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
    
    for t = timeMetrics
        
        %Preallocate
        results.arm1.time.(t{:}).values = zeros(length(arm1),1);
        results.arm2.time.(t{:}).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.time.(t{:}).values(g1) = feval(t{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.time.(t{:}).values(g2) = feval(t{:}, arm2{g2});
        end
        
        %Compute metrics stats
        results.arm1.time.(t{:}).mean = nanmean(results.arm1.time.(t{:}).values);
        results.arm2.time.(t{:}).mean = nanmean(results.arm2.time.(t{:}).values);
        
        results.arm1.time.(t{:}).std = nanstd(results.arm1.time.(t{:}).values);
        results.arm2.time.(t{:}).std = nanstd(results.arm2.time.(t{:}).values);
        
        results.arm1.time.(t{:}).median = nanmedian(results.arm1.time.(t{:}).values);
        results.arm2.time.(t{:}).median = nanmedian(results.arm2.time.(t{:}).values);
        
        results.arm1.time.(t{:}).prc5 = prctile(results.arm1.time.(t{:}).values,5);
        results.arm2.time.(t{:}).prc5 = prctile(results.arm2.time.(t{:}).values,5);
        results.arm1.time.(t{:}).prc25 = prctile(results.arm1.time.(t{:}).values,25);
        results.arm2.time.(t{:}).prc25 = prctile(results.arm2.time.(t{:}).values,25);
        results.arm1.time.(t{:}).prc75 = prctile(results.arm1.time.(t{:}).values,75);
        results.arm2.time.(t{:}).prc75 = prctile(results.arm2.time.(t{:}).values,75);
        results.arm1.time.(t{:}).prc95 = prctile(results.arm1.time.(t{:}).values,95);
        results.arm2.time.(t{:}).prc95 = prctile(results.arm2.time.(t{:}).values,95);
        
        
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
    dataQualityMetrics = {'missingGlucosePercentage','numberDaysOfObservation'};
    
    for d = dataQualityMetrics
        
        %Preallocate
        results.arm1.dataQuality.(d{:}).values = zeros(length(arm1),1);
        results.arm2.dataQuality.(d{:}).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.dataQuality.(d{:}).values(g1) = feval(d{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.dataQuality.(d{:}).values(g2) = feval(d{:}, arm2{g2});
        end
        
        %Compute metrics stats
        results.arm1.dataQuality.(d{:}).mean = nanmean(results.arm1.dataQuality.(d{:}).values);
        results.arm2.dataQuality.(d{:}).mean = nanmean(results.arm2.dataQuality.(d{:}).values);
        
        results.arm1.dataQuality.(d{:}).std = nanstd(results.arm1.dataQuality.(d{:}).values);
        results.arm2.dataQuality.(d{:}).std = nanstd(results.arm2.dataQuality.(d{:}).values);
        
        results.arm1.dataQuality.(d{:}).median = nanmedian(results.arm1.dataQuality.(d{:}).values);
        results.arm2.dataQuality.(d{:}).median = nanmedian(results.arm2.dataQuality.(d{:}).values);
        
        results.arm1.dataQuality.(d{:}).prc5 = prctile(results.arm1.dataQuality.(d{:}).values,5);
        results.arm2.dataQuality.(d{:}).prc5 = prctile(results.arm2.dataQuality.(d{:}).values,5);
        results.arm1.dataQuality.(d{:}).prc25 = prctile(results.arm1.dataQuality.(d{:}).values,25);
        results.arm2.dataQuality.(d{:}).prc25 = prctile(results.arm2.dataQuality.(d{:}).values,25);
        results.arm1.dataQuality.(d{:}).prc75 = prctile(results.arm1.dataQuality.(d{:}).values,75);
        results.arm2.dataQuality.(d{:}).prc75 = prctile(results.arm2.dataQuality.(d{:}).values,75);
        results.arm1.dataQuality.(d{:}).prc95 = prctile(results.arm1.dataQuality.(d{:}).values,95);
        results.arm2.dataQuality.(d{:}).prc95 = prctile(results.arm2.dataQuality.(d{:}).values,95);
        
        
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
    glycemicTransformationMetrics = {'gradeScore','gradeEuScore','gradeHyperScore','gradeHypoScore','hypoIndex','hyperIndex','igc','mrIndex'};
    
    for gt = glycemicTransformationMetrics
        
        %Preallocate
        results.arm1.glycemicTransformation.(gt{:}).values = zeros(length(arm1),1);
        results.arm2.glycemicTransformation.(gt{:}).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.glycemicTransformation.(gt{:}).values(g1) = feval(gt{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.glycemicTransformation.(gt{:}).values(g2) = feval(gt{:}, arm2{g2});
        end
        
        %Compute metrics stats
        results.arm1.glycemicTransformation.(gt{:}).mean = nanmean(results.arm1.glycemicTransformation.(gt{:}).values);
        results.arm2.glycemicTransformation.(gt{:}).mean = nanmean(results.arm2.glycemicTransformation.(gt{:}).values);
        
        results.arm1.glycemicTransformation.(gt{:}).std = nanstd(results.arm1.glycemicTransformation.(gt{:}).values);
        results.arm2.glycemicTransformation.(gt{:}).std = nanstd(results.arm2.glycemicTransformation.(gt{:}).values);
        
        results.arm1.glycemicTransformation.(gt{:}).median = nanmedian(results.arm1.glycemicTransformation.(gt{:}).values);
        results.arm2.glycemicTransformation.(gt{:}).median = nanmedian(results.arm2.glycemicTransformation.(gt{:}).values);
        
        results.arm1.glycemicTransformation.(gt{:}).prc5 = prctile(results.arm1.glycemicTransformation.(gt{:}).values,5);
        results.arm2.glycemicTransformation.(gt{:}).prc5 = prctile(results.arm2.glycemicTransformation.(gt{:}).values,5);
        results.arm1.glycemicTransformation.(gt{:}).prc25 = prctile(results.arm1.glycemicTransformation.(gt{:}).values,25);
        results.arm2.glycemicTransformation.(gt{:}).prc25 = prctile(results.arm2.glycemicTransformation.(gt{:}).values,25);
        results.arm1.glycemicTransformation.(gt{:}).prc75 = prctile(results.arm1.glycemicTransformation.(gt{:}).values,75);
        results.arm2.glycemicTransformation.(gt{:}).prc75 = prctile(results.arm2.glycemicTransformation.(gt{:}).values,75);
        results.arm1.glycemicTransformation.(gt{:}).prc95 = prctile(results.arm1.glycemicTransformation.(gt{:}).values,95);
        results.arm2.glycemicTransformation.(gt{:}).prc95 = prctile(results.arm2.glycemicTransformation.(gt{:}).values,95);
        
        
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
    eventMetrics = {'hyperglycemicEvents','hypoglycemicEvents','prolongedHypoglycemicEvents'};
    eventFunc = {'findHyperglycemicEvents','findHypoglycemicEvents','findProlongedHypoglycemicEvents'};
    for e = 1:length(eventMetrics)
        
        %Preallocate
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).values = zeros(length(arm1),1);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).values = zeros(length(arm1),1);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).values = zeros(length(arm2),1);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).values = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            r = feval(eventFunc{e}, arm1{g1});
            results.arm1.event.([eventMetrics{e} 'MeanDuration']).values(g1) = mean(r.duration);
            nDays = days(arm1{g1}.Time(end) - arm1{g1}.Time(1)); 
            results.arm1.event.([eventMetrics{e} 'PerWeek']).values(g1) = length(r.time)/(nDays)*7;
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            r = feval(eventFunc{e}, arm2{g2});
            results.arm2.event.([eventMetrics{e} 'MeanDuration']).values(g2) = mean(r.duration);
            nDays = days(arm2{g2}.Time(end) - arm2{g2}.Time(1)); 
            results.arm2.event.([eventMetrics{e} 'PerWeek']).values(g2) = length(r.time)/(nDays)*7;
        end
        
        %Compute metrics stats
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).mean = nanmean(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).mean = nanmean(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).mean = nanmean(results.arm1.event.([eventMetrics{e} 'PerWeek']).values);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).mean = nanmean(results.arm2.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).std = nanstd(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).std = nanstd(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).std = nanstd(results.arm1.event.([eventMetrics{e} 'PerWeek']).values);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).std = nanstd(results.arm2.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).median = nanmedian(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).median = nanmedian(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).median = nanmedian(results.arm1.event.([eventMetrics{e} 'PerWeek']).values);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).median = nanmedian(results.arm2.event.([eventMetrics{e} 'PerWeek']).values);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).prc5 = prctile(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values,5);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).prc5 = prctile(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values,5);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).prc5 = prctile(results.arm1.event.([eventMetrics{e} 'PerWeek']).values,5);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).prc5 = prctile(results.arm2.event.([eventMetrics{e} 'PerWeek']).values,5);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).prc25 = prctile(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values,25);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).prc25 = prctile(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values,25);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).prc25 = prctile(results.arm1.event.([eventMetrics{e} 'PerWeek']).values,25);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).prc25 = prctile(results.arm2.event.([eventMetrics{e} 'PerWeek']).values,25);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).prc75 = prctile(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values,75);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).prc75 = prctile(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values,75);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).prc75 = prctile(results.arm1.event.([eventMetrics{e} 'PerWeek']).values,75);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).prc75 = prctile(results.arm2.event.([eventMetrics{e} 'PerWeek']).values,75);
        
        results.arm1.event.([eventMetrics{e} 'MeanDuration']).prc95 = prctile(results.arm1.event.([eventMetrics{e} 'MeanDuration']).values,95);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']).prc95 = prctile(results.arm2.event.([eventMetrics{e} 'MeanDuration']).values,95);
        results.arm1.event.([eventMetrics{e} 'PerWeek']).prc95 = prctile(results.arm1.event.([eventMetrics{e} 'PerWeek']).values,95);
        results.arm2.event.([eventMetrics{e} 'PerWeek']).prc95 = prctile(results.arm2.event.([eventMetrics{e} 'PerWeek']).values,95);
        
        
        %Perform statistical tests
        res1 = results.arm1.event.([eventMetrics{e} 'MeanDuration']).values;
        res2 = results.arm2.event.([eventMetrics{e} 'MeanDuration']).values;
        
        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.event.([eventMetrics{e} 'MeanDuration']).h, stats.event.([eventMetrics{e} 'MeanDuration']).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.event.([eventMetrics{e} 'MeanDuration']).h, stats.event.([eventMetrics{e} 'MeanDuration']).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.event.([eventMetrics{e} 'MeanDuration']).p, stats.event.([eventMetrics{e} 'MeanDuration']).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.event.([eventMetrics{e} 'MeanDuration']).p, stats.event.([eventMetrics{e} 'MeanDuration']).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
        
        %Perform statistical tests
        res1 = results.arm1.event.([eventMetrics{e} 'PerWeek']).values;
        res2 = results.arm2.event.([eventMetrics{e} 'PerWeek']).values;
        
        if(sum(~isnan(res1)) < 4 || sum(~isnan(res2)) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
            if(isPaired)
                [stats.event.([eventMetrics{e} 'PerWeek']).h, stats.event.([eventMetrics{e} 'PerWeek']).p] = ttest(res1,res2,'Alpha',alpha);
            else
                [stats.event.([eventMetrics{e} 'PerWeek']).h, stats.event.([eventMetrics{e} 'PerWeek']).p] = ttest2(res1,res2,'Alpha',alpha);
            end
        else
            if(isPaired)
                [stats.event.([eventMetrics{e} 'PerWeek']).p, stats.event.([eventMetrics{e} 'PerWeek']).h] = signrank(res1,res2,'Alpha',alpha);
            else
                [stats.event.([eventMetrics{e} 'PerWeek']).p, stats.event.([eventMetrics{e} 'PerWeek']).h] = ranksum(res1,res2,'Alpha',alpha);
            end
        end
    end
    
end

