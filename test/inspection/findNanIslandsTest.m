% Test units of the findNanIslands function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','inspection'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(115); % length = 24;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:9) = nan;
data.glucose(10:11) = 200;
data.glucose(12:15) = 260;
data.glucose(16:17) = nan;
data.glucose(18) = 180;
data.glucose(19) = nan;
data.glucose(20) = 140;
data.glucose(21:24) = nan;

%% Test 1: check NaN presence
[shortNan, longNan, nanStart, nanEnd] = findNanIslands(data.glucose,0);

assert(~any(isnan(shortNan)));
assert(~any(isnan(longNan)));
assert(~any(isnan(nanStart)));
assert(~any(isnan(nanEnd)));

%% Test 2: check nanStart calculation
[~, ~, nanStart, ~] = findNanIslands(data.glucose,2);

assert(nanStart(1) == 5);
assert(nanStart(2) == 16);
assert(nanStart(3) == 19);
assert(nanStart(4) == 21);
assert(length(nanStart) == 4);

%% Test 3: check nanEnd calculation
[~, ~, ~, nanEnd] = findNanIslands(data.glucose,2);

assert(nanEnd(1) == 9);
assert(nanEnd(2) == 17);
assert(nanEnd(3) == 19);
assert(nanEnd(4) == 24);
assert(length(nanEnd) == 4);

%% Test 4a: check shortNan calculation (TH = 3)
[shortNan, ~, ~, ~] = findNanIslands(data.glucose,3);

assert(shortNan(1) == 16);
assert(shortNan(2) == 17);
assert(shortNan(3) == 19);
assert(length(shortNan) == 3);

%% Test 4b: check shortNan calculation (TH = inf)
[shortNan, ~, ~, ~] = findNanIslands(data.glucose,inf);
assert(length(shortNan) == 12);

%% Test 4c: check shortNan calculation (TH = 1)
[shortNan, ~, ~, ~] = findNanIslands(data.glucose,1);
assert(length(shortNan) == 0);

%% Test 5a: check longNan calculation (TH = 4)
[~, longNan, ~, ~] = findNanIslands(data.glucose,4);

assert(longNan(1) == 5);
assert(longNan(2) == 6);
assert(longNan(3) == 7);
assert(longNan(4) == 8);
assert(longNan(5) == 9);
assert(longNan(6) == 21);
assert(longNan(7) == 22);
assert(longNan(8) == 23);
assert(longNan(9) == 24);
assert(length(longNan) == 9);

%% Test 5b: check longNan calculation (TH = inf)
[~, longNan, ~, ~] = findNanIslands(data.glucose,inf);
assert(length(longNan) == 0);

%% Test 5c: check longNan calculation (TH = 1)
[~, longNan, ~, ~] = findNanIslands(data.glucose,1);
assert(length(longNan) == 12);
