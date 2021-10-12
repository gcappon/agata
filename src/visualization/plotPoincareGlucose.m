function plotPoincareGlucose(data, varargin)
%plotPoincareGlucose generates the Poincare' plot of the
%(x,y) = (glucose(t-1),glucose(t)) graph. 
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the plot or not.   
%
%Preconditions:
%   - `data` must be a timetable.
%   - `data` must contain a column named `Time` and another named `glucose`.
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
    addRequired(params,'data',@(x) validData(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data,varargin{:});

    printFigure = params.Results.PrintFigure;

    
    
    %Compute Poincare glucose
    poincare = poincareGlucose(data);
    
    % check if we need to plot an ellipse with it's axes.
    if (~isempty(poincare) && ~isempty(poincare.a))
        
        f = figure;

        hold on
    
        % rotation matrix to rotate the axes with respect to an angle phi
        R = [ cos(poincare.phi) sin(poincare.phi); -sin(poincare.phi) cos(poincare.phi) ];

        % the axes
        ver_line        = [ [poincare.X0 poincare.X0]; poincare.Y0+poincare.b*[-1 1] ];
        horz_line       = [ poincare.X0+poincare.a*[-1 1]; [poincare.Y0 poincare.Y0] ];
        new_ver_line    = R*ver_line;
        new_horz_line   = R*horz_line;

        % the ellipse
        theta_r         = linspace(0,2*pi);
        ellipse_x_r     = poincare.X0 + poincare.a*cos( theta_r );
        ellipse_y_r     = poincare.Y0 + poincare.b*sin( theta_r );
        rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];

        %plot data
        x = data.glucose(1:end-1);
        y = data.glucose(2:end);
        plt.data = scatter(x,y,100*ones(length(x),1),'MarkerFaceColor',[50,205,50]/255);
        
        % draw
        plot( new_ver_line(1,:),new_ver_line(2,:),'k','linewidth',3 );
        plot( new_horz_line(1,:),new_horz_line(2,:),'k','linewidth',3 );
        plot( rotated_ellipse(1,:),rotated_ellipse(2,:),'k' ,'linewidth',3);
        
        
        ax = gca;
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        
        xlim([0 400]);
        ylim([0 400]);
        
        xlabel('Glucose(t-1) (mg/dl)','FontWeight','bold','FontSize',20)
        ylabel('Glucose(t) (mg/dl)','FontWeight','bold','FontSize',18)
        
        title(['Poincare plot. a = ' num2str(poincare.a) ', b = ' num2str(poincare.b)],'FontWeight','bold','FontSize',18)
        
        
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