function plotGlucose(data)
%plotGlucose function that visualizes the given data
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%
%Preconditions:
%   - `data` must be a timetable.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - None
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
            error('plotGlucose: data must be a timetable.');
        end
        
        if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
            fprintf('plotGlucose: data has not an homogeneous time grid. Retiming...')
            addpath(genpath(fullfile('..','processing')));
            data = retimeGlucose(data,round(minutes(data.Time(2)-data.Time(1))));
            fprintf('Done.\n')
        end
        f = figure;
        
        hold on
        
        %Hyper yellow area 
        hyperTop = max([data.glucose 180*ones(height(data),1)]');
        hyperBot = 180*ones(height(data),1)';
        plt.areaHyper = fill([data.Time', fliplr(data.Time')],[hyperBot fliplr(hyperTop)],'g',...
            'EdgeColor', 'none','FaceColor', [255,244,62]/255);

        %Hypo red area 
        hypoBot = min([data.glucose 70*ones(height(data),1)]');
        hypoTop = 70*ones(height(data),1)';
        plt.areaHyper = fill([data.Time', fliplr(data.Time')],[hypoBot fliplr(hypoTop)],'g',...
            'FaceColor',[243,32,50]/255,'EdgeColor', 'none');
        
        %Nan values
        dataNan = data;
        dataNan.glucose(isnan(data.glucose)) = 410;
        dataNan.glucose(~isnan(data.glucose)) =nan;
        plt.areaNan = area(dataNan.Time,dataNan.glucose,...
            'FaceColor',[255, 0, 0]/255,'EdgeColor','none','FaceAlpha',0.15);
        
        %Target gray area
        plt.area70180 = fill([data.Time(1) data.Time(end) data.Time(end) data.Time(1)],[70 70 180 180],'g',...
            'FaceColor',[199, 200, 202]/255,'EdgeColor','none','FaceAlpha',0.5);
        plt.line70 = plot([data.Time(1) data.Time(end)],[70 70],'--','linewidth',2,'Color',[77 189 109]/255);
        plt.line180 = plot([data.Time(1) data.Time(end)],[180 180],'--','linewidth',2,'Color',[77 189 109]/255);
        
        %Glucose trace
        plt.glucose = plot(data.Time,data.glucose,'k-o','linewidth',2);
        
        ax = gca;
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        datetick('x','HHPM')
        xlabel('Time','FontWeight','bold','FontSize',20)
        ylabel('Glucose (mg/dl)','FontWeight','bold','FontSize',18)
        
        xlim([data.Time(1) data.Time(end)])
        ylim([0 410]);
        grid on
        hold off

end