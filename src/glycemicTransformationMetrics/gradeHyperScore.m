function gradeHyperScore = gradeHyperScore(data)
%gradeHyperScore function that computes glycemic risk assessment diabetes 
%equation score in the hyperglycemic range (GRADEhyper) by Hill (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - gradeHyperScore: the glycemic risk assessment diabetes 
%   equation score in the hyperglycemic range (GRADEhyper) (%).
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Hill et al., "A method for assessing quality of control from
%   glucose profiles", Diabetic Medicine , 2007, vol. 24, pp. 753-758.
%   DOI: 10.1111/j.1464-5491.2007.02119.x.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('gradeHyperScore: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('gradeHyperScore: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('gradeHyperScore: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('gradeHyperScore: data must have a column named `glucose`.')
    end
    
    
    %Get rid of nans
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute index
    grade = 425 * (log10(log10(nonNanGlucose/18)) + .16).^2;
    gTot = sum(grade);
    gradeHyperScore = 100 * sum(grade(nonNanGlucose > 180)) / gTot;

end

