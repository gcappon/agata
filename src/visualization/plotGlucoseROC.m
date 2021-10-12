function plotGlucoseROC(data,varargin)
%plotGlucoseROC function that visualizes the glucose ROC of the given data
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose trace to which ROC has to be visualizes (in mg/dl);
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
%   - None
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
        
        maxROC = nanmax(roc.glucoseROC)+0.5;
        minROC = nanmin(roc.glucoseROC)-0.5;
        
        %Nan values
        dataNan = roc;
        dataNan.glucoseROC(isnan(roc.glucoseROC)) = maxROC;
        dataNan.glucoseROC(~isnan(roc.glucoseROC)) = nan;
        plt.areaNanPositive = area(dataNan.Time,dataNan.glucoseROC,...
            'FaceColor',[255, 0, 0]/255,'EdgeColor','none','FaceAlpha',0.30);
        dataNan = roc;
        dataNan.glucoseROC(isnan(roc.glucoseROC)) = minROC;
        dataNan.glucoseROC(~isnan(roc.glucoseROC)) = nan;
        plt.areaNanNegative = area(dataNan.Time,dataNan.glucoseROC,...
            'FaceColor',[255, 0, 0]/255,'EdgeColor','none','FaceAlpha',0.30);
        
        
        %Positive ROC area
        plt.positiveROC = fill([roc.Time(1) roc.Time(end) roc.Time(end) roc.Time(1)],[0 0 maxROC maxROC],'g',...
            'FaceColor',[199, 200, 202]/255,'EdgeColor','none','FaceAlpha',0.5);
        
        %Zero line
        plt.line0 = plot([roc.Time(1) roc.Time(end)],[0 0],'--','linewidth',2,'Color',[50, 50, 50]/255);
        
        %Glucose ROC trace
        plt.glucoseROC = plot(roc.Time,roc.glucoseROC,'k-o','linewidth',2);
        
        ax = gca;
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        xlabel('Time','FontWeight','bold','FontSize',20)
        ylabel('Glucose ROC (mg/dl/min)','FontWeight','bold','FontSize',18)
        
        xlim([roc.Time(1) roc.Time(end)])
        ylim([minROC maxROC]);
        grid on
        hold off

        if(printFigure)
            print(f, '-dpdf', ['glucoseROCPlot' '.pdf'],'-fillpage')
        end
        
end

function valid = validData(data)
    %Input validator function handler 
    
    valid = istimetable(data);
    if(~valid)
        error('plotGlucoseROC: data must be a timetable.');
    end
    
    valid = any(strcmp(fieldnames(data),'Time'));
    if(~valid)
        error('plotGlucoseROC: data must have a column named `Time`.')
    end
    
    valid = any(strcmp(fieldnames(data),'glucose'));
    if(~valid)
        error('plotGlucoseROC: data must have a column named `glucose`.')
    end
    
end