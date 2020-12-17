function plotGlucoseAsOneDayComparison(data1,data2,varargin)
%plotGlucoseAsOneDayComparison function that generates a plot of two dataset in a
%single plot where each daily profile is overlapped to each other. This is
%for comparison.
%
%Inputs:
%   - data1: a timetable with column `Time` and `glucose` containing the 
%   first set of glucose data to analyze (in mg/dl);
%   - data2: a timetable with column `Time` and `glucose` containing the 
%   second set of glucose data to analyze (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to each AGP or not. 
%
%Preconditions:
%   - data1 and data2 must be a timetable having an homogeneous time grid;
%   - data1 and data2 must contain a column named `Time` and another named `glucose`;
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
    addRequired(params,'data1',@(x) validData(x));
    addRequired(params,'data2',@(x) validData(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data1,data2,varargin{:});

    printFigure = params.Results.PrintFigure;
    
    
    data1.Time = data1.Time-data1.Time(1);
    data1.Time = datetime(2000,1,1,0,0,0) + data1.Time; 
    data2.Time = data2.Time-data2.Time(1);  
    data2.Time = datetime(2000,1,1,0,0,0) + data2.Time; 
    
    f =figure;
    hold on;

    %Generate the plot of data1
    firstDay = data1.Time(1);
    firstDay.Hour = 0;
    firstDay.Minute = 0;
    firstDay.Second = 0;

    lastDay = data1.Time(end);
    lastDay.Hour = 0;
    lastDay.Minute = 0;
    lastDay.Second = 0;
    lastDay = lastDay + day(1);

    nDays = days(lastDay-firstDay);

    dataDaily = data1((data1.Time >= firstDay) & data1.Time < (firstDay + day(1)),:);
    dummyTime = datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0):(data1.Time(2)-data1.Time(1)):datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0)+(minutes(1440)-(data1.Time(2)-data1.Time(1)));
    dummyData = timetable(randn(length(dummyTime),1),'VariableNames', {'glucose2'}, 'RowTimes', dummyTime);

    dataDaily = putOnTimegrid(dataDaily,dummyTime);
    dataDaily = synchronize(dataDaily,dummyData);
    dataDaily.glucose2 = [];

    dataMat = nan(length(dummyTime),nDays);
    dataMat(:,1) = dataDaily.glucose;

    for d = 2:nDays

        %Get the day of data
        dayData = data1((data1.Time >= firstDay + day(d-1)) & data1.Time < (firstDay + day(d)),:);
        dayData.Time = dayData.Time-day(d-1);
        dayData.Properties.VariableNames{1} = ['glucose2']; 
        %dayData = retime(dayData,'regular','mean','TimeStep', data.Time(2)-data.Time(1));
        dayData = putOnTimegrid(dayData,dummyTime);
        dataDaily = synchronize(dataDaily,dayData);

        dataMat(:,d) = dataDaily.glucose2;
        dataDaily.glucose2 = [];

    end
        
        
    plt1.area70180 = fill([dummyTime(1) dummyTime(end) dummyTime(end) dummyTime(1)],[70 70 180 180],'g',...
        'FaceColor',[199, 200, 202]/255,'EdgeColor','none','FaceAlpha',0.5);
        
        
    plt1.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',5) fliplr(prctile(dataMat',95))],'g--',...
            'FaceColor',[204, 219, 237]/255, 'EdgeColor', [131, 165, 206]/255, 'FaceAlpha', 0.5);
    plt1.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',25) fliplr(prctile(dataMat',75))],'g',...
            'FaceColor',[131, 165, 206]/255, 'EdgeColor', [131, 165, 206]/255, 'FaceAlpha',0.5);
        
    plt1.median = plot(dataDaily.Time,nanmedian(dataMat'),'b','linewidth',2);
        
    %Generate the plot of data2
    firstDay = data2.Time(1);
    firstDay.Hour = 0;
    firstDay.Minute = 0;
    firstDay.Second = 0;

    lastDay = data2.Time(end);
    lastDay.Hour = 0;
    lastDay.Minute = 0;
    lastDay.Second = 0;
    lastDay = lastDay + day(1);

    nDays = days(lastDay-firstDay);

    dataDaily = data2((data2.Time >= firstDay) & data2.Time < (firstDay + day(1)),:);
    dummyTime = datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0):(data2.Time(2)-data2.Time(1)):datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0)+(minutes(1440)-(data2.Time(2)-data2.Time(1)));
    dummyData = timetable(randn(length(dummyTime),1),'VariableNames', {'glucose2'}, 'RowTimes', dummyTime);

    dataDaily = putOnTimegrid(dataDaily,dummyTime);
    dataDaily = synchronize(dataDaily,dummyData);
    dataDaily.glucose2 = [];

    dataMat = nan(length(dummyTime),nDays);
    dataMat(:,1) = dataDaily.glucose;

    for d = 2:nDays

        %Get the day of data
        dayData = data2((data2.Time >= firstDay + day(d-1)) & data2.Time < (firstDay + day(d)),:);
        dayData.Time = dayData.Time-day(d-1);
        dayData.Properties.VariableNames{1} = ['glucose2']; 
        %dayData = retime(dayData,'regular','mean','TimeStep', data.Time(2)-data.Time(1));
        dayData = putOnTimegrid(dayData,dummyTime);
        dataDaily = synchronize(dataDaily,dayData);

        dataMat(:,d) = dataDaily.glucose2;
        dataDaily.glucose2 = [];

    end
        
    plt2.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',5) fliplr(prctile(dataMat',95))],'g--',...
            'FaceColor',[243,32,50]/255, 'EdgeColor', [243,32,50]/255, 'FaceAlpha', 0.5);
    plt2.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',25) fliplr(prctile(dataMat',75))],'g',...
            'FaceColor',[172,27,45]/255, 'EdgeColor', [172,27,45]/255, 'FaceAlpha',0.5);
        
    plt2.median = plot(dataDaily.Time,nanmedian(dataMat'),'r','linewidth',2);
        
    plt2.line70 = plot([dummyTime(1) dummyTime(end)],[70 70],'--','linewidth',2,'Color',[77 189 109]/255);
    plt2.line180 = plot([dummyTime(1) dummyTime(end)],[180 180],'--','linewidth',2,'Color',[77 189 109]/255);

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

    legend([plt1.median plt2.median])
    
    %Print the .pdf file
    if(printFigure)
        print(f, '-dpdf', ['glucoseAsOneDayPlotComparison' '.pdf'],'-fillpage')
    end
    
    
end

function dataDaily = putOnTimegrid(dataDaily,dummyTime)
    
    for t = 1:height(dataDaily)
    
        d = abs(dataDaily.Time(t) - dummyTime);
        
        idx = find(min(d) == d,1,'first');
        
        dataDaily.Time(t) = dummyTime(idx);
    
    end

end

function valid = validData(data)
    %Input validator function handler 
    
    valid = ~istimetable(data);
    if(~valid)
        error('plotGlucose: data must be a timetable.');
    end
    
    valid = var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time))))
    if(~valid)
        error('plotGlucose: data must have a homogeneous time grid.')
    end
    
    valid = ~any(strcmp(fieldnames(data),'Time'))
    if(~valid)
        error('plotGlucose: data must have a column named `Time`.')
    end
    
    valid = ~any(strcmp(fieldnames(data),'glucose'))
    if(~valid)
        error('plotGlucose: data must have a column named `glucose`.')
    end
    
end
