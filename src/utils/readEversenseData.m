function data = readEversenseData(file)
%readEversenseData function that reads data from a .xlsx file downloaded
%from the Eversense CGM system and converts it in a timetable compatible with
%AGATA.
%
%Inputs:
%   - file: a vector of characters containing the relative path to the
%   .xslx file to be converted in a timetable compatible with AGATA. 
%Output:
%   - data: a timetable with column `Time` and `glucose` containing the 
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
        error('readEversenseData: the provided file path must be a vector of characters.');
    end
    if(exist(file,'file')~=2)
        error('readEversenseData: the provided file path refers to a file that does not exist.');
    end
    
    
    %Read file 
    raw = readtable(file);
    
    %Initialize time and glucose vectors    
    time = NaT(size(raw,1)-1,1);
    glucose = zeros(size(raw,1)-1,1);
    
    %Process the sheet rows
    for r = 2:size(raw,1)
        
        %Get the complete timestamp
        time(r-1) = datestr([cell2mat(raw{r,1}) ' ' cell2mat(raw{r,2})]);
        
        %Get the glucose value in mg/dL
        is_mg_dl = strcmp(cell2mat(raw{r,4}),'mg/dL');
        if(is_mg_dl)
            glucose(r-1) = raw{r,3};
        else
            glucose(r-1) = raw{r,3}*18.018;
        end
        
    end
    
    %Sort by time
    [~,idx] = sort(time);
    
    %Convert to timetable compatible with AGATA
    data = timetable(glucose(idx),'VariableNames', {'glucose'}, 'RowTimes', time(idx));
    
end

