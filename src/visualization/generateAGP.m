function generateAGP(data,varargin)
%generateAGP function that generates the ambulatory glucose profile (AGP) 
%report of the given data. A report is generated every 14 days of
%recordings starting from last 14 days.
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - Name: (optional, default: '') a vector of characters defining the name of the patient; 
%   - DOB: (optional, default: '') a vector of characters defining the date of birth of the patient; 
%   - PrintFigure: (optional, default: 0) a numeric flag defining whether 
%   to output the .pdf files associated to each AGP or not. 
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%   - data must contain a column named `Time` and another named `glucose`.
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
    defaultName = '<Patient name>';
    defaultDOB = '<MM-DD-YYYY>';
    defaultPrintFigure = 0;

    params = inputParser;
    params.CaseSensitive = false;
    addRequired(params,'data',@(x) validData(x));
    addParameter(params,'Name',defaultName, @(x) ischar(x));
    addParameter(params,'DOB',defaultDOB, @(x) ischar(x));
    addParameter(params,'PrintFigure',defaultPrintFigure, @(x) x == 0 || x == 1);
    parse(params,data,varargin{:});

    name = params.Results.Name;
    dob = params.Results.DOB;
    printFigure = params.Results.PrintFigure;

    firstDayAll = data.Time(1);
    firstDayAll.Hour = 0;
    firstDayAll.Minute = 0;
    firstDayAll.Second = 0;
    
    lastDayAll = data.Time(end);
    lastDayAll.Hour = 0;
    lastDayAll.Minute = 0;
    lastDayAll.Second = 0;
    lastDayAll = lastDayAll + days(1);
    
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
        wdt=1440;
        hgt=2560;
        set(gcf,'units','points','position',[x0,y0,wdt,hgt]);

        %Generate the title
        agp.title = annotation('textbox');
        agp.title.String = 'AGP Report: Continuos Glucose Monitoring';
        agp.title.EdgeColor = 'none';
        agp.title.Color = [83 63 144]/255;
        agp.title.FontName = 'Arial';
        agp.title.FontWeight = 'bold';
        agp.title.FitBoxToText = 0;
        agp.title.Position = [.005 .97 .75 .025];
        agp.title.FontSize = 16;

        %Generate the name and date of birth fields
        agp.name.line = annotation('line',[.55 .995],[.95 .95]);
        agp.name.text = generateDescription('Name: ',[.555 .95 .20 .02],'bold',12);
        agp.name.textMain = generateDescription(name,[.61 .95 .45 .02],'bold',12);
        agp.dob.text = generateDescription('DOB: ',[.755 .95 .20 .02],'bold',12);
        agp.dob.textMain = generateDescription(dob,[.81 .95 .45 .02],'bold',12);
        
        %Date range
        agp.section.glucoseStatisticsAndTarget.date.line = annotation('line',[.55 .995],[.925 .925]);
        agp.section.glucoseStatisticsAndTarget.date.total = generateDescription([num2str(floor(days(data.Time(end)-data.Time(1)))+1) ' Days: '],...
            [.555 .925 .20 .02],'bold',12);
        startDay = num2str(data.Time(1).Day);
        [~, startMonth] = month(datenum(data.Time(1)));
        startYear = num2str(data.Time(1).Year);
        endDay = num2str(data.Time(end).Day);
        [~, endMonth] = month(datenum(data.Time(end)));
        endYear = num2str(data.Time(end).Year);
        agp.section.glucoseStatisticsAndTarget.date.range = generateDescription([startDay ' ' startMonth ' ' startYear ' - ' endDay ' ' endMonth ' ' endYear],...
            [.65 .925 .20 .02],'bold',12);
        
        %Time CGM is  active
        agp.section.glucoseStatisticsAndTarget.cgmActivity.line = annotation('line',[.55 .995],[.9 .9]);
        agp.section.glucoseStatisticsAndTarget.cgmActivity.description = generateDescription('Time CGM Active: ',...
            [.555 .9 .20 .02],'bold',12);
        percentageActivity = 100*sum(~isnan(data.glucose))/height(data);
        percentageActivity = sprintf('%3.1f',percentageActivity);
        agp.section.glucoseStatisticsAndTarget.cgmActivity.value = generateDescription([percentageActivity '%'],...
            [.7 .9 .20 .02],'bold',12);
        

        %% Generate the Goals for Type 1 and Type 2 Diabetes section

        %Title
        agp.section.glucoseStatisticsAndTarget.title = annotation('textbox');
        agp.section.glucoseStatisticsAndTarget.title.String = 'Goals for Type 1 and Type 2 Diabetes';
        agp.section.glucoseStatisticsAndTarget.FontName = font;
        agp.section.glucoseStatisticsAndTarget.title.Color = [0 0 0]/255;
        agp.section.glucoseStatisticsAndTarget.title.BackgroundColor = [224 224 223]/255;
        agp.section.glucoseStatisticsAndTarget.title.FontWeight = 'bold';
        agp.section.glucoseStatisticsAndTarget.title.FitBoxToText = 0;
        agp.section.glucoseStatisticsAndTarget.title.EdgeColor = 'none';
        agp.section.glucoseStatisticsAndTarget.title.Position = [.005 .95 .525 .02];
        
        agp.section.glucoseStatisticsAndTarget.box = annotation('textbox');
        agp.section.glucoseStatisticsAndTarget.box.EdgeColor = [224 224 223]/255;
        agp.section.glucoseStatisticsAndTarget.box.Position = [.005 .685 .525 .265];
        
        %Colored boxes
        timeL2Hypo = timeInL2Hypoglycemia(data)/100;
        timeL1Hypo = timeInL1Hypoglycemia(data)/100;
        timeL2Hyper = timeInL2Hyperglycemia(data)/100;
        timeL1Hyper = timeInL1Hyperglycemia(data)/100;
        timeTarget = timeInTarget(data)/100;
        if(isnan(timeTarget)) %this happens if all glucose points are nan
            agp.section.glucoseStatisticsAndTarget.colorBox.severeHyper = annotation('rectangle','Position',[.075 .725 .05 .2],...
                'Color',[100,100,100]/255,'FaceColor',[100,100,100]/255);
        else
            agp.section.glucoseStatisticsAndTarget.colorBox.severeHyper = annotation('rectangle','Position',[.075 .725 .05 .2],...
                'Color',[220,112,48]/255,'FaceColor',[220,112,48]/255);
            agp.section.glucoseStatisticsAndTarget.colorBox.hyper = annotation('rectangle','Position',[.075 .725 .05 .2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper)],...
                'Color',[231,159,52]/255,'FaceColor',[231,159,52]/255);
            agp.section.glucoseStatisticsAndTarget.colorBox.target = annotation('rectangle','Position',[.075 .725 .05 .2*(timeL2Hypo+timeL1Hypo+timeTarget)],...
                'Color',[19,152,79]/255,'FaceColor',[19,152,79]/255);
            agp.section.glucoseStatisticsAndTarget.colorBox.hypo = annotation('rectangle','Position',[.075 .725 .05 .2*(timeL2Hypo+timeL1Hypo)],...
                'Color',[203,34,42]/255,'FaceColor',[203,34,42]/255);
            agp.section.glucoseStatisticsAndTarget.colorBox.severeHypo = annotation('rectangle','Position',[.075 .725 .05 .2*(timeL2Hypo)],...
                'Color',[135,40,43]/255,'FaceColor',[135,40,43]/255);
        
            agp.section.glucoseStatisticsAndTarget.colorBox.textVeryHigh = generateDescription(sprintf('Very High'),...
                [.125 .925 .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.valueVeryHigh = generateDescription([sprintf('%3.1f',timeL2Hyper*100) '%'],...
                [.075+.15 .925 .15 .02],'bold',12);
            
            
            
            
            
            if((timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2)>0.85)
                agp.section.glucoseStatisticsAndTarget.colorBox.textHigh = generateDescription(sprintf('High'),...
                    [.125 .725+.2*0.85 .15 .02],'bold',12);
                agp.section.glucoseStatisticsAndTarget.colorBox.valueHigh = generateDescription([sprintf('%3.1f',timeL1Hyper*100) '%'],...
                    [.075+.15 .725+.2*0.85 .15 .02],'bold',12);
                agp.section.glucoseStatisticsAndTarget.colorBox.lineHigh = annotation('line',[.075+.055 .075+.055+.15],[.725+.2*0.85 .725+.2*0.85]);
                agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectHigh = annotation('line',[.075+.055+.15 .075+.055+.15],[.725+.2*0.85 .725+.2]);
            else
                agp.section.glucoseStatisticsAndTarget.colorBox.textHigh = generateDescription(sprintf('High'),...
                    [.125 .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) .15 .02],'bold',12);
                agp.section.glucoseStatisticsAndTarget.colorBox.valueHigh = generateDescription([sprintf('%3.1f',timeL1Hyper*100) '%'],...
                    [.075+.15 .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) .15 .02],'bold',12);
                agp.section.glucoseStatisticsAndTarget.colorBox.lineHigh = annotation('line',[.075+.055 .075+.055+.15],[.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2)]);
                agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectHigh = annotation('line',[.075+.055+.15 .075+.055+.15],[.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) .725+.2]);
            end
            
            
            
            agp.section.glucoseStatisticsAndTarget.colorBox.valueHighTogether = generateDescription([sprintf('%3.1f',(timeL1Hyper+timeL2Hyper)*100) '%'],...
                [.075+.25 (.73+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) + .725+.2)/2 .15 .02],'bold',16);

            agp.section.glucoseStatisticsAndTarget.colorBox.textTarget = generateDescription(sprintf('Target'),...
                [.125 .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2) .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.valueTarget = generateDescription([sprintf('%3.1f',timeTarget*100) '%'],...
                [.075+.25 .73+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2) .15 .02],'bold',16);

            agp.section.glucoseStatisticsAndTarget.colorBox.textLow = generateDescription(sprintf('Low'),...
                [.125 .725+.2*(timeL2Hypo+timeL1Hypo/2) .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.valueLow = generateDescription([sprintf('%3.1f',timeL1Hypo*100) '%'],...
                [.075+.15 .725+.2*(timeL2Hypo+timeL1Hypo/2) .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.textVeryLow = generateDescription(sprintf('Very Low'),...
                [.125 .7 .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.valueVeryLow = generateDescription([sprintf('%3.1f',timeL2Hypo*100) '%'],...
                [.075+.15 .7 .15 .02],'bold',12);
            agp.section.glucoseStatisticsAndTarget.colorBox.valueLowTogether = generateDescription([sprintf('%3.1f',(timeL1Hypo+timeL2Hypo)*100) '%'],...
                [.075+.25 (.705+.725+.2*(timeL2Hypo+timeL1Hypo/2))/2 .15 .02],'bold',16);

            agp.section.glucoseStatisticsAndTarget.colorBox.lineVeryHigh = annotation('line',[.075+.055 .075+.055+.15],[.725+.2 .725+.2]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineHighTogether = annotation('line',[.075+.055+.15 .075+.25+.15],[(.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) + .725+.2)/2 (.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) + .725+.2)/2]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineTarget = annotation('line',[.075+.055 .075+.25+.15],[.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2) .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2)]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineLow = annotation('line',[.075+.055 .075+.055+.15],[.725+.2*(timeL2Hypo+timeL1Hypo/2) .725+.2*(timeL2Hypo+timeL1Hypo/2)]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineVeryLow = annotation('line',[.075+.055 .075+.055+.15],[.7 .7]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectLow = annotation('line',[.075+.055+.15 .075+.055+.15],[.7 .725+.2*(timeL2Hypo+timeL1Hypo/2)]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineLowTogether = annotation('line',[.075+.055+.15 .075+.25+.15],[(.7+.725+.2*(timeL2Hypo+timeL1Hypo/2))/2 (.7+.725+.2*(timeL2Hypo+timeL1Hypo/2))/2]);

            agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectVeryLow1 = annotation('line',[.075+.025 .075+.025],[.71 .725]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectVeryLow2 = annotation('line',[.075+.025 .075+.045],[.71 .71]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectVeryHigh1 = annotation('line',[.075+.025 .075+.025],[.725+.2 .725+.21]);
            agp.section.glucoseStatisticsAndTarget.colorBox.lineConnectVeryHigh2 = annotation('line',[.075+.025 .075+.045],[.725+.21  .725+.21]);

            agp.section.glucoseStatisticsAndTarget.goalVeryHighText = generateDescription('Goal < 5%',...
                [.025 .725+.2 .15 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.goalVeryHighText.Color = [113 113 114]/255;
            agp.section.glucoseStatisticsAndTarget.goalHighText = generateDescription('Goal < 25%',...
                [.075+.25+.075 (.725+.2*(timeL2Hypo+timeL1Hypo+timeTarget+timeL1Hyper/2) + .725+.2)/2 .1 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.goalHighText.Color = [113 113 114]/255;
            agp.section.glucoseStatisticsAndTarget.goalTargetText = generateDescription('Goal >= 70%',...
                [.075+.25+.075 .725+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2) .1 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.goalTargetText.Color = [113 113 114]/255;
            agp.section.glucoseStatisticsAndTarget.goalLowText = generateDescription('Goal < 4%',...
                [.075+.25+.075 (.7+.725+.2*(timeL2Hypo+timeL1Hypo/2))/2 .1 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.goalLowText.Color = [113 113 114]/255;
            agp.section.glucoseStatisticsAndTarget.goalVeryLowText = generateDescription('Goal < 1%',...
                [.025 .7 .15 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.goalVeryLowText.Color = [113 113 114]/255;

            agp.section.glucoseStatisticsAndTarget.hintTarget = generateDescription('Each 5% increase is clinically beneficial',...
                [.075+.205 .705+.2*(timeL2Hypo+timeL1Hypo+timeTarget/2) .4 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.hintTarget.Color = [113 113 114]/255;
            agp.section.glucoseStatisticsAndTarget.hintNumbers = generateDescription('Each 1% time in range = about 15 minutes',...
                [.075+.205 .69 .4 .02],'normal',10);
            agp.section.glucoseStatisticsAndTarget.hintNumbers.Color = [113 113 114]/255;
        end
        
        %% Generate the Glucose Metrics section

        %Title
        agp.section.glucoseMetrics.title = annotation('textbox');
        agp.section.glucoseMetrics.title.String = 'Glucose Metrics';
        agp.section.glucoseMetrics.FontName = font;
        agp.section.glucoseMetrics.title.Color = [0 0 0]/255;
        agp.section.glucoseMetrics.title.BackgroundColor = [224 224 223]/255;
        agp.section.glucoseMetrics.title.FontWeight = 'bold';
        agp.section.glucoseMetrics.title.FitBoxToText = 0;
        agp.section.glucoseMetrics.title.EdgeColor = 'none';
        agp.section.glucoseMetrics.title.Position = [.55 .865 .445 .02];
        
        agp.section.glucoseMetrics.box = annotation('textbox');
        agp.section.glucoseMetrics.box.EdgeColor = [224 224 223]/255;
        agp.section.glucoseMetrics.box.Position = [.55 .685 .445 .18];
        
        %Average Glucose
        mG = meanGlucose(data);
        agp.section.glucoseMetrics.averageGlucose.text = generateDescription(['Average Glucose'],...
            [.575 .80 .445 .05],'bold',12);
        if(isnan(mG))
            agp.section.glucoseMetrics.averageGlucose.value = generateDescription([' --- mg/dl'],...
            [.85 .80 .445 .05],'bold',12);
        else
            agp.section.glucoseMetrics.averageGlucose.value = generateDescription([sprintf('%3.1f',meanGlucose(data)) ' mg/dl'],...
            [.85 .80 .445 .05],'bold',12);
        end
        agp.section.glucoseMetrics.averageGlucose.goal = generateDescription('Goal: <154 mg/dL',...
            [.575 .785 .445 .05],'normal',10);
        agp.section.glucoseMetrics.averageGlucose.goal.Color = [113 113 114]/255;
        
        %GMI
        gmiG = gmi(data);
        agp.section.glucoseMetrics.gmi.box = annotation('textbox');
        agp.section.glucoseMetrics.gmi.box.EdgeColor = [224 224 223]/255;
        agp.section.glucoseMetrics.gmi.box.BackgroundColor = [224 224 223]/255;
        agp.section.glucoseMetrics.gmi.box.Position = [.55 .750 .445 .06];
        
        agp.section.glucoseMetrics.gmi.text = generateDescription(['Glucose Management Indicator (GMI)'],...
            [.575 .75 .445 .05],'bold',12);
        if(isnan(gmiG))
            agp.section.glucoseMetrics.gmi.value = generateDescription(['--- %'],...
            [.85 .75 .445 .05],'bold',12);
        else
            agp.section.glucoseMetrics.gmi.value = generateDescription([sprintf('%3.1f',gmiG) ' %'],...
            [.85 .75 .445 .05],'bold',12);
        end
        agp.section.glucoseMetrics.gmi.goal = generateDescription('Goal: <7 %',...
            [.575 .735 .445 .05],'normal',10);
        agp.section.glucoseMetrics.gmi.goal.Color = [113 113 114]/255;
        
        %GV
        gvG = cvGlucose(data);
        agp.section.glucoseMetrics.gv.text = generateDescription(['Glucose Variability'],...
            [.575 .690 .445 .05],'bold',12);
        if(isnan(gvG))
            agp.section.glucoseMetrics.gv.value = generateDescription(['--- %'],...
                [.85 .690 .445 .05],'bold',12);
        else
            agp.section.glucoseMetrics.gv.value = generateDescription([sprintf('%3.1f',gvG) ' %'],...
                [.85 .690 .445 .05],'bold',12);
        end
        agp.section.glucoseMetrics.gv.desc = generateDescription('Defined as percent coefficient of variation',...
            [.575 .675 .445 .05],'normal',10);
        agp.section.glucoseMetrics.gv.desc.Color = [113 113 114]/255;
        agp.section.glucoseMetrics.gv.goal = generateDescription('Goal: <=36 %',...
            [.575 .665 .445 .05],'normal',10);
        agp.section.glucoseMetrics.gv.goal.Color = [113 113 114]/255;
        
       
       
        %% Generate the AGP section

        %Title
        agp.section.agp.title = annotation('textbox');
        agp.section.agp.title.String = 'Ambulatory Glucose Profile (AGP)';
        agp.section.agp.FontName = font;
        agp.section.agp.title.Color = [0 0 0]/255;
        agp.section.agp.title.BackgroundColor = [224 224 223]/255;
        agp.section.agp.title.FontWeight = 'bold';
        agp.section.agp.title.FitBoxToText = 0;
        agp.section.agp.title.EdgeColor = 'none';
        agp.section.agp.title.Position = [.005 .655 .99 .02];
        
        agp.section.agp.box = annotation('textbox');
        agp.section.agp.box.EdgeColor = [224 224 223]/255;
        agp.section.agp.box.Position = [.005 .280 .99 .395];
        
        agp.section.agp.hint = generateDescription('AGP is a summary of glucose values from the report period, with median (50%) and other percentiles shown as if they occured in a single day',...
            [.075 .62 .99 .02],'normal',10);
        
        %First, impute everything
        %dataAGP = imputeGlucose(data,height(data)*(minutes(data.Time(2)-data.Time(1))));
        dataAGP = data;
        %Generate the plot
        firstDay = dataAGP.Time(1);
        firstDay.Hour = 0;
        firstDay.Minute = 0;
        firstDay.Second = 0;

        lastDay = dataAGP.Time(end);
        lastDay.Hour = 0;
        lastDay.Minute = 0;
        lastDay.Second = 0;
        lastDay = lastDay + days(1);

        nDays = days(lastDay-firstDay);
        
        
        
        dataDaily = dataAGP((dataAGP.Time >= firstDay) & dataAGP.Time < (firstDay + days(1)),:);
        dummyTime = datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0):(dataAGP.Time(2)-dataAGP.Time(1)):datetime(dataDaily.Time.Year(1),dataDaily.Time.Month(1),dataDaily.Time.Day(1),0,0,0)+(minutes(1440)-(dataAGP.Time(2)-dataAGP.Time(1)));
        dummyData = timetable(randn(length(dummyTime),1),'VariableNames', {'glucose2'}, 'RowTimes', dummyTime);

        dataDaily = putOnTimegrid(dataDaily,dummyTime);
        dataDaily = synchronize(dataDaily,dummyData);
        dataDaily.glucose2 = [];

        dataMat = nan(length(dummyTime),nDays);
        dataMat(:,1) = dataDaily.glucose;

        for d = 2:nDays

            %Get the day of data
            dayData = dataAGP((dataAGP.Time >= firstDay + days(d-1)) & dataAGP.Time < (firstDay + days(d)),:);
            dayData.Time = dayData.Time-days(d-1);
            dayData.Properties.VariableNames{1} = ['glucose2']; 
            dayData = putOnTimegrid(dayData,dummyTime);
            dataDaily = synchronize(dataDaily,dayData);
            dataMat(:,d) = dataDaily.glucose2;
            dataDaily.glucose2 = [];

        end
        
        
        subplot( 'Position',[.1,.3,.75,.3]);
        hold on
        X = dataDaily.Time';
        Y1 = prctile(dataMat',5);
        Y2 = prctile(dataMat',95);
        idx = ~isnan(Y1) & ~isnan(Y2);
        X = X(idx);
        Y1 = Y1(idx);
        Y2 = Y2(idx);
        if(~isempty(X))
            agp.section.agp.area595 = fill([X, fliplr(X)],[Y1 fliplr(Y2)],'g--');
            agp.section.agp.area595.FaceColor = [204, 219, 237]/255;
            agp.section.agp.area595.EdgeColor = [131, 165, 206]/255;
            X = dataDaily.Time';
            Y1 = prctile(dataMat',25);
            Y2 = prctile(dataMat',75);
            idx = ~isnan(Y1) & ~isnan(Y2);
            X = X(idx);
            Y1 = Y1(idx);
            Y2 = Y2(idx);
            agp.section.agp.area2575 = fill([X, fliplr(X)],[Y1 fliplr(Y2)],'g--');
            agp.section.agp.area2575.FaceColor = [131, 165, 206]/255;
            agp.section.agp.area2575.EdgeColor = [131, 165, 206]/255;
            agp.section.agp.median = plot(dataDaily.Time,nanmedian(dataMat'),'k','linewidth',2);
        end
        grid on
        hold off
        box on
        ylim([0 350]);
        yticks([0 54 250 350])
        yticklabels({'0','54','250','350'})
        datetick('x','HHPM')
        set(gca,'FontWeight','bold');
        set(gca,'FontSize',8);
        
        
        agp.section.agp.target70.line = annotation('line',[.1 .85],[.36 .36],'LineWidth',2,'Color',[19 152 79]/255);
        agp.section.agp.target180.line = annotation('line',[.1 .85],[.454 .454],'LineWidth',2,'Color',[19 152 79]/255);
        
        agp.section.agp.target = generateDescription('Target Range',[.03,.407,.05,.02],'bold',12);
        
        agp.section.agp.target70Hint = annotation('textbox','VerticalAlignment','middle','HorizontalAlignment','center');
        agp.section.agp.target70Hint.String = '70';
        agp.section.agp.target70Hint.FontName = font;
        agp.section.agp.target70Hint.Color = [1 1 1];
        agp.section.agp.target70Hint.BackgroundColor = [19 152 79]/255;
        agp.section.agp.target70Hint.FontWeight = 'bold';
        agp.section.agp.target70Hint.EdgeColor = 'none';
        agp.section.agp.target70Hint.Position = [.055 .35 .03 .02];
        
        agp.section.agp.target180Hint = annotation('textbox','VerticalAlignment','middle','HorizontalAlignment','center');
        agp.section.agp.target180Hint.String = '180';
        
        agp.section.agp.target180Hint.FontName = font;
        agp.section.agp.target180Hint.Color = [1 1 1];
        agp.section.agp.target180Hint.BackgroundColor = [19 152 79]/255;
        agp.section.agp.target180Hint.FontWeight = 'bold';
        agp.section.agp.target180Hint.EdgeColor = 'none';
        agp.section.agp.target180Hint.Position = [.055 .445 .03 .02];
        
        %set(gca,'units','points','position',[80,250,480,180])
        
        
        %% Generate the Daily Glucose Profiles section

        %Title
        agp.section.dgp.title = annotation('textbox');
        agp.section.dgp.title.String = 'Daily Glucose Profiles';
        agp.section.dgp.FontName = font;
        agp.section.dgp.title.Color = [0 0 0]/255;
        agp.section.dgp.title.BackgroundColor = [224 224 223]/255;
        agp.section.dgp.title.FontWeight = 'bold';
        agp.section.dgp.title.FitBoxToText = 0;
        agp.section.dgp.title.EdgeColor = 'none';
        agp.section.dgp.title.Position = [.005 .25 .99 .02];
        
        agp.section.dgp.box = annotation('textbox');
        agp.section.dgp.box.EdgeColor = [224 224 223]/255;
        agp.section.dgp.box.Position = [.005 .005 .99 .25];
        
        agp.section.dgp.hint = generateDescription('Each daily profile represents a midnight-to-midnight period',...
            [.075 .22 .99 .02],'normal',10);

        for d = 1:nDays

            %Get the day of data
            dayData = data((data.Time >= firstDay + days(d-1)) & data.Time < (firstDay + days(d)),:);

            startTime = firstDay + days(d-1) + (data.Time(2)-data.Time(1))*3;
            endTime = firstDay + days(d) - (data.Time(2)-data.Time(1))*3;
            ax2 = subplot( 'Position',[.05+(.13*mod(d-1,7)), .12-.1*(floor((d-1)/7)),.12,.09]);
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
                agp.section.dgp.day.Position = [.05+(.13*mod(d-1,7)), .12-.1*(floor((d-1)/7)),.12,.09];
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
        if(isempty(dob))
            strDOB = '';
        else
            strDOB = ['_DOB-' dob];
        end
        strData = ['_from_' num2str(data.Time(1).Year) '-' num2str(data.Time(1).Month) '-' num2str(data.Time(1).Day) ...
            '_to_' num2str(data.Time(end).Year) '-' num2str(data.Time(end).Month) '-' num2str(data.Time(end).Day)];
        
        if(printFigure)
            print(f, '-dpng', ['AGP' strName strDOB strData '.png'])
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

function valid = validData(data)
    %Input validator function handler 
    
    valid = istimetable(data);
    if(~valid)
        error('generateAGP: data must be a timetable.');
    end
    
    valid = var(seconds(diff(data.Time))) == 0 && ~isnan(var(seconds(diff(data.Time))));
    if(~valid)
        error('generateAGP: data must have a homogeneous time grid.')
    end
    
    valid = any(strcmp(fieldnames(data),'Time'));
    if(~valid)
        error('generateAGP: data must have a column named `Time`.')
    end
    
    valid = any(strcmp(fieldnames(data),'glucose'));
    if(~valid)
        error('generateAGP: data must have a column named `glucose`.')
    end
    
end
