function [profileAssessment,profileCoordinates, bestControlIndex, bestControlledCoordinates]=CVGA(glucoseProfiles)
%CVGA function that performs the control variablity grid analysis (CVGA).
%
%Input:
%   - glucoseProfiles: a cell array of timetables each with column `Time` and 
%   `glucose` containing the glucose data to analyze (in mg/dl). 
%Outputs:
%   - profileAssessment: a vector of double containing, for each timetable 
%   in `glucoseProfiles`, the euclidian distance of each point in the CVGA
%   space from the CVGA origin;
%   - profileCoordinates: A bidimensional vector containing in the first 
%   column the CVGA coordinate in the x-axis and in the second column the
%   CVGA coordinate in the y-axis of each glucose profile;
%   - bestControlIndex: an integer containing the index of the best glucose 
%   profile (i.e the glucose profile with minimum euclidian distance);
%   - bestControlledCoordinates: A bidimensional vector containing in the 
%   first column the CVGA coordinate in the x-axis and in the second column
%   the CVGA coordinate in the y-axis of the best glucose profile (i.e., 
%   the glucose profile with minimum `profileAssessment` value).
%
%Preconditions:
%   - glucoseProfiles must be a timetable or a cell array containing timetables;
%   - Each timetable in glucoseProfiles must have a column names `Time` and a
%   column named `glucose`.
%
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - Magni et al., "Evaluating the efficacy of closed-loop glucose 
%  regulation via control-variability grid analysis", Journal of Diabetes 
%  Science and Technology, 2008, vol. 2, pp. 630-635. DOI:
%  10.1177/193229680800200414.
%
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Simone Del Favero
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Use input parser to check preconditions
    params = inputParser;
    params.CaseSensitive = false;
    addRequired(params,'glucoseProfiles',@(x) validGlucoseProfiles(x));
    parse(params,glucoseProfiles);
    
    %Convert glucoseProfiles to a cell array if it is a timetable
    if(istimetable(glucoseProfiles))
        glucoseProfiles = {glucoseProfiles};
    end
    
    
    if ~isempty(glucoseProfiles)
        
        %Preallocate arrays
        minBG = zeros(size(glucoseProfiles,1),1);
        maxBG = zeros(size(glucoseProfiles,1),1);
        profileCoordinates = zeros(size(glucoseProfiles,1),2);
        profileAssessment = zeros(size(glucoseProfiles,1),1);
        
        %For all the experiments/BG profiles...
        for ind=1:length(glucoseProfiles)
            
            %...compute Min BG and Max BG measured during the current
            %experiment...
            minBG(ind) = nanmin(glucoseProfiles{ind}.glucose);
            maxBG(ind) = nanmax(glucoseProfiles{ind}.glucose);

            %...generate CVGA coordinates...
            [profileCoordinates(ind,1),profileCoordinates(ind,2)]=CVGACoordinates(maxBG(ind),minBG(ind));

            %...and assess the current experiment
            profileAssessment(ind)=profileCoordinates(ind,1)^2+profileCoordinates(ind,2)^2; % (square) distance form the CVGA origin
            
        end


        %Find the experiemnt that produced better control
        [~, bestControlIndex]= nanmin(profileAssessment);  
        
        bestControlledCoordinates=[ profileCoordinates(bestControlIndex,1), profileCoordinates(bestControlIndex,2) ];
        
    else
        bestControlIndex=NaN;
        bestControlledCoordinates=[NaN NaN];
    end
    
end

function [X,Y]=CVGACoordinates(maxBG,minBG)
%transforms (maxBG, minBG) into CVGA coordinates

    X=min(max(110 - minBG,0),60);
    p=polyfit([110 180 300 400],[0 20 40 60],3);
    Y = polyval(p,maxBG);

end

function valid = validGlucoseProfiles(glucoseProfiles)
    %Input validator function handler 
    
    valid = iscell(glucoseProfiles) || (istimetable(glucoseProfiles));
    
    if(~valid)
        error('CVGA: glucoseProfiles must be a cell array or a timetable.');
    end
    
    if(iscell(glucoseProfiles))
        for g = 1:length(glucoseProfiles)

            valid = valid && istimetable(glucoseProfiles{g});

            if(~valid)
                error(['CVGA: glucoseProfiles in position ' num2str(g) ' must be a timetable.']);
            end


            valid = valid && any(strcmp(fieldnames(glucoseProfiles{g}),'glucose'));

            if(~valid)
                error(['CVGA: glucoseProfiles in position ' num2str(g) ' must contain a column named glucose.']);
            end

            valid = valid && any(strcmp(fieldnames(glucoseProfiles{g}),'Time'));

            if(~valid)
                error(['CVGA: glucoseProfiles in position ' num2str(g) ' must contain a column named Time.']);
            end

        end
    else
        

            if(~any(strcmp(fieldnames(glucoseProfiles),'glucose')))
                error(['CVGA: glucoseProfiles must contain a column named glucose.']);
            end

            if(~any(strcmp(fieldnames(glucoseProfiles),'Time')))
                error(['CVGA: glucoseProfiles must contain a column named Time.']);
            end
        
    end
    
end