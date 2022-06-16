function plotGRIComparison(glucoseProfilesArm1, glucoseProfilesArm2,varargin)
%plotGRIComparison function that plots and visually compares the GRI of two arms.
%
%Input:
%   - glucoseProfilesArm1: a cell array of timetables each with column `Time` and 
%   `glucose` containing the glucose data to analyze (in mg/dl) of arm 1. 
%   - glucoseProfilesArm2: a cell array of timetables each with column `Time` and 
%   `glucose` containing the glucose data to analyze (in mg/dl) of arm 2. 
%   - HighlightBest (optional, default: 1): A numerical flag 
%   defining whether to highlight the best GRI dot in the plot or not. 
%   Can be 0 or 1.
%   - FontSize (optional, default: 16): a scalar defining the font size of
%   the CVGA plot.
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the generated GRI. 
%
%Preconditions:
%   - glucoseProfilesArm1 must be a cell array containing timetables;
%   - glucoseProfilesArm2 must be a cell array containing timetables;
%   - Each timetable in glucoseProfiles must have a column names `Time` and a
%   column named `glucose`.
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
    
    %Input parser and check preconditions
    defaultHighlightBest = 1;
    defaultFontSize = 20;
    defaultPrintFigure = 0;
    
    params = inputParser;
    params.CaseSensitive = false;
    
    validScalar = @(x) isnumeric(x) && isscalar(x) && (x>=0);
    
    addRequired(params,'glucoseProfilesArm1',@(x) validGlucoseProfiles(x));
    addRequired(params,'glucoseProfilesArm2',@(x) validGlucoseProfiles(x));
    addOptional(params,'HighlightBest',defaultHighlightBest,@(x) x == 1 || x == 0);
    addOptional(params,'FontSize',defaultFontSize,validScalar);
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    
    parse(params,glucoseProfilesArm1,glucoseProfilesArm2,varargin{:});
    
    highlightBest=params.Results.HighlightBest;
    fontSize=params.Results.FontSize;
    printFigure = params.Results.PrintFigure;
    
    %Add time functions to path
    addpath(genpath(fullfile('..','time')));

    %Zone coordinates and colors
    x = [20:20:100]/3;
    y = [20:20:100]/1.6; 
    c = [118, 245, 251, 232, 196; 
        183, 240, 202, 110, 136;
        114, 122, 116, 113, 134]/255;
   
    figure;
    hold on
    
    %fill zones
    zones{1} = fill([0 x(1) 0 0],[0 0 y(1) 0],c(:,1)');
    zones{2} = fill([x(1) x(2) 0 0],[0 0 y(2) y(1)],c(:,2)');
    zones{3} = fill([x(2) x(3) 0 0],[0 0 y(3) y(2)],c(:,3)');
    zones{4} = fill([x(3) x(4) 0 0],[0 0 y(4) y(3)],c(:,4)');
    zones{5} = fill([x(4) x(5) 0 0],[0 0 y(5) y(4)],c(:,5)');
    axis([0 x(5) 0 y(5)]);
    box on
    
    hypoComponentsArm1 = zeros(length(glucoseProfilesArm1),1);
    hyperComponentsArm1 = zeros(length(glucoseProfilesArm1),1);
    grisArm1 = zeros(length(glucoseProfilesArm1),1);
    for gp = 1:length(glucoseProfilesArm1)
        
        vlow = timeInSevereHypoglycemia(glucoseProfilesArm1{gp}); % VLow (<54 mg/dL; <3.0 mmol/L)
        low = timeInHypoglycemia(glucoseProfilesArm1{gp}) - vlow; % Low (54–<70 mg/dL; 3.0–< 3.9 mmol/L)
        vhigh = timeInSevereHyperglycemia(glucoseProfilesArm1{gp}); % VHigh (>250 mg/dL; > 13.9 mmol/L)
        high = timeInHyperglycemia(glucoseProfilesArm1{gp}) - vhigh; % High (>180–250 mg/dL; >10.0–13.9 mmol/L)
        hypoComponentsArm1(gp) = vlow + (0.8*low);
        hyperComponentsArm1(gp) = vhigh + (0.5*high);
        grisArm1(gp) = (3.0 * vlow) + (2.4 * low) + (1.6 * vhigh) + (0.8 * high);
        scatter(hypoComponentsArm1(gp),hyperComponentsArm1(gp),50,[0 0 0],'filled');
        
    end
    
    hypoComponentsArm2 = zeros(length(glucoseProfilesArm2),1);
    hyperComponentsArm2 = zeros(length(glucoseProfilesArm2),1);
    grisArm2 = zeros(length(glucoseProfilesArm2),1);
    for gp = 1:length(glucoseProfilesArm2)
        
        vlow = timeInSevereHypoglycemia(glucoseProfilesArm2{gp}); % VLow (<54 mg/dL; <3.0 mmol/L)
        low = timeInHypoglycemia(glucoseProfilesArm2{gp}) - vlow; % Low (54–<70 mg/dL; 3.0–< 3.9 mmol/L)
        vhigh = timeInSevereHyperglycemia(glucoseProfilesArm2{gp}); % VHigh (>250 mg/dL; > 13.9 mmol/L)
        high = timeInHyperglycemia(glucoseProfilesArm2{gp}) - vhigh; % High (>180–250 mg/dL; >10.0–13.9 mmol/L)
        hypoComponentsArm2(gp) = vlow + (0.8*low);
        hyperComponentsArm2(gp) = vhigh + (0.5*high);
        grisArm2(gp) = (3.0 * vlow) + (2.4 * low) + (1.6 * vhigh) + (0.8 * high);
        scatter(hypoComponentsArm2(gp),hyperComponentsArm2(gp),50,[0.3 0.3 0.3],'filled','d');
        
    end
    
    %Highlight best profile if requested
    if ~isempty(glucoseProfilesArm1) && highlightBest
        idx = find(grisArm1 == min(grisArm1),1,'first');
        zones{6} = scatter(hypoComponentsArm1(idx),hyperComponentsArm1(idx),150,[0 0 0]);
    end
    if ~isempty(glucoseProfilesArm2) && highlightBest
        idx = find(grisArm2 == min(grisArm2),1,'first');
        zones{7} = scatter(hypoComponentsArm2(idx),hyperComponentsArm2(idx),150,[0 0 0],'d');
    end

    xlabel('Hypoglycemia component (%)','Fontsize',fontSize,'FontWeight','bold')
    ylabel('Hyperglycemia component (%)','Fontsize',fontSize,'FontWeight','bold')
    set(gca,'FontSize',fontSize)
    
    legend([zones{1} zones{2} zones{3} zones{4} zones{5} zones{6} zones{7}],'Zone A (0-20)','Zone B (21-40)', 'Zone C (41-60)', 'Zone D (61-80)', 'Zone E (81-100)','Best GRI (Arm 1)','Best GRI (Arm 2)');
    
    if(printFigure)
            print(f, '-dpdf', ['GRI.pdf'],'-fillpage')
    end
        
end




function valid = validGlucoseProfiles(glucoseProfiles)

    valid = iscell(glucoseProfiles);
    
    if(~valid)
        error('plotCVGA: glucoseProfiles must be a cell array.');
    end
    
    
    for g = 1:length(glucoseProfiles)
       
        valid = valid && istimetable(glucoseProfiles{g});
        
        if(~valid)
            error(['plotCVGA: glucoseProfiles in position ' num2str(g) ' must be a timetable.']);
        end

        
        valid = valid && any(strcmp(fieldnames(glucoseProfiles{g}),'glucose'));

        if(~valid)
            error(['plotCVGA: glucoseProfile in position ' num2str(g) ' must contain a column named glucose.']);
        end

        valid = valid && any(strcmp(fieldnames(glucoseProfiles{g}),'Time'));

        if(~valid)
            error(['plotCVGA: glucoseProfile in position ' num2str(g) ' must contain a column named glucose.']);
        end
        
    end
    
end