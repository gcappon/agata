function generateAGP(data,varargin)
%generateAGP function that generates the ambulatory glucose profile (AGP) 
%report of the given data. A report is generated every 14 days of
%recordings starting from last 14 days.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - Name: (optional, default: '') a vector of characters defining the name of the patient; 
%   - MRN: (optional, default: '') a vector of characters defining the medical record number of the patient; 
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to each AGP or not. 
%
%Preconditions:
%   - `data` must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% REFERENCE:
%   - Danne et al., "International consensus on use of continuous glucose
%   monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: 
%   10.2337/dc17-1600.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    

    %Input parser and check preconditions
    defaultName = '';
    defaultMRN = '';
    defaultPrintFigure = 0;

    params = inputParser;
    params.CaseSensitive = false;
    validTimetable = @(x) istimetable(x) && (sum(strcmp(fieldnames(data),'Time'))==1) && ...
        (sum(strcmp(fieldnames(data),'glucose'))==1) && (length(unique(diff(data.Time)))==1);
    addRequired(params,'data',validTimetable);
    addParameter(params,'Name',defaultName, @(x) ischar(x));
    addParameter(params,'MRN',defaultName, @(x) ischar(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data,varargin{:});

    name = params.Results.Name;
    mrn = params.Results.MRN;
    printFigure = params.Results.PrintFigure;

    firstDayAll = data.Time(1);
    firstDayAll.Hour = 0;
    firstDayAll.Minute = 0;
    firstDayAll.Second = 0;
    
    lastDayAll = data.Time(end);
    lastDayAll.Hour = 0;
    lastDayAll.Minute = 0;
    lastDayAll.Second = 0;
    lastDayAll = lastDayAll + day(1);
    
    nDays = days(lastDayAll-firstDayAll);
    
    daysVec = fliplr(1:nDays);
    
    
    indDayFirst = 1;
    
    dataAll = data;
    
    while(indDayFirst < length(daysVec))
        
        selDaysVec = daysVec(indDayFirst:min([14+(indDayFirst-1) length(daysVec)]));
        indDayFirst = indDayFirst + 14;
   
        data = dataAll((dataAll.Time >= firstDayAll + days(selDaysVec(end)-1)) & dataAll.Time < (firstDayAll + days(selDaysVec(1))),:);

        f =figure;

        font = 'Arial';
        firstColumnStart = 0.005;
        secondColumnStart = 0.6;

        %Generate the panel
        x0 = 0;
        y0 = 0;
        wdt=640;
        hgt=1024;
        set(gcf,'units','points','position',[x0,y0,wdt,hgt]);

        %Generate the title
        agp.title = annotation('textbox');
        agp.title.String = 'AGP Report';
        agp.title.FontName = 'Arial';
        agp.title.FontWeight = 'bold';
        agp.title.FitBoxToText = 0;
        agp.title.Units = 'points';
        agp.title.Position = [5 705 130 25];
        agp.title.FontSize = 16;

        %Generate the name and medical record number fields
        agp.name.line = annotation('line','Units','points','Position',[330 715 275 0]);
        agp.name.text = generateDescription('Name',[325 725 30 5],'bold');
        agp.name.textMain = generateDescription(name,[370 725 400 5],'bold');
        agp.mrn.line = annotation('line','Units','points','Position',[330 700 275 0]);
        agp.mrn.text = generateDescription('MRN',[325 710 30 5],'bold');
        agp.mrn.textMain = generateDescription(mrn,[370 710 300 5],'bold');

        %% Generate the GLUCOSE STATISTICS AND TARGET section

        %Title
        agp.section.glucoseStatisticsAndTarget.title = annotation('textbox');
        agp.section.glucoseStatisticsAndTarget.title.String = 'GLUCOSE STATISTICS AND TARGET';
        agp.section.glucoseStatisticsAndTarget.FontName = font;
        agp.section.glucoseStatisticsAndTarget.title.Color = [1 1 1];
        agp.section.glucoseStatisticsAndTarget.title.BackgroundColor = [0 0 0];
        agp.section.glucoseStatisticsAndTarget.title.FontWeight = 'bold';
        agp.section.glucoseStatisticsAndTarget.title.FitBoxToText = 0;
        agp.section.glucoseStatisticsAndTarget.title.Units = 'points';
        agp.section.glucoseStatisticsAndTarget.title.Position = [5 675 320 20];

        %Date range
        startDay = num2str(data.Time(1).Day);
        [~, startMonth] = month(datenum(data.Time(1)));
        startYear = num2str(data.Time(1).Year);
        endDay = num2str(data.Time(end).Day);
        [~, endMonth] = month(datenum(data.Time(end)));
        endYear = num2str(data.Time(end).Year);
        agp.section.glucoseStatisticsAndTarget.date.range = generateDescription([startDay ' ' startMonth ' ' startYear ' - ' endDay ' ' endMonth ' ' endYear],...
            [5 655 350 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.date.total = generateDescription([num2str(floor(days(data.Time(end)-data.Time(1)))+1) ' days'],...
            [275 655 350 20],'bold',10);

        %Time CGM is  active
        agp.section.glucoseStatisticsAndTarget.cgmActivity.description = generateDescription('% Time CGM is Active',...
            [5 643 350 20],'bold',10);
        percentageActivity = 100*sum(~isnan(data.glucose))/height(data);
        percentageActivity = sprintf('%3.2f',percentageActivity);
        agp.section.glucoseStatisticsAndTarget.cgmActivity.value = generateDescription([percentageActivity '%'],...
            [275 643 350 20],'bold',10);

        %First separator
        agp.section.glucoseStatisticsAndTarget.firstSeparator = annotation('line','Units','points','Position',[5 643 320 0]);

        %Glucose ranges
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.title1 = generateDescription('Glucose Ranges',...
            [5 625 350 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.title2 = generateDescription('Targets',...
            [165 625 50 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.subtitle2 = generateDescription('[% of Readings (Time/Day)]',...
            [210 624 150 20],'normal');
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.targetRangeText1 = generateDescription('Target Range 70-180 mg/dl......',...
            [5 610 200 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.targetRangeText2 = generateDescription('Greater than 70%',...
            [165 610 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.targetRangeReference = generateDescription('(16h 48min)',...
            [257 610 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below70Text1 = generateDescription('Below 70 mg/dl.........................',...
            [5 595 200 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below70Text2 = generateDescription('Less than 4%',...
            [165 595 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below70Reference = generateDescription('(58min)',...
            [257 595 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below54Text1 = generateDescription('Below 54 mg/dl.........................',...
            [5 580 200 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below54Text2 = generateDescription('Less than 1%',...
            [165 580 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.below54Reference = generateDescription('(14min)',...
            [257 580 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.above250Text1 = generateDescription('Above 250 mg/dl.......................',...
            [5 565 200 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.above250Text2 = generateDescription('Less than 5%',...
            [165 565 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.above250Reference = generateDescription('(1h 12min)',...
            [257 565 150 20],'normal',10);
        agp.section.glucoseStatisticsAndTarget.glucoseRanges.description = generateDescription('Each 5% increase in time in range (70-180 mg/dl) is clinically beneficial.',...
            [5 550 350 20],'normal',8);

        %Second separator
        agp.section.glucoseStatisticsAndTarget.secondSeparator = annotation('line','Units','points','Position',[5 550 320 0]);

        %Other stats
        agp.section.glucoseStatisticsAndTarget.averageGlucose.text = generateDescription('Average Glucose',...
            [5 530 350 20],'bold',10);
        meanG = sprintf('%3.2f',meanGlucose(data));
        agp.section.glucoseStatisticsAndTarget.gv.value = generateDescription([meanG  ' mg/dl'],...
            [245 530 350 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.gmi.text = generateDescription('Glucose Management Indicator (GMI)',...
            [5 515 350 20],'bold',10);
        gmiInd = sprintf('%3.2f',gmi(data));
        agp.section.glucoseStatisticsAndTarget.gv.value = generateDescription([gmiInd '%'],...
            [245 515 350 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.gv.text = generateDescription('Glucose Variability',...
            [5 500 350 20],'bold',10);
        cv = sprintf('%3.2f',cvGlucose(data));
        agp.section.glucoseStatisticsAndTarget.gv.value = generateDescription([cv '%'],...
            [245 500 350 20],'bold',10);
        agp.section.glucoseStatisticsAndTarget.averageGlucose.description = generateDescription('Defined as percent coefficient of variation (%CV); target \leq 36%.',...
            [5 485 350 20],'normal',8);

        %% Generate the TIME IN RANGES section

        %Title
        agp.section.timeInRanges.title = annotation('textbox');
        agp.section.timeInRanges.title.String = 'TIME IN RANGES';
        agp.section.timeInRanges.title.FontName = font;
        agp.section.timeInRanges.title.Color = [1 1 1];
        agp.section.timeInRanges.title.BackgroundColor = [0 0 0];
        agp.section.timeInRanges.title.FontWeight = 'bold';
        agp.section.timeInRanges.title.FitBoxToText = 0;
        agp.section.timeInRanges.title.Units = 'points';
        agp.section.timeInRanges.title.Position = [330 675 305 20];
        agp.section.timeInRanges.title.FitBoxToText = 0;

        %Colored boxes
        timeSevereHypo = timeInSevereHypoglycemia(data)/100;
        timeHypo = (timeInHypoglycemia(data)-timeInSevereHypoglycemia(data))/100;
        timeSevereHyper = timeInSevereHyperglycemia(data)/100;
        timeHyper = (timeInHyperglycemia(data)-timeInSevereHyperglycemia(data))/100;
        timeTarget = timeInTarget(data)/100;
        agp.section.timeInRanges.colorBox.severeHyper = annotation('rectangle','Units','points','Position',[345 510 40 140],...
            'Color',[255,137,55]/255,'FaceColor',[255,137,55]/255);
        agp.section.timeInRanges.colorBox.hyper = annotation('rectangle','Units','points','Position',[345 510 40 140*(timeSevereHypo+timeHypo+timeTarget+timeHyper)],...
            'Color',[255,244,62]/255,'FaceColor',[255,244,62]/255);
        agp.section.timeInRanges.colorBox.target = annotation('rectangle','Units','points','Position',[345 510 40 140*(timeSevereHypo+timeHypo+timeTarget)],...
            'Color',[77,189,109]/255,'FaceColor',[77,189,109]/255);
        agp.section.timeInRanges.colorBox.hypo = annotation('rectangle','Units','points','Position',[345 510 40 140*(timeSevereHypo+timeHypo)],...
            'Color',[243,32,50]/255,'FaceColor',[243,32,50]/255);
        agp.section.timeInRanges.colorBox.severeHypo = annotation('rectangle','Units','points','Position',[345 510 40 140*timeSevereHypo],...
            'Color',[172,27,45]/255,'FaceColor',[172,27,45]/255);

        sprintf('%3.2f',meanGlucose(data));
        %Annotations
        agp.section.timeInRanges.line1 = annotation('line','Units','points','Position',[365 505 0 5]);
        agp.section.timeInRanges.line2 = annotation('line','Units','points','Position',[365 505 25 0]);
        agp.section.timeInRanges.line3 = annotation('line','Units','points','Position',[365 650 0 5]);
        agp.section.timeInRanges.line4 = annotation('line','Units','points','Position',[365 655 25 0]);

        agp.section.timeInRanges.textSevereHyper1 = generateDescription('Very High',...
            [390 665 100 0],'bold',10);
        agp.section.timeInRanges.textSevereHyper2 = generateDescription('(>250 mg/dl)',...
            [450 664 100 0],'normal',8);
        agp.section.timeInRanges.textSevereHyper3 = generateDescription([sprintf('%3.1f',timeInSevereHyperglycemia(data)) '%'],...
            [540 665 100 0],'bold',10);
        tempDate = datetime(2000,1,1,0,round(timeInSevereHyperglycemia(data)/100*1440),0); 
        if(tempDate.Hour == 0 && (tempDate.Day-1) == 0)
            str = ['(' num2str(tempDate.Minute) 'min)'];
        else
            str = ['(' num2str((tempDate.Day-1)*24 + tempDate.Hour) 'h ' num2str(tempDate.Minute) 'min)'];
        end
        agp.section.timeInRanges.textSevereHyper4 = generateDescription(str,...
            [580 664 100 0],'normal',8);

        agp.section.timeInRanges.textHypo1 = generateDescription('Low',...
            [390 505+max([5 140*(timeSevereHypo+timeHypo/2)]) 100 15],'bold',10);
        agp.section.timeInRanges.textHypo2 = generateDescription('(54-69 mg/dl)',...
            [415 503+max([5 140*(timeSevereHypo+timeHypo/2)]) 100 15],'normal',8);
        agp.section.timeInRanges.textHypo3 = generateDescription([sprintf('%3.1f',timeInHypoglycemia(data)) '%'],...
            [540 505+max([5 140*(timeSevereHypo+timeHypo/2)]) 100 15],'bold',10);
        tempDate = datetime(2000,1,1,0,round(timeInHypoglycemia(data)/100*1440),0); 
        if(tempDate.Hour == 0 && (tempDate.Day-1) == 0)
            str = ['(' num2str(tempDate.Minute) 'min)'];
        else
            str = ['(' num2str((tempDate.Day-1)*24 + tempDate.Hour) 'h ' num2str(tempDate.Minute) 'min)'];
        end
        agp.section.timeInRanges.textHypo4 = generateDescription(str,...
            [580 503+max([5 140*(timeSevereHypo+timeHypo/2)]) 100 15],'normal',8);

        agp.section.timeInRanges.textTarget1 = generateDescription('Target Range',...
            [390 505+140*(timeSevereHypo+timeHypo+timeTarget/2) 100 15],'bold',10);
        agp.section.timeInRanges.textTarget2 = generateDescription('(70-180 mg/dl)',...
            [470 503+140*(timeSevereHypo+timeHypo+timeTarget/2) 100 15],'normal',8);
        agp.section.timeInRanges.textTarget3 = generateDescription([sprintf('%3.1f',timeInTarget(data)) '%'],...
            [540 505+140*(timeSevereHypo+timeHypo+timeTarget/2) 100 15],'bold',10);
        tempDate = datetime(2000,1,1,0,round(timeInTarget(data)/100*1440),0); 
        if(tempDate.Hour == 0 && (tempDate.Day-1) == 0)
            str = ['(' num2str(tempDate.Minute) 'min)'];
        else
            str = ['(' num2str((tempDate.Day-1)*24 + tempDate.Hour) 'h ' num2str(tempDate.Minute) 'min)'];
        end
        agp.section.timeInRanges.textTarget4 = generateDescription(str,...
            [580 503+140*(timeSevereHypo+timeHypo+timeTarget/2) 100 15],'normal',8);

        agp.section.timeInRanges.textHyper1 = generateDescription('High',...
            [390 505+140*(timeSevereHypo+timeHypo+timeTarget+timeHyper/2) 100 15],'bold',10);
        agp.section.timeInRanges.textHyper2 = generateDescription('(181-250 mg/dl)',...
            [420 503+140*(timeSevereHypo+timeHypo+timeTarget+timeHyper/2) 150 15],'normal',8);
        agp.section.timeInRanges.textHyper3 = generateDescription([sprintf('%3.1f',timeInHyperglycemia(data)) '%'],...
            [540 505+140*(timeSevereHypo+timeHypo+timeTarget+timeHyper/2) 100 15],'bold',10);
        tempDate = datetime(2000,1,1,0,round(timeInHyperglycemia(data)/100*1440),0); 
        if(tempDate.Hour == 0 && (tempDate.Day-1) == 0)
            str = ['(' num2str(tempDate.Minute) 'min)'];
        else
            str = ['(' num2str((tempDate.Day-1)*24 + tempDate.Hour) 'h ' num2str(tempDate.Minute) 'min)'];
        end
        agp.section.timeInRanges.textHyper4 = generateDescription(str,...
            [580 503+140*(timeSevereHypo+timeHypo+timeTarget+timeHyper/2) 100 15],'normal',8);

        agp.section.timeInRanges.textSevereHypo1 = generateDescription('Very Low',...
            [390 505 100 10],'bold',10);
        agp.section.timeInRanges.textSevereHypo2 = generateDescription('(<54 mg/dl)',...
            [445 503 100 10],'normal',8);
        agp.section.timeInRanges.textSevereHypo3 = generateDescription([sprintf('%3.1f',timeInSevereHypoglycemia(data)) '%'],...
            [540 505 100 10],'bold',10);
        tempDate = datetime(2000,1,1,0,round(timeInSevereHypoglycemia(data)/100*1440),0); 
        if(tempDate.Hour == 0 && (tempDate.Day-1) == 0)
            str = ['(' num2str(tempDate.Minute) 'min)'];
        else
            str = ['(' num2str((tempDate.Day-1)*24 + tempDate.Hour) 'h ' num2str(tempDate.Minute) 'min)'];
        end
        agp.section.timeInRanges.textSevereHypo4 = generateDescription(str,...
            [580 503 100 10],'normal',8);

        %% Generate the AGP section
        agp.section.agp.title = annotation('textbox');
        agp.section.agp.title.String = 'AMBULATORY GLUCOSE PROFILE (AGP)';
        agp.section.agp.title.FontName = font;
        agp.section.agp.title.Color = [1 1 1];
        agp.section.agp.title.BackgroundColor = [0 0 0];
        agp.section.agp.title.FontWeight = 'bold';
        agp.section.agp.title.FitBoxToText = 0;
        agp.section.agp.title.Units = 'points';
        agp.section.agp.title.Position = [5 465 630 20];

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
        subplot( 'Position',[.118,.3,.75,.24]);
        hold on
        agp.section.agp.area595 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',5) fliplr(prctile(dataMat',95))],'g--');
        agp.section.agp.area595.FaceColor = [204, 219, 237]/255;
        agp.section.agp.area595.EdgeColor = [131, 165, 206]/255;
        agp.section.agp.area2575 = fill([dataDaily.Time', fliplr(dataDaily.Time')],[prctile(dataMat',25) fliplr(prctile(dataMat',75))],'g');
        agp.section.agp.area2575.FaceColor = [131, 165, 206]/255;
        agp.section.agp.area2575.EdgeColor = [131, 165, 206]/255;
        agp.section.agp.median = plot(dataDaily.Time,nanmedian(dataMat'),'k','linewidth',2);
        hold off
        box on
        %set(gca,'units','points','position',[80,250,480,180])
        ylim([0 350]);
        yticks([0 54 250 350])
        yticklabels({'0','54','250','350'})
        datetick('x','HHPM')
        set(gca,'FontWeight','bold');
        set(gca,'FontSize',8);
        agp.section.agp.line54 = annotation('line','Units','points','Position',[76 267 481 0]);
        agp.section.agp.line54.Color = [136 137 140]/255;
        agp.section.agp.line250 = annotation('line','Units','points','Position',[76 375 480 0]);
        agp.section.agp.line250.Color = [136 137 140]/255;

        agp.section.agp.line70 = annotation('line','Units','points','Position',[55 279 501 0],'LineWidth',2);
        agp.section.agp.line70.Color = [77 189 109]/255;
        agp.section.agp.line70Up = annotation('line','Units','points','Position',[55 278 0 7],'LineWidth',2);
        agp.section.agp.line70Up.Color = [77 189 109]/255;
        agp.section.agp.tick70 = generateDescription('70',...
            [58 279 100 15],'bold',8);
        agp.section.agp.line180 = annotation('line','Units','points','Position',[56 342 501 0],'LineWidth',2);
        agp.section.agp.line180.Color = [77 189 109]/255;
        agp.section.agp.line180Down = annotation('line','Units','points','Position',[56 336 0 7],'LineWidth',2);
        agp.section.agp.line180Down.Color = [77 189 109]/255;
        agp.section.agp.tick180 = generateDescription('180',...
            [54 327 100 15],'bold',8);
        agp.section.agp.target = text(-.045, 95,'Target range');    
        set(agp.section.agp.target,'FontSize',6);
        set(agp.section.agp.target,'FontWeight','bold');
        set(agp.section.agp.target,'Rotation',90);

        agp.section.agp.labelY = text(-.055, 210,'mg/dl');    
        set(agp.section.agp.labelY,'FontSize',8);
        set(agp.section.agp.labelY,'FontWeight','bold');
        set(agp.section.agp.labelY,'Rotation',90);


        %% Generate DAILY GLUCOSE PROFILES section 
        agp.section.dgp.title = annotation('textbox');
        agp.section.dgp.title.String = 'DAILY GLUCOSE PROFILES';
        agp.section.dgp.title.FontName = font;    
        agp.section.dgp.title.Color = [1 1 1];
        agp.section.dgp.title.BackgroundColor = [0 0 0];
        agp.section.dgp.title.FontWeight = 'bold';
        agp.section.dgp.title.FitBoxToText = 0;
        agp.section.dgp.title.Units = 'points';
        agp.section.dgp.title.Position = [5 200 630 20];

        %Generate the descriptive text
        agp.section.agp.description = generateDescription('AGP is a summary of glucose values from the report period, with median (50%) and other percentiles shown as if occuorring in a single day.',[5 465 650 0],'normal');    

        agp.section.dgp.description = generateDescription('Each daily profile represents a midnight to midnight period.', [5 185 600 15],'normal');
        %agp.section.dgp.monday = generateDescription('Sunday', [35 175 30 10],'bold');
        %agp.section.dgp.tuesday = generateDescription('Monday', [120 175 30 10],'bold');
        %agp.section.dgp.wednesday = generateDescription('Tuesday', [200 175 30 10],'bold');
        %agp.section.dgp.thursday = generateDescription('Wednesday', [285 175 30 10],'bold');
        %agp.section.dgp.friday = generateDescription('Thursday', [377 175 30 10],'bold');
        %agp.section.dgp.saturday = generateDescription('Friday', [455 175 30 10],'bold');
        %agp.section.dgp.sunday = generateDescription('Saturday', [545 175 30 10],'bold');



        for d = 1:nDays

            %Get the day of data
            dayData = data((data.Time >= firstDay + day(d-1)) & data.Time < (firstDay + day(d)),:);

            startTime = firstDay + day(d-1) + (data.Time(2)-data.Time(1))*3;
            endTime = firstDay + day(d) - (data.Time(2)-data.Time(1))*3;
            ax2 = subplot( 'Position',[.03+(.13*mod(d-1,7)), .12-.1*(floor((d-1)/7)),.12,.09]);
            hold on

            %Hyper yellow area 
            hyperTop = max([dayData.glucose 180*ones(height(dayData),1)]');
            hyperBot = 180*ones(height(dayData),1)';
            agp.section.dgp.areaHyper = fill([dayData.Time', fliplr(dayData.Time')],[hyperBot fliplr(hyperTop)],'g',...
                'EdgeColor', [255,244,62]/255,'FaceColor', [255,244,62]/255);


            %Hypo red area 
            hypoTop = min([dayData.glucose 70*ones(height(dayData),1)]');
            hypoBot = 70*ones(height(dayData),1)';
            agp.section.dgp.areaHyper = fill([dayData.Time', fliplr(dayData.Time')],[hypoBot fliplr(hypoTop)],'g',...
                'FaceColor',[243,32,50]/255,'EdgeColor', [243,32,50]/255);


            %Target gray area
            agp.section.dgp.area70180 = fill([startTime endTime endTime startTime],[70 70 180 180],'g');
            agp.section.dgp.area70180.FaceColor = [199, 200, 202]/255;
            agp.section.dgp.area70180.EdgeColor = [199, 200, 202]/255;

            if(~isempty(dayData))
                plot(dayData.Time,dayData.glucose,'k');
                agp.section.dgp.day = annotation('textbox');
                agp.section.dgp.day.String = num2str(dayData.Time(1).Day);
                agp.section.dgp.day.FontSize = 8;
                agp.section.dgp.day.FontName = 'Arial';
                agp.section.dgp.day.FitBoxToText = 0;
                agp.section.dgp.day.Position = [.03+(.13*mod(d-1,7)), .12-.1*(floor((d-1)/7)),.12,.09];
                agp.section.dgp.day.EdgeColor = 'none';
            end


            hold off
            box on
            %set(ax2,'units','points','position',[50,50,80,80])
            ylim([0 350]);
            yticks([])
            yticklabels({})
            datetick('x','HHPM')

            xticks([])
            yticklabels({''})
            set(gca,'FontSize',6);
        end

        %Print the .pdf file
        if(isempty(name))
            strName = '';
        else
            strName = ['_NAME-' name];
        end
        if(isempty(mrn))
            strMRN = '';
        else
            strMRN = ['_MRN-' mrn];
        end
        strData = ['_from_' num2str(data.Time(1).Year) '-' num2str(data.Time(1).Month) '-' num2str(data.Time(1).Day) ...
            '_to_' num2str(data.Time(end).Year) '-' num2str(data.Time(end).Month) '-' num2str(data.Time(end).Day)];
        
        if(printFigure)
            print(f, '-dpdf', ['AGP' strName strMRN strData '.pdf'],'-fillpage')
        end
    
    end
    
end

function description = generateDescription(text,position,weight,fontsize)

    description = annotation('textbox');
    description.String = text;
    if(nargin == 4)
        description.FontSize = fontsize;
    else
        description.FontSize = 8;
    end
    description.FontName = 'Arial';
    description.FitBoxToText = 0;
    description.Units = 'points';
    description.Position = position;
    description.EdgeColor = 'none';
    description.FontWeight = weight;
    
end

function dataDaily = putOnTimegrid(dataDaily,dummyTime)
    
    for t = 1:height(dataDaily)
    
        d = abs(dataDaily.Time(t) - dummyTime);
        
        idx = find(min(d) == d,1,'first');
        
        dataDaily.Time(t) = dummyTime(idx);
    
    end

end

