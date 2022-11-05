function magePlusIndex = magePlusIndex(data)
%magePlusIndex function that computes the mean amplitude of positive 
%glycemic excursion (MAGE+) index (ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - magePlusIndex: the mean amplitude of positive glycemic excursion (MAGE+) index
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid;
%   - data must contain a column named `Time` and another named `glucose`.
% 
% ------------------------------------------------------------------------
% 
% Reference:
%   - Service et al., "Mean amplitude of glycemic excursions, a measure of 
%   diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 
%   10.2337/diab.19.9.644.
% 
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('magePlusIndex: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('magePlusIndex: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('magePlusIndex: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('magePlusIndex: data must have a column named `glucose`.')
    end
    
    %Compute the number of days in a safe way (but long) way
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
        
    mageDayPlus = zeros(nDays,1);
    for d = 1:nDays
    
        %Step 0: parameters
        
        %Get the day of data
        dayData = data((data.Time >= firstDay + days(d-1)) & data.Time < (firstDay + days(d)),:);
        
        %Get glucose values (might be nan)
        dayData = dayData.glucose;
        stdWithin = nanstd(dayData);
        n = length(dayData);
        
        
        if(n > 3)
            %Step 1: turning points are only local extrema
            [~, iMax] = findpeaks(dayData);
            [~, iMin] = findpeaks(-dayData);
            
            iTurning = union([1; n; iMax], iMin);
            
            turning = dayData(iTurning);
            nTurning = length(iTurning);
            
            %Step 2: Turning points of no interest are removed
            % A turning point is removed if it's not significantly different from 
            % BOTH its left and right-hand side RETAINED neighbours.
            
            toBeDeleted = false(nTurning, 1);
            
            for i = 2:nTurning-1    % First and last samples are retained
        
                condition1 = abs(turning(i)-turning(i-1)) < stdWithin;
                condition2 = abs(turning(i+1)-turning(i)) < stdWithin;
                deletionCondition = condition1 && condition2;
        
                toBeDeleted(i) = deletionCondition;
        
            end
            
            iTurning = iTurning(~toBeDeleted);
            
            %Step 3. Turning points are removed again or moved appropriately.
            % Turning points in the middle of a 3-points monotonic sequence are
            % removed, while turning points that would be retained this way are
            % moved to the closest appropriate local extrema.
            
            i = 2; % Counter
            while i < length(iTurning)

                prev = iTurning(i-1);
                curr = iTurning(i);
                next = iTurning(i+1);

                prevSlope = dayData(curr) - dayData(prev);
                nextSlope = dayData(next) - dayData(curr);

                if prevSlope < 0 && nextSlope > 0 % Minimum

                    % The actual current turning point is the min in the interval
                    [~, temp] = min(dayData(prev:next));
                    curr = prev+temp-1;
                    iTurning(i) = curr;

                    % The actual previous turning point is the max to the left of
                    % the current turning point.
                    [~, temp] = max(dayData(prev:curr-1));
                    iTurning(i-1) = prev+temp-1;

                    % The actual following turning point is the max to the right of
                    % the current turning point.
                    [~, temp] = max(dayData(curr+1:next));
                    iTurning(i+1) = curr+temp;

                    i = i + 1;

                elseif prevSlope > 0 && nextSlope < 0 % Maximum

                    % The actual current turning point is the max in the interval
                    [~, temp] = max(dayData(prev:next));
                    curr = prev+temp-1;
                    iTurning(i) = curr;

                    % The actual previous turning point is the min to the left of
                    % the current turning point.
                    [~, temp] = min(dayData(prev:curr-1));
                    iTurning(i-1) = prev+temp-1;

                    % The actual following turning point is the min to the right of
                    % the current turning point.
                    [~, temp] = min(dayData(curr+1:next));
                    iTurning(i+1) = curr+temp;


                    i = i + 1;

                else % Middle point
                    % Just remove the turning point
                    iTurning(i) = [];
                end %if

            end %while 
            
            %Step 4. Remove residual spurious turning points
            % Turning points not significantly different from EITHER neighbour are
            % removed. Some extra processing is needed for the first and last sample.
            
            % First sample processing
            sample1 = dayData(iTurning(1));
            sample2 = dayData(iTurning(2));

            if abs(sample2 - sample1) < stdWithin
                iTurning(1) = [];
            end
            
            if(length(iTurning) > 1)
                % Last sample processing;
                sample1 = dayData(iTurning(end-1));
                sample2 = dayData(iTurning(end));

                if abs(sample2 - sample1) < stdWithin
                    iTurning(end) = [];
                end
            end 
            

            turning = dayData(iTurning);
            nTurning = length(iTurning);

            % Internal points
            toBeDeleted = false(nTurning, 1);
            for i = 2:nTurning-1

                condition1 = abs(turning(i)-turning(i-1)) < stdWithin;
                condition2 = abs(turning(i+1)-turning(i)) < stdWithin;
                deletionCondition = condition1 || condition2;

                toBeDeleted(i) = deletionCondition;

            end

            iTurning = iTurning(~toBeDeleted);
            turning = dayData(iTurning);
            
            %Step 5. Compute daily MAGE+
            excursions = diff(turning);
            mageDayPlus(d) = nanmean(excursions(excursions>0));
    
        else
            
            mageDayPlus(d) = nan;
            
        end % if n > 3
        
    end %for 
    
    %Compute index
    mageDayPlus(isnan(mageDayPlus)) = 0; % Correct for 'mean' behaviour
    magePlusIndex = mean(mageDayPlus);
    
    %Manage all nan data
    if(all(isnan(data.glucose)))
        magePlusIndex = nan;
    end
    
end

