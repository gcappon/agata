function plotClarkeErrorGrid(data,dataHat,printFigure)
% clarke function that plots the Clarke Error Grid.
%
% Inputs: 
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - dataHat: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`;
%   - printFigure: a numerical flag defining whether to print the produced
%   plot on a .pdf file or not.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - dataHat must be a timetable having an homogeneous time grid;
%   - data and dataHat must start from the same timestamp;
%   - data and dataHat must end with the same timestamp;
%   - data and dataHat must have the same length;
%   - data and dataHat must contain a column `Time` and a column `glucose`;
%   - printFigure must be 0 or 1.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Clarke et al., "Evaluating clinical accuracy of systems for 
%   self-monitoring of blood glucose", Diabetes Care, 1987, vol. 10, pp. 
%   622–628. DOI: 10.2337/diacare.10.5.622.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Check preconditions 
    if(~istimetable(data))
        error('plotClarkeErrorGrid: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('plotClarkeErrorGrid: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('plotClarkeErrorGrid: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('plotClarkeErrorGrid: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('plotClarkeErrorGrid: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('plotClarkeErrorGrid: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('plotClarkeErrorGrid: data and dataHat must have the same length.')
    end
    
    
    
    h = figure;
    plot(data.glucose, dataHat.glucose,'ko','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
    xlabel('Reference Concentration [mg/dl]');
    ylabel ('Predicted Concentration [mg/dl]');
    title('Clarke''s Error Grid Analysis');
    set(gca,'XLim',[0 400]);
    set(gca,'YLim',[0 400]);
    axis square
    hold on
    plot([0 400],[0 400],'k:')                  % Theoretical 45 degrees regression line
    plot([0 175/3],[70 70],'k-')
    % plot([175/3 320],[70 400],'k-')
    plot([175/3 400/1.2],[70 400],'k-')         % replace 320 with 400/1.2 because 100*(400 - 400/1.2)/(400/1.2) =  20% error
    plot([70 70],[84 400],'k-')
    plot([0 70],[180 180],'k-')
    plot([70 290],[180 400],'k-')               % Corrected upper B-C boundary
    % plot([70 70],[0 175/3],'k-')
    plot([70 70],[0 56],'k-')                   % replace 175.3 with 56 because 100*abs(56-70)/70) = 20% error
    % plot([70 400],[175/3 320],'k-')
    plot([70 400],[56 320],'k-')
    plot([180 180],[0 70],'k-')
    plot([180 400],[70 70],'k-')
    plot([240 240],[70 180],'k-')
    plot([240 400],[180 180],'k-')
    plot([130 180],[0 70],'k-')                 % Lower B-C boundary slope OK
    text(30,20,'A','FontSize',12);
    text(30,150,'D','FontSize',12);
    text(30,380,'E','FontSize',12);
    text(150,380,'C','FontSize',12);
    text(160,20,'C','FontSize',12);
    text(380,20,'E','FontSize',12);
    text(380,120,'D','FontSize',12);
    text(380,260,'B','FontSize',12);
    text(280,380,'B','FontSize',12);
    set(h, 'color', 'white');                   % sets the color to white 
    % Specify window units
    set(h, 'units', 'inches')
    % Change figure and paper size (Fixed to 3x3 in)
    set(h, 'Position', [0.1 0.1 3 3])
    set(h, 'PaperPosition', [0.1 0.1 3 3])
    if printFigure
        print(h, '-dpdf', 'clarkeErrorGrid.pdf','-fillpage')
    end
    
end