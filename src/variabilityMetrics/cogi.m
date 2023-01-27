function cogi = cogi(data)
%cogi function that computes the Continuous Glucose Monitoring Index (COGI)
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - cogi: the COGI index.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Leelaranthna et al., "Evaluating glucose control with a novel composite
%   Continuous Glucose Monitoring Index", Journal of Diabetes Science and Technology, 
%   2019, vol. 14, pp. 277-283. DOI: 10.1177/1932296819838525.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2023 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('cogi: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('cogi: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('cogi: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('cogi: data must have a column named `glucose`.')
    end
    
    %Compute TIR component
    tir = timeInTarget(data)*0.5;
    
    %Compute TBR component
    tbr = min([15 timeInHypoglycemia(data)]);
    tbr = (100 - 100/15*tbr)*0.35;
    
    %Compute GV component
    gv = min([max([stdGlucose(data)/18.018 1]) 6]);
    gv = (120 - 20*gv)*0.15;
    
    %Compute COGI
    cogi = tir + tbr + gv;
    
end

