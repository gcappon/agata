% Test units of the imputeGlucose function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','processing'));
addpath(fullfile('..','..','src','inspection'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(120);
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(:) = 120;
data.glucose(2:3) = nan;
data.glucose(10:20) = nan;
data.glucose(22) = nan;

%% Test 1: check the length of results
results = imputeGlucose(data, 15);
assert(height(data) == height(results));

%% Test 2: check the interpolated data
results = imputeGlucose(data, 15);
assert(results.glucose(2) == 120);
assert(results.glucose(3) == 120);
assert(results.glucose(22) == 120);

%% Test 3: check the non interpolated data
results = imputeGlucose(data, 15);
assert(all(isnan(data.glucose(10:20))));
















