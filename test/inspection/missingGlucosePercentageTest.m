% Test units of the missingGlucosePercentage function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','inspection'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(45); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 60;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9) = 260;
data.glucose(10) = nan;

%% Test 1: check NaN presence
results = missingGlucosePercentage(data);
assert(~isnan(results));

%% Test 2: check percentages calculation
results = missingGlucosePercentage(data);
assert(results == 10);