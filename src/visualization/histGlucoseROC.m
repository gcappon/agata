function histGlucoseROC(data,varargin)
%histGlucoseROC function that visualizes the  histogram of the glucose ROC 
%of the given data
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose trace to which ROC histogram has to be visualizes (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the figure or not. 
%
%Preconditions:
%   - `data` must be a timetable.
%   - `data` must contain a column named `Time` and another named `glucose`.
%   - `PrintFigure` can be 0 or 1.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
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
        
        f = figure;
        
        hold on
        
        %Compute glucose ROC
        roc = glucoseROC(data);
        
        %Plot the histogram + it's fitted Gaussian distribution
        plt.histogram = histfit(roc.glucoseROC);
        
        ax = gca;
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        xlabel('Glucose ROC (mg/dl/min)','FontWeight','bold','FontSize',20)
        ylabel('Absolute frequency','FontWeight','bold','FontSize',18)
        
        title(['SD = ' num2str(stdGlucoseROC(data)) 'mg/dl/min'],'FontWeight','bold','FontSize',18)
        
        
        grid on
        hold off

        if(printFigure)
            print(f, '-dpdf', ['glucoseROCHistogram' '.pdf'],'-fillpage')
        end
        
end

function valid = validData(data)
    %Input validator function handler 
    
    valid = istimetable(data);
    if(~valid)
        error('histGlucoseROC: data must be a timetable.');
    end
    
    valid = any(strcmp(fieldnames(data),'Time'));
    if(~valid)
        error('histGlucoseROC: data must have a column named `Time`.')
    end
    
    valid = any(strcmp(fieldnames(data),'glucose'));
    if(~valid)
        error('histGlucoseROC: data must have a column named `glucose`.')
    end
    
end