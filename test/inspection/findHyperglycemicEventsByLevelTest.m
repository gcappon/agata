% Test units of the findHyperglycemicEventsByLevel function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2023 Giacomo Cappon
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
data.glucose(35:40) = 300;
data.glucose(45:50) = 300;
data.glucose(32:33) = nan;
data.glucose(62:63) = 200;
data.glucose(70:72) = 200;
data.glucose(76:78) = 200;
data.glucose(80:82) = 200;
data.glucose(81) = nan;

%Hyperglycemic events generated:
%   - 2000-01-01 @ 00:45 - duration 00:20 (All + L1)
%   - 2000-01-01 @ 02:45 - duration 02:30 (All)
%   - 2000-01-01 @ 02:50 - duration 00:30 (L2)
%   - 2000-01-01 @ 03:40 - duration 00:30 (L2)
%   - 2000-01-01 @ 05:45 - duration 00:15 (All + L1)
%   - 2000-01-01 @ 06:15 - duration 00:35 (All + L1)

%% Test 1: check results structure field presence and length
results = findHyperglycemicEventsByLevel(data);
assert(isfield(results,'hyper'));
assert(isfield(results,'l1'));
assert(isfield(results,'l2'));
assert(isfield(results.hyper,'timeStart'));
assert(isfield(results.hyper,'timeEnd'));
assert(isfield(results.hyper,'duration'));
assert(isfield(results.hyper,'meanDuration'));
assert(isfield(results.hyper,'eventsPerWeek'));
assert(isfield(results.l1,'timeStart'));
assert(isfield(results.l1,'timeEnd'));
assert(isfield(results.l1,'duration'));
assert(isfield(results.l1,'meanDuration'));
assert(isfield(results.l1,'eventsPerWeek'));
assert(isfield(results.l2,'timeStart'));
assert(isfield(results.l2,'timeEnd'));
assert(isfield(results.l2,'duration'));
assert(isfield(results.l2,'meanDuration'));
assert(isfield(results.l2,'eventsPerWeek'));

%% Test 2: check results structure field length
results = findHyperglycemicEventsByLevel(data);
assert(length(results.hyper.timeStart) == length(results.hyper.duration));
assert(length(results.hyper.timeEnd) == length(results.hyper.duration));
assert(length(results.hyper.meanDuration) == 1);
assert(length(results.hyper.eventsPerWeek) == 1);
assert(length(results.l1.timeStart) == length(results.l1.duration));
assert(length(results.l1.timeEnd) == length(results.l1.duration));
assert(length(results.l1.meanDuration) == 1);
assert(length(results.l1.eventsPerWeek) == 1);
assert(length(results.l2.timeStart) == length(results.l2.duration));
assert(length(results.l2.timeEnd) == length(results.l2.duration));
assert(length(results.l2.meanDuration) == 1);
assert(length(results.l2.eventsPerWeek) == 1);

%% Test 3: check nan presence
results = findHyperglycemicEventsByLevel(data);
assert(~any(isnan(results.hyper.duration)));
assert(~any(isnat(results.hyper.timeStart)));
assert(~any(isnat(results.hyper.timeEnd)));
assert(~isnan(results.hyper.meanDuration));
assert(~isnan(results.hyper.eventsPerWeek));
assert(~any(isnan(results.l1.duration)));
assert(~any(isnat(results.l1.timeStart)));
assert(~any(isnat(results.l1.timeEnd)));
assert(~isnan(results.l1.meanDuration));
assert(~isnan(results.l1.eventsPerWeek));
assert(~any(isnan(results.l2.duration)));
assert(~any(isnat(results.l2.timeStart)));
assert(~any(isnat(results.l2.timeEnd)));
assert(~isnan(results.l2.meanDuration));
assert(~isnan(results.l2.eventsPerWeek));

