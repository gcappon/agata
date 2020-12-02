function plotGlucoseAsOneDay(data,varargin)
%plotGlucoseAsOneDay function that generates a plot of data in a
%single plot where each daily profile is overlapped to each other.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to each AGP or not. 
%
%Preconditions:
%   - `data` must be a timetable having an homogeneous time grid;
%   - `PrintFigure` can be 0 or 1.
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
    

    %Input parser and check preconditions
    defaultPrintFigure = 0;

    params = inputParser;
    params.CaseSensitive = false;
    validTimetable = @(x) istimetable(x) && (sum(strcmp(fieldnames(data),'Time'))==1) && ...
        (sum(strcmp(fieldnames(data),'glucose'))==1) && (length(unique(diff(data.Time)))==1);
    addRequired(params,'data',validTimetable);
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data,varargin{:});

    printFigure = params.Results.PrintFigure;

    
                    
        f =figure;


        %Generate the plot
        %data
        firstDay = data.Time(1);
        firstDay.Hour = 0;
        firstDay.Minute = 0;
        firstDay.Second = 0;

        lastDay = data.Time(end);
        lastDay.Hour = 0;
        lastDay.Minute = 0;
        lastDay.Second = 0;
        lastDay = lastDay + day(1);

        nDays = days(lastDay-firstDay);


        dataDaily = data((data.Time >= firstDay) & data.Time < (firstDay + day(1)),:);
        dummyTime = datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0):(data.Time(2)-data.Time(1)):datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0)+(minutes(1440)-(data.Time(2)-data.Time(1)));
        dummyData = timetable(randn(length(dummyTime),1),'VariableNames', {'glucose2'}, 'RowTimes', dummyTime);

        dataDaily = putOnTimegrid(dataDaily,dummyTime);
        dataDaily = synchronize(dataDaily,dummyData);
        dataDaily.glucose2 = [];

        dataMat = nan(length(dummyTime),nDays);
        dataMat(:,1) = dataDaily.glucose;


        for d = 2:nDays

            %Get the day of data
            dayData = data((data.Time >= firstDay + day(d-1)) & data.Time < (firstDay + day(d)),:);
            dayData.Time = dayData.Time-day(d-1);
            dayData.Properties.VariableNames{1} = ['glucose2']; 
            %dayData = retime(dayData,'regular','mean','TimeStep', data.Time(2)-data.Time(1));
            dayData = putOnTimegrid(dayData,dummyTime);
            dataDaily = synchronize(dataDaily,dayData);

            dataMat(:,d) = dataDaily.glucose2;
            dataDaily.glucose2 = [];

        end
        
        
        hold on
        
        %Target gray area
        plt.area70180 = fill([dummyTime(1) dummyTime(end) dummyTime(end) dummyTime(1)],[70 70 180 180],'g',...
            'FaceColor',[199, 200, 202]/255,'EdgeColor','none','FaceAlpha',0.5);
        
        
        agp.section.agp.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',5) fliplr(prctile(dataMat',95))],'g--');
        agp.section.agp.area595.FaceColor = [204, 219, 237]/255;
        agp.section.agp.area595.EdgeColor = [131, 165, 206]/255;
        agp.section.agp.area595.FaceAlpha = 0.5;
        agp.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',25) fliplr(prctile(dataMat',75))],'g');
        agp.section.agp.area2575.FaceColor = [131, 165, 206]/255;
        agp.section.agp.area2575.EdgeColor = [131, 165, 206]/255;
        agp.section.agp.area2575.FaceAlpha = 0.5;
        agp.section.agp.median = plot(dataDaily.Time,nanmedian(dataMat'),'k','linewidth',2);
        
        plt.line70 = plot([dummyTime(1) dummyTime(end)],[70 70],'--','linewidth',2,'Color',[77 189 109]/255);
        plt.line180 = plot([dummyTime(1) dummyTime(end)],[180 180],'--','linewidth',2,'Color',[77 189 109]/255);
        
        ax = gca;
        ax.XAxis.FontSize = 15;
        ax.YAxis.FontSize = 15;
        
        xlabel('Time','FontWeight','bold','FontSize',20)
        ylabel('Glucose (mg/dl)','FontWeight','bold','FontSize',18)
                
        set(gca,'FontWeight','bold');
        set(gca,'FontSize',15);
       
        hold off
        box on
        grid on;
        datetick('x','HHPM')
        ylim([0 410]);


        %Print the .pdf file
        if(printFigure)
            print(f, '-dpdf', ['glucoseAsOneDayPlot' '.pdf'],'-fillpage')
        end
    
    
end

function dataDaily = putOnTimegrid(dataDaily,dummyTime)
    
    for t = 1:height(dataDaily)
    
        d = abs(dataDaily.Time(t) - dummyTime);
        
        idx = find(min(d) == d,1,'first');
        
        dataDaily.Time(t) = dummyTime(idx);
    
    end

end

