function hyperIndex = hyperIndex(data)
%hyperIndex function that computes the hyperglycemic index by Rodbard (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - hyperIndex: the hyperglycemic index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - Rodbard et al., "Interpretation of continuous glucose monitoring
%  data: glycemic variability and quality of glycemic control", Diabetes 
%  Technology & Therapeutics, 2009, vol. 11, pp. S55-S67. DOI: 10.1089/dia.2008.0132.
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
        error('hyperIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('hyperIndex: data must have a homogeneous time grid.')
    end
    
    
    %Get rid of nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Setup the formula parameters
    A = 1.1;
    C = 30;
    ultr = 180;
    
    %Computation of the index
    hyperIndex = sum((nonNanGlucose(nonNanGlucose > ultr) - ultr).^A) / (length(nonNanGlucose)*C);

end

