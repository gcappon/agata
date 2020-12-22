% Test units of the detrendGlucose function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','processing'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(95);
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(:) = 100:5:195;
data.glucose(1:3) = nan;
data.glucose(10:20) = nan;

%% Test 1: check the length of results
results = detrendGlucose(data);
assert(height(data) == height(results));

%% Test 2: check the interpolated data
results = detrendGlucose(data);
assert(results.glucose(4) == 100);
assert(results.glucose(5) == 100);
assert(results.glucose(6) == 100);
assert(results.glucose(7) == 100);
assert(results.glucose(8) == 100);
assert(results.glucose(9) == 100);

%% Test 3: check the non interpolated data
results = detrendGlucose(data);
assert(all(isnan(data.glucose([1:3 10:20]))));
