%% Test 4: check results (with events)
results = findHyperglycemicEventsByLevel(data);
assert(results.hyper.timeStart(1) == datetime(2000,1,1,0,45,0));
assert(results.hyper.timeEnd(1) == datetime(2000,1,1,0,45,0)+minutes(20));
assert(results.hyper.duration(1) == 20);
assert(results.hyper.timeStart(2) == datetime(2000,1,1,2,45,0));
assert(results.hyper.timeEnd(2) == datetime(2000,1,1,2,45,0)+minutes(150));
assert(results.hyper.duration(2) == 150);
assert(results.hyper.timeStart(3) == datetime(2000,1,1,5,45,0));
assert(results.hyper.timeEnd(3) == datetime(2000,1,1,5,45,0)+minutes(15));
assert(results.hyper.duration(3) == 15);
assert(results.hyper.timeStart(4) == datetime(2000,1,1,6,15,0));
assert(results.hyper.timeEnd(4) == datetime(2000,1,1,6,15,0)+minutes(35));
assert(results.hyper.duration(4) == 35);
assert(length(results.hyper.timeStart) == length(results.hyper.duration));
assert(length(results.hyper.timeEnd) == length(results.hyper.duration));
assert(length(results.hyper.timeStart) == 4);

assert(results.hyper.meanDuration == 55);
assert(results.hyper.eventsPerWeek == 96);

assert(results.l1.timeStart(1) == datetime(2000,1,1,0,45,0));
assert(results.l1.timeEnd(1) == datetime(2000,1,1,0,45,0)+minutes(20));
assert(results.l1.duration(1) == 20);
assert(results.l1.timeStart(2) == datetime(2000,1,1,5,45,0));
assert(results.l1.timeEnd(2) == datetime(2000,1,1,5,45,0)+minutes(15));
assert(results.l1.duration(2) == 15);
assert(results.l1.timeStart(3) == datetime(2000,1,1,6,15,0));
assert(results.l1.timeEnd(3) == datetime(2000,1,1,6,15,0)+minutes(35));
assert(results.l1.duration(3) == 35);
assert(length(results.l1.timeStart) == length(results.l1.duration));
assert(length(results.l1.timeEnd) == length(results.l1.duration));
assert(length(results.l1.timeStart) == 3);

assert(round(results.l1.meanDuration*100)/100 == 23.33);
assert(results.l1.eventsPerWeek == 72);

assert(results.l2.timeStart(1) == datetime(2000,1,1,2,50,0));
assert(results.l2.timeEnd(1) == datetime(2000,1,1,2,50,0)+minutes(30));
assert(results.l2.duration(1) == 30);
assert(results.l2.timeStart(2) == datetime(2000,1,1,3,40,0));
assert(results.l2.timeEnd(2) == datetime(2000,1,1,3,40,0)+minutes(30));
assert(results.l2.duration(2) == 30);
assert(length(results.l2.timeStart) == length(results.l2.duration));
assert(length(results.l2.timeEnd) == length(results.l2.duration));
assert(length(results.l2.timeStart) == 2);

assert(results.l2.meanDuration == 30);
assert(results.l2.eventsPerWeek == 48);

%% Test 5: check results (without events)
data.glucose(:) = 120;
results = findHyperglycemicEventsByLevel(data);
assert(isempty(results.hyper.timeStart));
assert(isempty(results.hyper.timeEnd));
assert(isempty(results.hyper.duration));
assert(isempty(results.l1.timeStart));
assert(isempty(results.l1.timeEnd));
assert(isempty(results.l1.duration));
assert(isempty(results.l2.timeStart));
assert(isempty(results.l2.timeEnd));
assert(isempty(results.l2.duration));

assert(isnan(results.hyper.meanDuration));
assert(results.hyper.eventsPerWeek == 0);

assert(isnan(results.l1.meanDuration));
assert(results.l1.eventsPerWeek == 0);

assert(isnan(results.l2.meanDuration));
assert(results.l2.eventsPerWeek == 0);











