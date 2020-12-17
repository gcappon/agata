function [shortNan, longNan, nanStart, nanEnd] = findNanIslands(data,TH)
% findNanIslands function that locates nan sequences in vector `data`, and 
%classifies them based on their length (longer or not than the specified
%threshold `TH`).
%
% Inputs:
%   - data: an array of equally spaced (in time) values;
%   - TH: threshold, expressed in number of samples, to distinguish between
%   long and short nan sequences.
% Outputs:
%   - shortNan: indices of "short nan" sequences (i.e., sequences shorter
%   than TH consecutive nan samples);
%   - longNan: indices of "long nan" sequences (i.e., sequences having TH 
%   consecutive nan samples or more);
%   - nanStart: start of nan sequences;
%   - nanEnd: end of nan sequences.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`;
%   - TH must be an integer.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - None
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Lorenzo Meneghetti
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('findNanIslands: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('findNanIslands: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('findNanIslands: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('findNanIslands: data must have a column named `glucose`.')
    end
    if( ~( isnumeric(TH) && ((TH - round(TH)) == 0) ) )
        error('findNanIslands: TH must be an integer.')
    end
    
    
    % make input as column
    data=data.glucose(:);

    %% locate nan sequences

    nanInd=isnan(data);
    nanInd=double(nanInd);
    tmp = find(diff(nanInd));

    % if nan sequence starts from first index
    firstIsNan=nanInd(1);
    if firstIsNan
        tmp=[0; tmp];
    end

    % if nan sequence ends on last index
    lastIsNan=nanInd(end);
    if lastIsNan
        tmp=[tmp; length(data)];
    end

    if length(tmp)==1
        % only one nan sequence
        N=length(find(nanInd));
        nanIntervals=[tmp+1 tmp+N];
        nanSequencesLength=N;
    else
        % more than one nan sequence
        nanIntervals=[tmp(1:2:end) tmp(2:2:end)];
        nanIntervals(:,1)=nanIntervals(:,1)+1;
        nanSequencesLength = nanIntervals(:,2)-nanIntervals(:,1)+1;
    end

    % start and end indices of each sequence
    nanStart=nanIntervals(:,1);
    nanEnd=nanIntervals(:,2);

    %% classification based on length

    % find long and short sequence based on th
    longSeq=nanIntervals(nanSequencesLength>=TH,:);
    shortSeq=nanIntervals(nanSequencesLength<TH,:);

    % indices of long nan sequences
    longNan=[];
    for j=1:size(longSeq,1)
        longNan=[longNan longSeq(j,1):1:longSeq(j,end)];
    end

    % indices of short nan sequences
    shortNan=[];
    for j=1:size(shortSeq,1)
        shortNan=[shortNan shortSeq(j,1):1:shortSeq(j,end)];
    end

end