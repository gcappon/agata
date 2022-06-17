function plotGlucoseArmAsOneDayComparison(arm1,arm2,varargin)
%plotGlucoseArmAsOneDayComparison function that  generates a plot of two arms in a
%single plot where each arm's daily profile is overlapped to each other. This is
%for comparison.
%
%Input:
%    - arm1: a cell array of timetables containing the glucose data of the 
%   first arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings
%   (in mg/dl);
%    - arm2: a cell array of timetables containing the glucose data of the 
%   second arm. Each timetable corresponds to a patient and contains a 
%   column `Time` and a column `glucose` containg the glucose recordings
%   (in mg/dl);
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to the figure or not. 
%
%Preconditions:
%   - arm1 and arm2 must be a cell array containing timetables;
%   - Each timetable in arm1 and arm2 must have a column names `Time` and a
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
    addRequired(params,'arm1',@(x) validArm(x));
    addRequired(params,'arm2',@(x) validArm(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,arm1,arm2,varargin{:});

    printFigure = params.Results.PrintFigure;

          
    f =figure;

    sampleTime = minutes(arm1{1}.Time(2) - arm1{1}.Time(1));
    
    %Make arm data a single profile (actual date will be override)
    nDaysTotal = 0;
    for g = 1:length(arm1)

        %Get the data timetable and harmonize sampleTime to the one of the
        %first glucose profile
        data = arm1{g};
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
    
    dataMat1 = nan(length(dummyTime),nDaysTotal);
    k = 1;
    for g = 1:length(dataMats)
        dM = dataMats{g};
        for i = 1:size(dM,2)
            dataMat1(:,k) = dataMats{g}(:,i);
            k = k+1;
        end
    end
    
    hold on

    %Target gray area
    plt.area70180 = fill([dummyTime(1) dummyTime(end) dummyTime(end) dummyTime(1)],[70 70 180 180],'g',...
        'FaceColor',[199, 200, 202]/255,'EdgeColor','none','FaceAlpha',0.5);


    agp.section.agp.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat1',5) fliplr(prctile(dataMat1',95))],'g--');
    agp.section.agp.area595.FaceColor = [204, 219, 237]/255;
    agp.section.agp.area595.EdgeColor = [131, 165, 206]/255;
    agp.section.agp.area595.FaceAlpha = 0.5;
    agp.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat1',25) fliplr(prctile(dataMat1',75))],'g');
    agp.section.agp.area2575.FaceColor = [131, 165, 206]/255;
    agp.section.agp.area2575.EdgeColor = [131, 165, 206]/255;
    agp.section.agp.area2575.FaceAlpha = 0.5;
    plt1.median = plot(dataDaily.Time,nanmedian(dataMat1'),'b','linewidth',2);
    
    dummyTimeArm1 = dummyTime;
    dataDailyArm1 = dataDaily;
    
    sampleTime = minutes(arm2{1}.Time(2) - arm2{1}.Time(1));
    
    %Make arm data a single profile (actual date will be override)
    nDaysTotal = 0;
    for g = 1:length(arm2)

        %Get the data timetable and harmonize sampleTime to the one of the
        %first glucose profile
        data = arm2{g};
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
    
    dataMat2 = nan(length(dummyTime),nDaysTotal);
    k = 1;
    for g = 1:length(dataMats)
        dM = dataMats{g};
        for i = 1:size(dM,2)
            dataMat2(:,k) = dataMats{g}(:,i);
            k = k+1;
        end
    end
    

    
    %Set dummyTime day to the day of the dummyTime of the first arm (to
    %allineate the plots)
    dummyTime.Year = dummyTimeArm1.Year(1);
    dummyTime.Month = dummyTimeArm1.Month(1);
    dummyTime.Day = dummyTimeArm1.Day(1);
    dataDaily.Time.Year = dataDailyArm1.Time.Year(1);
    dataDaily.Time.Month = dataDailyArm1.Time.Month(1);
    dataDaily.Time.Day = dataDailyArm1.Time.Day(1);
    
    agp.section.agp.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat2',5) fliplr(prctile(dataMat2',95))],'g--');
    agp.section.agp.area595.FaceColor = [243,32,50]/255;
    agp.section.agp.area595.EdgeColor = [243,32,50]/255;
    agp.section.agp.area595.FaceAlpha = 0.5;
    agp.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat2',25) fliplr(prctile(dataMat2',75))],'g');
    agp.section.agp.area2575.FaceColor = [172,27,45]/255;
    agp.section.agp.area2575.EdgeColor = [172,27,45]/255;
    agp.section.agp.area2575.FaceAlpha = 0.5;
    plt2.median = plot(dataDaily.Time,nanmedian(dataMat2'),'r','linewidth',2);

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

    legend([plt1.median plt2.median])
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

