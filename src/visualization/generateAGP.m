%function generateAGP(data,name,mrn) %name and mrn are optional
    close all
    
    figure;
    
    font = 'Arial';
    firstColumnStart = 0.005;
    secondColumnStart = 0.6;
    
    %Generate the panel
    x0 = 0;
    y0 = 0;
    width=640;
    height=1024;
    set(gcf,'units','points','position',[x0,y0,width,height]);

    
    
    %Generate the title
    agp.title = annotation('textbox');
    agp.title.String = 'AGP Report';
    agp.title.FontName = 'Arial';
    agp.title.FontWeight = 'bold';
    agp.title.FitBoxToText = 0;
    agp.title.Units = 'points';
    agp.title.Position = [5 700 120 25];
    agp.title.FontSize = 16;
    
    
   
    %Generate the sectioning
    agp.section.glucoseStatisticsAndTarget.title = annotation('textbox');
    agp.section.glucoseStatisticsAndTarget.title.String = 'GLUCOSE STATISTICS AND TARGET';
    agp.section.glucoseStatisticsAndTarget.FontName = font;
    agp.section.glucoseStatisticsAndTarget.title.Color = [1 1 1];
    agp.section.glucoseStatisticsAndTarget.title.BackgroundColor = [0 0 0];
    agp.section.glucoseStatisticsAndTarget.title.FontWeight = 'bold';
    agp.section.glucoseStatisticsAndTarget.title.FitBoxToText = 0;
    agp.section.glucoseStatisticsAndTarget.title.Units = 'points';
    agp.section.glucoseStatisticsAndTarget.title.Position = [5 675 350 20];
    
    agp.section.timeInRanges.title = annotation('textbox');
    agp.section.timeInRanges.title.String = 'TIME IN RANGES';
    agp.section.timeInRanges.title.FontName = font;
    agp.section.timeInRanges.title.Color = [1 1 1];
    agp.section.timeInRanges.title.BackgroundColor = [0 0 0];
    agp.section.timeInRanges.title.FontWeight = 'bold';
    agp.section.timeInRanges.title.FitBoxToText = 0;
    agp.section.timeInRanges.title.Units = 'points';
    agp.section.timeInRanges.title.Position = [360 675 275 20];
    agp.section.timeInRanges.title.FitBoxToText = 0;
    
    agp.section.agp.title = annotation('textbox');
    agp.section.agp.title.String = 'AMBULATORY GLUCOSE PROFILE (AGP)';
    agp.section.agp.title.FontName = font;
    agp.section.agp.title.Color = [1 1 1];
    agp.section.agp.title.BackgroundColor = [0 0 0];
    agp.section.agp.title.FontWeight = 'bold';
    agp.section.agp.title.FitBoxToText = 0;
    agp.section.agp.title.Units = 'points';
    agp.section.agp.title.Position = [5 470 630 20];
    
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
    agp.section.agp.description = generateDescription('AGP is a summary of glucose values from the report period, with median (50%) and other percentiles shown as if occuorring in a single day.',[5 455 600 15],'normal');    
    
    agp.section.dgp.description = generateDescription('Each daily profile represents a midnight to midnight period.', [5 185 600 15],'normal');
    agp.section.dgp.monday = generateDescription('Monday', [5 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Tuesday', [95 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Wednesday', [185 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Thursday', [275 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Friday', [365 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Saturday', [455 175 30 10],'bold');
    agp.section.dgp.monday = generateDescription('Sunday', [545 175 30 10],'bold');
    

%end

function description = generateDescription(text,position,weight)

    description = annotation('textbox');
    description.String = text;
    description.FontSize = 8;
    description.FontName = 'Arial';
    description.FitBoxToText = 0;
    description.Units = 'points';
    description.Position = position;
    description.EdgeColor = [1 1 1];
    description.FontWeight = weight;
    
end

