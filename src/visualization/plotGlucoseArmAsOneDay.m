function plotGlucoseArmAsOneDay(arm,varargin)
%plotGlucoseArmAsOneDay function that generates a plot of an arm in a
%single plot where each daily profile is overlapped to each other.
%
%Input:
%    - arm: a cell array of timetables containing the glucose data of the 
%   arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings
%   (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the figure or not. 
%
%Preconditions:
%   - arm must be a cell array containing timetables;
%   - Each timetable in arm must have a column names `Time` and a
%   column named `glucose`.
%   - PrintFigure can be 0 or 1.
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
    addRequired(params,'arm',@(x) validArm(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,arm,varargin{:});

    printFigure = params.Results.PrintFigure;

          
    f =figure;

    sampleTime = minutes(arm{1}.Time(2) - arm{1}.Time(1));
    
    %Make arm data a single profile (actual date will be override)
    nDaysTotal = 0;
    for g = 1:length(arm)

        %Get the data timetable and harmonize sampleTime to the one of the
        %first glucose profile
        data = arm{g};
        ts = minutes((data.Time(2)-data.Time(1)));
        if(ts ~= sampleTime)
            data = retimeGlucose(data,sampleTime);
            if(ts>sampleTime)
                data = imputeGlucose(data,ts);
            end
        end
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
        lastDay = lastDay + days(1);

        nDays = days(lastDay-firstDay);
        nDaysTotal = nDays + nDaysTotal;

        dataDaily = data((data.Time >= firstDay) & data.Time < (firstDay + days(1)),:);
        dummyTime = datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0):(data.Time(2)-data.Time(1)):datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0)+(minutes(1440)-(data.Time(2)-data.Time(1)));
        dummyData = timetable(randn(length(dummyTime),1),'VariableNames', {'glucose2'}, 'RowTimes', dummyTime);

        dataDaily = putOnTimegrid(dataDaily,dummyTime);
        dataDaily = synchronize(dataDaily,dummyData);
        dataDaily.glucose2 = [];

        dataMats{g} = nan(length(dummyTime),nDays);
        dataMats{g}(:,1) = dataDaily.glucose;


        for d = 2:nDays

            %Get the day of data
            dayData = data((data.Time >= firstDay + days(d-1)) & data.Time < (firstDay + days(d)),:);
            dayData.Time = dayData.Time-days(d-1);
            dayData.Properties.VariableNames{1} = ['glucose2']; 
            %dayData = retime(dayData,'regular','mean','TimeStep', data.Time(2)-data.Time(1));
            dayData = putOnTimegrid(dayData,dummyTime);
            dataDaily = synchronize(dataDaily,dayData);

            dataMats{g}(:,d) = dataDaily.glucose2;
            dataDaily.glucose2 = [];

        end

    end
    
    dataMat = nan(length(dummyTime),nDaysTotal);
    k = 1;
    for g = 1:length(dataMats)
        dM = dataMats{g};
        for i = 1:size(dM,2)
            dataMat(:,k) = dataMats{g}(:,i);
            k = k+1;
        end
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
function valid = validArm(arm)
    %Input validator function handler 
    
    valid = iscell(arm);
    if(~valid)
        error('plotGlucoseArmAsOneDay: arm must be a cell array.');
    end
    
    for g = 1:length(arm)
        valid = istimetable(arm{g});
        if(~valid)
            error(['plotGlucoseArmAsOneDay: arm, timetable in position ' num2str(g) ' must be a timetable.']);
        end
        valid = any(strcmp(fieldnames(arm{g}),'glucose'));
        if(~valid)
            error(['plotGlucoseArmAsOneDay: arm, timetable in position ' num2str(g) ' must contain a column named glucose.']);
        end
        valid = any(strcmp(fieldnames(arm{g}),'Time'));
        if(~valid)
            error(['plotGlucoseArmAsOneDay: arm, timetable in position ' num2str(g) ' must contain a column named Time.']);
        end
        valid = ~ (var(seconds(diff(arm{g}.Time))) > 0 || isnan(var(seconds(diff(arm{g}.Time)))));
        if(~valid)
            error(['plotGlucoseArmAsOneDay: arm, timetable in position ' num2str(g) ' must have a homogeneous time grid.']);
        end
    end
    
end

