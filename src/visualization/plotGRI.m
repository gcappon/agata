function plotGRI(glucoseProfiles,varargin)
%plotCVGA function that plots the GRI grid.
%
%Input:
%   - glucoseProfiles: a cell array of timetables each with column `Time` and 
%   `glucose` containing the glucose data to analyze (in mg/dl). 
%   - HighlightBest (optional, default: 1): A numerical flag 
%   defining whether to highlight the best GRI dot in the plot or not. 
%   Can be 0 or 1.
%   - FontSize (optional, default: 16): a scalar defining the font size of
%   the CVGA plot.
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the generated GRI. 
%
%Preconditions:
%   - glucoseProfiles must be a cell array containing timetables;
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
    
    addRequired(params,'glucoseProfiles',@(x) validGlucoseProfiles(x));
    addOptional(params,'HighlightBest',defaultHighlightBest,@(x) x == 1 || x == 0);
    addOptional(params,'FontSize',defaultFontSize,validScalar);
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    
    parse(params,glucoseProfiles,varargin{:});
    
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
    
    hypoComponents = zeros(length(glucoseProfiles),1);
    hyperComponents = zeros(length(glucoseProfiles),1);
    gris = zeros(length(glucoseProfiles),1);
    for gp = 1:length(glucoseProfiles)
        
        vlow = timeInSevereHypoglycemia(glucoseProfiles{gp}); % VLow (<54 mg/dL; <3.0 mmol/L)
        low = timeInHypoglycemia(glucoseProfiles{gp}); % Low (54–<70 mg/dL; 3.0–< 3.9 mmol/L)
        vhigh = timeInSevereHyperglycemia(glucoseProfiles{gp}); % VHigh (>250 mg/dL; > 13.9 mmol/L)
        high = timeInHyperglycemia(glucoseProfiles{gp}); % High (>180–250 mg/dL; >10.0–13.9 mmol/L)
        hypoComponents(gp) = vlow + (0.8*low);
        hyperComponents(gp) = vhigh + (0.5*high);
        gris(gp) = (3.0 * vlow) + (2.4 * low) + (1.6 * vhigh) + (0.8 * high);
        scatter(hypoComponents(gp),hyperComponents(gp),50,[0 0 0],'filled');
        
    end
    
    
    %Highlight best profile if requested
    if ~isempty(glucoseProfiles)&& highlightBest
        idx = find(gris == min(gris),1,'first');
        zones{6} = scatter(hypoComponents(idx),hyperComponents(idx),150,[0 0 0]);
    end

    xlabel('Hypoglycemia component (%)','Fontsize',fontSize,'FontWeight','bold')
    ylabel('Hyperglycemia component (%)','Fontsize',fontSize,'FontWeight','bold')
    set(gca,'FontSize',fontSize)
    
    legend([zones{1} zones{2} zones{3} zones{4} zones{5} zones{6}],'Zone A (0-20)','Zone B (21-40)', 'Zone C (41-60)', 'Zone D (61-80)', 'Zone E (81-100)','Best GRI');
    
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