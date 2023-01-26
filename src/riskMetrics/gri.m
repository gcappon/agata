function gri = gri(data)
%gri function that computes the Glycemic Risk Index (GRI) proposed Klonoff 
%et al. (ignoring nan values). GRI seems to be rounded by the authors
%however it is not explicitly stated. Therefore, GRI is not rounded here.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - gri: the Glycemic Risk Indicator.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Klonoff et al., "A Glycemia Risk Index (GRI) of hypoglycemia and 
%   hyperglycemia for continuous glucose monitoring validated by clinician 
%   ratings", Journal of Diabetes Science and Technology, 2022, pp. 1-17.
%   DOI: 10.1177/19322968221085273.
%
% ------------------------------------------------------------------------
%
% Copyright (C) 2022 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('gri: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('gri: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('gri: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('gri: data must have a column named `glucose`.')
    end
    
    %Remove nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute metric
    vlow = timeInL2Hypoglycemia(data); % VLow (<54 mg/dL; <3.0 mmol/L)
    low = timeInL1Hypoglycemia(data); % Low (54–<70 mg/dL; 3.0–< 3.9 mmol/L)
    vhigh = timeInL2Hyperglycemia(data); % VHigh (>250 mg/dL; > 13.9 mmol/L)
    high = timeInL1Hyperglycemia(data); % High (>180–250 mg/dL; >10.0–13.9 mmol/L)
    gri = (3.0 * vlow) + (2.4 * low) + (1.6 * vhigh) + (0.8 * high);
    
    %Limit gri between 0-100
    gri = min([gri, 100]);
    
end

