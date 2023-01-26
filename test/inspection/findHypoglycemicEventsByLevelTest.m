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
data.glucose(10:13) = 60;
data.glucose(30:60) = 60;
data.glucose(35:40) = 50;
data.glucose(45:50) = 50;
data.glucose(32:33) = nan;
data.glucose(62:63) = 0;
data.glucose(70:72) = 60;
data.glucose(76:78) = 60;
data.glucose(80:82) = 60;
data.glucose(81) = nan;

%Hyperglycemic events generated:
%   - 2000-01-01 @ 00:45 - duration 00:20 (All + L1)
%   - 2000-01-01 @ 02:45 - duration 02:30 (All)
%   - 2000-01-01 @ 02:50 - duration 00:30 (L2)
%   - 2000-01-01 @ 03:40 - duration 00:30 (L2)
%   - 2000-01-01 @ 05:45 - duration 00:15 (All + L1)
%   - 2000-01-01 @ 06:15 - duration 00:35 (All + L1)

%% Test 1: check results structure field presence and length
results = findHypoglycemicEventsByLevel(data);
assert(isfield(results,'hypo'));
assert(isfield(results,'l1'));
assert(isfield(results,'l2'));
assert(isfield(results.hypo,'timeStart'));
assert(isfield(results.hypo,'timeEnd'));
assert(isfield(results.hypo,'duration'));
assert(isfield(results.hypo,'meanDuration'));
assert(isfield(results.hypo,'eventsPerWeek'));
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
results = findHypoglycemicEventsByLevel(data);
assert(length(results.hypo.timeStart) == length(results.hypo.duration));
assert(length(results.hypo.timeEnd) == length(results.hypo.duration));
assert(length(results.hypo.meanDuration) == 1);
assert(length(results.hypo.eventsPerWeek) == 1);
assert(length(results.l1.timeStart) == length(results.l1.duration));
assert(length(results.l1.timeEnd) == length(results.l1.duration));
assert(length(results.l1.meanDuration) == 1);
assert(length(results.l1.eventsPerWeek) == 1);
assert(length(results.l2.timeStart) == length(results.l2.duration));
assert(length(results.l2.timeEnd) == length(results.l2.duration));
assert(length(results.l2.meanDuration) == 1);
assert(length(results.l2.eventsPerWeek) == 1);

%% Test 3: check nan presence
results = findHypoglycemicEventsByLevel(data);
assert(~any(isnan(results.hypo.duration)));
assert(~any(isnat(results.hypo.timeStart)));
assert(~any(isnat(results.hypo.timeEnd)));
assert(~isnan(results.hypo.meanDuration));
assert(~isnan(results.hypo.eventsPerWeek));
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
results = findHypoglycemicEventsByLevel(data);
assert(results.hypo.timeStart(1) == datetime(2000,1,1,0,45,0));
assert(results.hypo.timeEnd(1) == datetime(2000,1,1,0,45,0)+minutes(20));
assert(results.hypo.duration(1) == 20);
assert(results.hypo.timeStart(2) == datetime(2000,1,1,2,45,0));
assert(results.hypo.timeEnd(2) == datetime(2000,1,1,2,45,0)+minutes(150));
assert(results.hypo.duration(2) == 150);
assert(results.hypo.timeStart(3) == datetime(2000,1,1,5,45,0));
assert(results.hypo.timeEnd(3) == datetime(2000,1,1,5,45,0)+minutes(15));
assert(results.hypo.duration(3) == 15);
assert(results.hypo.timeStart(4) == datetime(2000,1,1,6,15,0));
assert(results.hypo.timeEnd(4) == datetime(2000,1,1,6,15,0)+minutes(35));
assert(results.hypo.duration(4) == 35);
assert(length(results.hypo.timeStart) == length(results.hypo.duration));
assert(length(results.hypo.timeEnd) == length(results.hypo.duration));
assert(length(results.hypo.timeStart) == 4);

assert(results.hypo.meanDuration == 55);
assert(results.hypo.eventsPerWeek == 96);

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
results = findHypoglycemicEventsByLevel(data);
assert(isempty(results.hypo.timeStart));
assert(isempty(results.hypo.timeEnd));
assert(isempty(results.hypo.duration));
assert(isempty(results.l1.timeStart));
assert(isempty(results.l1.timeEnd));
assert(isempty(results.l1.duration));
assert(isempty(results.l2.timeStart));
assert(isempty(results.l2.timeEnd));
assert(isempty(results.l2.duration));

assert(isnan(results.hypo.meanDuration));
assert(results.hypo.eventsPerWeek == 0);

assert(isnan(results.l1.meanDuration));
assert(results.l1.eventsPerWeek == 0);

assert(isnan(results.l2.meanDuration));
assert(results.l2.eventsPerWeek == 0);













