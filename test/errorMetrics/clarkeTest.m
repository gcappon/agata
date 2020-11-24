% Test units of the clarke function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','errorMetrics'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:6) = 180;
data.glucose(7:8) = 170;
data.glucose(9:10) = 260;
data.glucose(11) = nan;

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
dataHat = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
dataHat.glucose(1) = 80;
dataHat.glucose(2:3) = 80;
dataHat.glucose(4) = 70;
dataHat.glucose(5:6) = 130;
dataHat.glucose(7:8) = nan;
dataHat.glucose(9:10) = 60;
dataHat.glucose(11) = 60;

%% Test 1: check NaN presence
results = clarke(data,dataHat);
assert(~isempty(results));

%% Test 2: check sum up to 0
results = clarke(data,dataHat);
assert((results.A + results.B + results.C + results.D + results.E)  == 100);

%% Test 3: check results calculation
results = clarke(data,dataHat);
assert(results.A == 12.5);
assert(results.B == 25);
assert(results.C == 0);
assert(results.D == 37.5);
assert(results.E == 25);