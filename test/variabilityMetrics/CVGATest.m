% Test units of the CVGA function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','variabilityMetrics'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 100;
data.glucose(2:3) = 75;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 260;
data.glucose(11) = nan;
glucoseProfiles{1} = data;

time = datetime(2000,1,1,0,4,0):minutes(3):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(100*ones(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 80;
data.glucose(2:3) = nan;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 220;
data.glucose(11) = nan;
glucoseProfiles{2} = data;

%% Test 1: check NaN presence
[profileAssessment,profileCoordinates, bestControlIndex, bestControlledCoordinates] = CVGA(glucoseProfiles);
assert(~any(isnan(profileAssessment(:))));
assert(~any(isnan(profileCoordinates(:))));
assert(~isnan(bestControlIndex));
assert(~any(isnan(bestControlledCoordinates(:))));

%% Test 2: check results calculation
[profileAssessment,profileCoordinates, bestControlIndex, bestControlledCoordinates] = CVGA(glucoseProfiles);
profileAssessment = round(profileAssessment/100)*100;
profileCoordinates = round(profileCoordinates*100)/100;
bestControlledCoordinates = round(bestControlledCoordinates*100)/100;

assert(profileAssessment(1) == 2400);
assert(profileAssessment(2) == 1700);
assert(profileCoordinates(1,1) == 35);
assert(profileCoordinates(2,1) == 30);
assert(profileCoordinates(1,2) == 34.05);
assert(profileCoordinates(2,2) == 27.73);
assert(bestControlIndex == 2);
assert(bestControlledCoordinates(1) == 30);
assert(bestControlledCoordinates(2) == 27.73);