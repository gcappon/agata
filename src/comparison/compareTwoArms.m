function [results, stats] = compareTwoArms(arm1,arm2,isPaired,alpha)
%compareTwoArms function that compares the glycemic outcomes of two arms
%
%Inputs:
%   - arm1: a cell array of timetables containing the glucose data of the 
%   first arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and  a column `glucose` containg the glucose 
%   recordings (in mg/dl);
%   - arm2: a cell array of timetables containing the glucose data of the 
%   second arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and  a column `glucose` containg the glucose 
%   recordings (in mg/dl);
%   - isPaired: A numeric flag defining whether to run paired or unpaired 
%   analysis. Commonly paired tests are performed when data of the same 
%   patients are present in both arms, unpaired otherwise;
%   - alpha: a double representing the significance level to use.
%Output:
%   - results: a structure with field `arm1` and `arm2`, that are two 
%   structures containing the computed metrics in the two arms, i.e.:
%       - variabilityMetrics: {'aucGlucose','CVGA','cvGlucose','efIndex','gmi','iqrGlucose',
%        'jIndex','mageIndex','magePlusIndex','mageMinusIndex','meanGlucose','medianGlucose',
%        'rangeGlucose','sddmIndex','sdwIndex','stdGlucose'};
%       - riskMetrics: {'adrr','bgri','hbgi','lbgi'};
%       - timeMetrics: {'timeInHyperglycemia','timeInSevereHyperglycemia',
%       'timeInHypoglycemia','timeInSevereHypoglycemia','timeInTarget','timeInTightTarget'};
%       - glycemicTransformationMetrics = {'gradeScore','gradeEuScore',
%       'gradeHyperScore','gradeHypoScore','hypoIndex','hyperIndex','igc','mrIndex'};
%       - eventMetrics: {'hyperglycemicEvents','hypoglycemicEvents','prolongedHypoglycemicEvents'};
%   - stats: a structure that contains for each of the considered metrics
%   the result of the statistical test with field `p` (p-value value) and
%   `h` null hypothesis accepted or rejcted. Statistical tests are: t-test
%   if the test `isPaired` and the samples are both gaussian distributed (checked 
%   with lillietest), unpaired t-test if the test not `isPaired` and the 
%   samples are both gaussian distributed (checked with lillietest),
%   Wilcoxon rank test if the test `isPaired` and at least one of the 
%   samples is not gaussian distributed (checked with lillietest), 
%   Mann-Whitney U-test if the test not `isPaired` and at least one of the 
%   samples is not gaussian distributed (checked with lillietest).
%Preconditions:
%   - arm1 must be a cell array containing timetables;
%   - arm2 must be a cell array containing timetables;
%   - Each timetable in arm1 and arm2 must have a column names `Time` and a
%   column named `glucose`.
%   - Each timetable in arm1 and arm2 must have an homogeneous time grid;
%   - isPaired can be 0 or 1.
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
        'rangeGlucose','sddmIndex','sdwIndex','stdGlucose'};
    
    for v = variabilityMetrics
        
        %Preallocate
        results.arm1.variability.(v{:}) = zeros(length(arm1),1);
        results.arm2.variability.(v{:}) = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.variability.(v{:})(g1) = feval(v{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.variability.(v{:})(g2) = feval(v{:}, arm2{g2});
        end
        
        %Perform statistical tests
        res1 = results.arm1.variability.(v{:});
        res2 = results.arm2.variability.(v{:});

        if(length(arm1) < 4 || length(arm2) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
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
    riskMetrics = {'adrr','bgri','hbgi','lbgi'};
    
    for r = riskMetrics
        
        %Preallocate
        results.arm1.risk.(r{:}) = zeros(length(arm1),1);
        results.arm2.risk.(r{:}) = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.risk.(r{:})(g1) = feval(r{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.risk.(r{:})(g2) = feval(r{:}, arm2{g2});
        end
        
        %Perform statistical tests
        res1 = results.arm1.risk.(r{:});
        res2 = results.arm2.risk.(r{:});

        if(length(arm1) < 4 || length(arm2) < 4 ||  (~lillietest(res1) && ~lillietest(res2)))
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
        results.arm1.time.(t{:}) = zeros(length(arm1),1);
        results.arm2.time.(t{:}) = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.time.(t{:})(g1) = feval(t{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.time.(t{:})(g2) = feval(t{:}, arm2{g2});
        end
        
        %Perform statistical tests
        res1 = results.arm1.time.(t{:});
        res2 = results.arm2.time.(t{:});

        if(length(arm1) < 4 || length(arm2) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
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
    
    
    %Glycemic transformation metrics
    glycemicTransformationMetrics = {'gradeScore','gradeEuScore','gradeHyperScore','gradeHypoScore','hypoIndex','hyperIndex','igc','mrIndex'};
    
    for gt = glycemicTransformationMetrics
        
        %Preallocate
        results.arm1.glycemicTransformation.(gt{:}) = zeros(length(arm1),1);
        results.arm2.glycemicTransformation.(gt{:}) = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            results.arm1.glycemicTransformation.(gt{:})(g1) = feval(gt{:}, arm1{g1});
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            results.arm2.glycemicTransformation.(gt{:})(g2) = feval(gt{:}, arm2{g2});
        end
        
        %Perform statistical tests
        res1 = results.arm1.glycemicTransformation.(gt{:});
        res2 = results.arm2.glycemicTransformation.(gt{:});

        if(length(arm1) < 4 || length(arm2) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
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
        results.arm1.event.([eventMetrics{e} 'MeanDuration']) = zeros(length(arm1),1);
        results.arm1.event.([eventMetrics{e} 'PerWeek']) = zeros(length(arm1),1);
        results.arm2.event.([eventMetrics{e} 'MeanDuration']) = zeros(length(arm2),1);
        results.arm2.event.([eventMetrics{e} 'PerWeek']) = zeros(length(arm2),1);
        
        %Compute metrics for arm1
        for g1 = 1:length(arm1)
            r = feval(eventFunc{e}, arm1{g1});
            results.arm1.event.([eventMetrics{e} 'MeanDuration'])(g1) = mean(r.duration);
            results.arm1.event.([eventMetrics{e} 'PerWeek'])(g2) = length(r.time)/7;
        end
        
        %Compute metrics for arm2
        for g2 = 1:length(arm2)
            r = feval(eventFunc{e}, arm2{g2});
            results.arm2.event.([eventMetrics{e} 'MeanDuration'])(g2) = mean(r.duration);
            results.arm2.event.([eventMetrics{e} 'PerWeek'])(g2) = length(r.time)/7;
        end
        
        %Perform statistical tests
        res1 = results.arm1.event.([eventMetrics{e} 'MeanDuration']);
        res2 = results.arm2.event.([eventMetrics{e} 'MeanDuration']);
        
        if(length(arm1) < 4 || length(arm2) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
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
        res1 = results.arm1.event.([eventMetrics{e} 'PerWeek']);
        res2 = results.arm2.event.([eventMetrics{e} 'PerWeek']);
        
        if(length(arm1) < 4 || length(arm2) < 4 ||  ~lillietest(res1) && ~lillietest(res2))
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

