function plotCVGAComparison(glucoseProfilesArm1,glucoseProfilesArm2,varargin)
%plotCVGA function that plots the control variablity grid analysis (CVGA).
%
%Input:
%   - glucoseProfiles: a cell array of timetables each with column `Time` and 
%   `glucose` containing the glucose data to analyze (in mg/dl). 
%   - PlotZoneNames (optional, default: 1): a numerical flag defining whether to 
%   plot the zone names in the CVGA plot or not. Can be 0 or 1.
%   - HighlightBestControl (optional, default: 1): a numerical flag defining whether to 
%   highlight the best controlled profile in the CVGA plot or not. Can be 0 or 1.
%   - FontSize (optional, default: 16): a scalar defining the font size of
%   the CVGA plot.
%
%Preconditions:
%   - glucoseProfiles must be a cell array containing timetables;
%   - Each timetable in glucoseProfiles must have a column names `Time` and a
%   column named `glucose`.
%
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - Magni et al., "Evaluating the efficacy of closed-loop glucose 
%  regulation via control-variability grid analysis", Journal of Diabetes 
%  Science and Technology, 2008, vol. 2, pp. 630-635. DOI:
%  10.1177/193229680800200414.
%
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Simone Del Favero
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Input parser and check preconditions
    defaultPlotZoneNames = 1;
    defaultHighlightBestControl = 1;
    defaultFontSize = 16;

    params = inputParser;
    params.CaseSensitive = false;
    
    validScalar = @(x) isnumeric(x) && isscalar(x) && (x>=0);
    
    addRequired(params,'glucoseProfilesArm1',@(x) validGlucoseProfiles(x));
    addRequired(params,'glucoseProfilesArm2',@(x) validGlucoseProfiles(x));
    addParameter(params,'PlotZoneNames',defaultPlotZoneNames,@(x) x == 1 || x == 0);
    addOptional(params,'HighlightBestControl',defaultHighlightBestControl,@(x) x == 1 || x == 0);
    addOptional(params,'FontSize',defaultFontSize,validScalar);

    parse(params,glucoseProfilesArm1,glucoseProfilesArm2,varargin{:});
    
    plotZoneNames=params.Results.PlotZoneNames;
    highlightBestControl=params.Results.HighlightBestControl;
    fontSize=params.Results.FontSize;
    
    %Add CVGA function to path
    addpath(genpath(fullfile('..','variabilityMetrics')));
    
    %Compute CVGA for each profile
    [~,profileCoordinates1,~,bestControlledCoordinates1]=CVGA(glucoseProfilesArm1);
    
    
    %Compute CVGA for each profile
    [~,profileCoordinates2,~,bestControlledCoordinates2]=CVGA(glucoseProfilesArm2);

    %Circle radius
    r=[20 40 60];
    Vcolor=[0 1 0;...                   %A
            7/255 135/255 0/255;        %B
            1 1 0;                      %C
            1 0 0];                     %D

    figure;
    hold on
    
    %fill zone D
    fill([0 60 60 0],[0 0 60 60],Vcolor(end,:));
    
    %fill zone C, B, A
    for index=3:-1:1
        
        x=r(index):-r(index)/10000:0;
        y=sqrt(r(index)^2-x.^2);
        plot(x,y,'k');
        fill([x 0],[y 0],Vcolor(index,:))
        
    end

    %Plot zone names if requested
    if plotZoneNames
        text(8,8,'A','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold','FontWeight','bold');
        text(10,30,'Upper B','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
        text(10,50,'Upper C','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
        text(30,10,'Lower B','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
        text(35,35,'C','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
        text(50,10,'Lower C','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
        text(50,50,'D','HorizontalAlignment','center','Fontsize',fontSize,'FontWeight','bold');
    end
    
    %Plot each profile
    if ~isempty(glucoseProfilesArm1)
        plot(profileCoordinates1(:,1),profileCoordinates1(:,2),'.k','MarkerSize',18)
    end
    %Plot each profile
    if ~isempty(glucoseProfilesArm2)
        plot(profileCoordinates2(:,1),profileCoordinates2(:,2),'.b','MarkerSize',18)
    end

    %Highlight best profile if requested
    if ~isempty(glucoseProfilesArm1)&& highlightBestControl
        plot(bestControlledCoordinates1(1),bestControlledCoordinates1(2),'or','MarkerSize',18)
    end
    
    %Highlight best profile if requested
    if ~isempty(glucoseProfilesArm2)&& highlightBestControl
        plot(bestControlledCoordinates2(1),bestControlledCoordinates2(2),'or','MarkerSize',18)
    end

    xlabel('Minimum BG','Fontsize',fontSize,'FontWeight','bold')
    set(gca,'FontSize',fontSize-2)
    set(gca,'XTick',[0 20 40 60],'XTickLabel',{'>110' '90' '70' '<50'})
    
    ylabel('Maximum BG','Fontsize',fontSize,'FontWeight','bold')
    set(gca,'YTick',[0 20 40 60],'YTickLabel',{'<110' '180' '300' '>400'})
    axis equal;
    axis([0 60 0 60]);
    box on
    
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