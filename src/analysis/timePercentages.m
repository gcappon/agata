function results = timePercentages(data)
%timePercentages function that computes the time percentages spent in the
%various glycemic zones.
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - results: a structure containing the results of the analysis with
%   fields:
%       - tHypo: percentage of time in hypoglycemia (i.e., <70 mg/dl);
%       - tHyper: percentage of time in hyperglycemia (i.e., >180 mg/dl);
%       - tTarget: percentage of time in target (i.e., [70-180 mg/dl]);
%       - tTightTarget: percentage of time in tight target (i.e., [90-140
%       mg/dl]);
%       - tSevereHypo: percentage of time in severe hypoglycemia (i.e., < 
%       50 mg/dl]); 
%       - tSevereHyper: percentage of time in severe hyperglycemia (i.e., > 
%       250 mg/dl]).
    
    N = height(data);
    
    results.tHypo = 100*sum(data.glucose < 70)/N;
    results.tHyper = 100*sum(data.glucose > 180)/N;
    results.tTarget = 100*sum(data.glucose >= 70 & data.glucose <= 180)/N;
    
    results.tTightTarget = 100*sum(data.glucose >=90 & data.glucose <= 140)/N;
    results.tSevereHypo = 100*sum(data.glucose < 50)/N;
    results.tSevereHyper = 100*sum(data.glucose > 250)/N;
    
end

