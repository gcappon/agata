function data = readFreestyleLibreData(file)
%readEversenseData function that reads data from a .xlsx file downloaded
%from the Freestyle Libre CGM system and converts it in a timetable compatible with
%AGATA.
%
%Inputs:
%   - filename: a vector of characters containing the relative path to the
%   .xslx file to be converted in a timetable compatible with AGATA. 
%Output:
%   - dataTimetable: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%
%Preconditions:
%   - `file` must be a vector of characters.
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
    
    %Check preconditions 
    if(~ischar(file))
        error('readFreestyleLibreData: the provided file path must be a vector of characters.');
    end
    if(exist(file,'file')~=2)
        error('readFreestyleLibreData: the provided file path refers to a file that does not exist.');
    end
    
    
    %Read file 
    raw = readtable(file);
    
    %Initialize time and glucose vectors    
    time = NaT(size(raw,1),1);
    glucose = zeros(size(raw,1),1);
    
    count = 0;
    %Process the sheet rows
    for r = 1:size(raw,1)
        
        if(strcmp(raw{r,1},'FreeStyle'))
            
            try
            %Get the complete timestamp
            hour = datetime(raw{r,5},'ConvertFrom','excel');
            time(count+1) = datetime(datestr(raw{r,4}))+minutes(hour.Minute)+hours(hour.Hour);
            
            %Get the glucose value
            glucose(count+1) = str2double(cell2mat(raw{r,7}));
            
            count = count +1;
            catch exception
            end 
        end
        
    end
    
    %Cut unecessary rows
    time = time(1:count);
    glucose = glucose(1:count);
    
    %Sort by time
    [~,idx] = sort(time);
    
    %Convert to timetable compatible with AGATA
    data = timetable(glucose(idx),'VariableNames', {'glucose'}, 'RowTimes', time(idx));
    
end

