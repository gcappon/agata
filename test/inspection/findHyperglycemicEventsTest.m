% Test units of the findHyperglycemicEvents function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','inspection'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(420);
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(:) = 120;
data.glucose(10:13) = 200;
data.glucose(30:60) = 200;
data.glucose(32:33) = nan;
data.glucose(62:63) = 200;
data.glucose(70:72) = 200;
data.glucose(76:78) = 200;
data.glucose(80:82) = 200;
data.glucose(81) = nan;

%Hyperglycemic events generated:
%   - 2000-01-01 @ 00:45 - duration 00:20 
%   - 2000-01-01 @ 02:45 - duration 02:30 
%   - 2000-01-01 @ 05:45 - duration 00:15 
%   - 2000-01-01 @ 06:15 - duration 00:35

%% Test 1: check results structure field presence and length
results = findHyperglycemicEvents(data);
assert(isfield(results,'time'));
assert(isfield(results,'duration'));

%% Test 2: check results structure field length
results = findHyperglycemicEvents(data);
assert(length(results.time) == length(results.duration));

%% Test 3: check nan presence
results = findHyperglycemicEvents(data);
assert(~any(isnan(results.duration)));
assert(~any(isnat(results.time)));

%% Test 4: check results (with events)
results = findHyperglycemicEvents(data);
assert(results.time(1) == datetime(2000,1,1,0,45,0));
assert(results.duration(1) == 20);
assert(results.time(2) == datetime(2000,1,1,2,45,0));
assert(results.duration(2) == 150);
assert(results.time(3) == datetime(2000,1,1,5,45,0));
assert(results.duration(3) == 15);
assert(results.time(4) == datetime(2000,1,1,6,15,0));
assert(results.duration(4) == 35);
assert(length(results.time) == length(results.duration));
assert(length(results.time) == 4);

%% Test 5: check results (with custom threshold)
results = findHyperglycemicEvents(data, 'th', 205);
assert(isempty(results.time));
assert(isempty(results.duration))

%% Test 6: check results (without events)
data.glucose(:) = 120;
results = findHyperglycemicEvents(data);
assert(isempty(results.time));
assert(isempty(results.duration));













