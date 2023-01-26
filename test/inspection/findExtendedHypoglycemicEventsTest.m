% Test units of the findExtendedHypoglycemicEvents function
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
data.glucose(10:13) = 50;
data.glucose(30:60) = 50;
data.glucose(32:33) = nan;
data.glucose(62:63) = 50;
data.glucose(70:72) = 50;
data.glucose(76:78) = 50;
data.glucose(80:82) = 50;
data.glucose(81) = nan;

%Extended hypoglycemic events generated:
%   - 2000-01-01 @ 02:45 - duration 02:30 (extended hypoglycemic event)

%% Test 1: check results structure field presence and length
results = findExtendedHypoglycemicEvents(data);
assert(isfield(results,'timeStart'));
assert(isfield(results,'timeEnd'));
assert(isfield(results,'duration'));
assert(isfield(results,'meanDuration'));
assert(isfield(results,'eventsPerWeek'));

%% Test 2: check results structure field length
results = findExtendedHypoglycemicEvents(data);
assert(length(results.timeStart) == length(results.duration));
assert(length(results.timeEnd) == length(results.duration));
assert(length(results.meanDuration) == 1);
assert(length(results.eventsPerWeek) == 1);

%% Test 3: check nan presence
results = findExtendedHypoglycemicEvents(data);
assert(~any(isnan(results.duration)));
assert(~any(isnat(results.timeStart)));
assert(~isnan(results.meanDuration));
assert(~isnan(results.eventsPerWeek));

%% Test 4: check results (with events)
results = findExtendedHypoglycemicEvents(data);
assert(results.timeStart(1) == datetime(2000,1,1,2,45,0));
assert(results.timeEnd(1) == datetime(2000,1,1,2,45,0)+minutes(150));
assert(results.duration(1) == 150);
assert(length(results.timeStart) == length(results.duration));
assert(length(results.timeStart) == 1);
assert(length(results.timeEnd) == length(results.duration));
assert(length(results.timeEnd) == 1);

assert(results.meanDuration == 150);
assert(results.eventsPerWeek == 24);

%% Test 5: check results (without events)
data.glucose(:) = 120;
results = findExtendedHypoglycemicEvents(data);
assert(isempty(results.timeStart));
assert(isempty(results.timeEnd));
assert(isempty(results.duration));
assert(isnan(results.meanDuration));
assert(results.eventsPerWeek == 0);











