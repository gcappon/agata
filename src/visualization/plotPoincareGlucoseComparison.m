function plotPoincareGlucoseComparison(data1, data2, varargin)
%plotPoincareGlucose generates and compares the Poincare' plots of the
%(x,y) = (glucose(t-1),glucose(t)) graphs of two CGM profiles. 
%
%Input:
%   - data1: the first timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - data2: the second with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the plot or not. 
%
%Preconditions:
%   - `data1` and `data2` must be timetables.
%   - `data1` and `data2` must contain a column named `Time` and another named `glucose`.
%   - `PrintFigure` can be 0 or 1.
%
% ---------------------------------------------------------------------
%
% Reference:
%   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose
%   Monitor Data", Diabetes Technol Ther, 2009,
%   vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Input parser and check preconditions
    defaultPrintFigure = 0;

    params = inputParser;
    params.CaseSensitive = false;
    addRequired(params,'data1',@(x) validData(x));
    addRequired(params,'data2',@(x) validData(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data1,data2,varargin{:});

    printFigure = params.Results.PrintFigure;

    
    
    %Compute Poincare glucose
    poincare1 = poincareGlucose(data1);
    poincare2 = poincareGlucose(data2);
    
    % check if we need to plot an ellipse with it's axes.
    if (~isempty(poincare1) && ~isempty(poincare1.a) && ~isempty(poincare2) && ~isempty(poincare2.a))
        
        f = figure;

        hold on
    
        % rotation matrix to rotate the axes with respect to an angle phi
        R1 = [ cos(poincare1.phi) sin(poincare1.phi); -sin(poincare1.phi) cos(poincare1.phi) ];

        % the axes
        ver_line1        = [ [poincare1.X0 poincare1.X0]; poincare1.Y0+poincare1.b*[-1 1] ];
        horz_line1       = [ poincare1.X0+poincare1.a*[-1 1]; [poincare1.Y0 poincare1.Y0] ];
        new_ver_line1    = R1*ver_line1;
        new_horz_line1   = R1*horz_line1;

        % the ellipse
        theta_r1         = linspace(0,2*pi);
        ellipse_x_r1     = poincare1.X0 + poincare1.a*cos( theta_r1 );
        ellipse_y_r1     = poincare1.Y0 + poincare1.b*sin( theta_r1 );
        rotated_ellipse1 = R1 * [ellipse_x_r1;ellipse_y_r1];

        %plot data1
        x1 = data1.glucose(1:end-1);
        y1 = data1.glucose(2:end);
        sc(1) = scatter(x1,y1,100*ones(length(x1),1),'MarkerFaceColor',[50,205,50]/255);
        
        % draw
        plot( new_ver_line1(1,:),new_ver_line1(2,:),'k','linewidth',3 );
        plot( new_horz_line1(1,:),new_horz_line1(2,:),'k','linewidth',3 );
        plot( rotated_ellipse1(1,:),rotated_ellipse1(2,:),'k' ,'linewidth',3);
        
        % rotation matrix to rotate the axes with respect to an angle phi
        R2 = [ cos(poincare2.phi) sin(poincare2.phi); -sin(poincare2.phi) cos(poincare2.phi) ];

        % the axes
        ver_line2        = [ [poincare2.X0 poincare2.X0]; poincare2.Y0+poincare2.b*[-1 1] ];
        horz_line2       = [ poincare2.X0+poincare2.a*[-1 1]; [poincare2.Y0 poincare2.Y0] ];
        new_ver_line2    = R2*ver_line2;
        new_horz_line2   = R2*horz_line2;

        % the ellipse
        theta_r2         = linspace(0,2*pi);
        ellipse_x_r2     = poincare2.X0 + poincare2.a*cos( theta_r2 );
        ellipse_y_r2     = poincare2.Y0 + poincare2.b*sin( theta_r2 );
        rotated_ellipse2 = R2 * [ellipse_x_r2;ellipse_y_r2];

        %plot data2
        x2 = data2.glucose(1:end-1);
        y2 = data2.glucose(2:end);
        sc(2) = scatter(x2,y2,100*ones(length(x2),1),'MarkerFaceColor',[250,0,0]/255);
        
        
        % draw
        plot( new_ver_line2(1,:),new_ver_line2(2,:),'k','linewidth',3 );
        plot( new_horz_line2(1,:),new_horz_line2(2,:),'k','linewidth',3 );
        plot( rotated_ellipse2(1,:),rotated_ellipse2(2,:),'k' ,'linewidth',3);
        
        legend(sc,'data1','data2')
        
        ax = gca;
        
        set(ax,'FontSize',15)
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        
        xlim([0 400]);
        ylim([0 400]);
        
        xlabel('Glucose(t-1) (mg/dl)','FontWeight','bold','FontSize',20)
        ylabel('Glucose(t) (mg/dl)','FontWeight','bold','FontSize',18)
        
        title(['Poincare plot. a(1) = ' num2str(poincare1.a) ', b(1) = ' num2str(poincare1.b) ', a(2) = ' num2str(poincare2.a) ', b(2) = ' num2str(poincare2.b)],'FontWeight','bold','FontSize',18)
        
        
        grid on
        hold off
    end
    
    if(printFigure)
        print(f, '-dpdf', ['poincareGlucosePlot' '.pdf'],'-fillpage')
    end    
end

function valid = validData(data)
    %Input validator function handler 
    
    valid = istimetable(data);
    if(~valid)
        error('plotPoincareGlucose: data must be a timetable.');
    end
    
    valid = any(strcmp(fieldnames(data),'Time'));
    if(~valid)
        error('plotPoincareGlucose: data must have a column named `Time`.')
    end
    
    valid = any(strcmp(fieldnames(data),'glucose'));
    if(~valid)
        error('plotPoincareGlucose: data must have a column named `glucose`.')
    end
    
end