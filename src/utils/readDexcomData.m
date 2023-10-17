function data = readDexcomData(file)
%readDexcomData function that reads data from a .xlsx file downloaded
%from the Dexcom CGM system and converts it in a timetable compatible with
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
        error('readDexcomData: the provided file path must be a vector of characters.');
    end
    if(exist(file,'file')~=2)
        error('readDexcomData: the provided file path refers to a file that does not exist.');
    end
    
    
    %Read file 
    raw = readtable(file);
    
    %Initialize time and glucose vectors
    time = NaT(size(raw,1)-1,1);
    glucose = zeros(size(raw,1)-1,1);
    
    %Initialize an index that counts the number of EGVs
    count = 0;
    
    %Process the sheet rows
    for r = 2:size(raw,1)
        
        %If the type of the row is 'EGV'...
        if(strcmp(raw{r,3},'EGV'))
            
            %...read the EGV.
            time(count+1) = datetime(raw{r,2},'InputFormat','yyyy-MM-dd''T''HH:mm:ss');
            if(iscell(raw{r,8}))
                d = cell2mat(raw{r,8});
            else
                d = raw{r,8};
            end
            if(ischar(d) || isstring(d))
                if(strcmp(d,'Low'))
                    d = nan;
                else
                    if(strcmp(d,'High'))
                        d = nan;
                    else
                        d = str2num(d);
                    end
                end
            end
            if(isempty(d))
                d = nan;
            end
            glucose(count+1) = d;
            count = count + 1;
            
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

