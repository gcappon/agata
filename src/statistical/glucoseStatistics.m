function results = glucoseStatistics(data)
%glucoseStatistics function that computes the statistical indices of the
%given glucose trace (ignores nan values).
%
%Input:
%   - data: a timeseries containing the glucose data to analyze (in mg/dl). 
%Output:
%   - results: a structure containing the results of the analysis with
%   fields:
%       - mean: mean glucose concentration;
%       - std: standard deviation of glucose concentration;
%       - cv: coefficient of variation of glucose concentration;
%       - median: median glucose concentration;
%       - range: glucose concentration range; 
%       - iqr: interquartile range of glucose concentration;
%       - jIndex: j-index of glucose concentration.
    
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    results.mean = mean(nonNanGlucose);
    results.std = std(nonNanGlucose);
    results.cv = 100 * results.std / results.mean;
    results.median = median(nonNanGlucose);
    results.range = max(nonNanGlucose) - min(nonNanGlucose);
    results.iqr = iqr(nonNanGlucose);
    results.jIndex = 1e-3 * (results.mean + results.std) ^ 2;
    
end

