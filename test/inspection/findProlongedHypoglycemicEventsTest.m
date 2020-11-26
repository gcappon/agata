% Test units of the findHypoglycemicEvents function
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

%Prolonged hypoglycemic events generated:
%   - 2000-01-01 @ 02:45 - duration 02:30 (prolonged hypoglycemic event)

%% Test 1: check results structure field presence and length
results = findProlongedHypoglycemicEvents(data);
assert(isfield(results,'time'));
assert(isfield(results,'duration'));

%% Test 2: check results structure field length
results = findProlongedHypoglycemicEvents(data);
assert(length(results.time) == length(results.duration));

%% Test 3: check nan presence
results = findProlongedHypoglycemicEvents(data);
assert(~any(isnan(results.duration)));
assert(~any(isnat(results.time)));

%% Test 4: check results (with events)
results = findProlongedHypoglycemicEvents(data);
assert(results.time(1) == datetime(2000,1,1,2,45,0));
assert(results.duration(1) == 150);
assert(length(results.time) == length(results.duration));
assert(length(results.time) == 1);

%% Test 5: check results (without events)
data.glucose(:) = 120;
results = findProlongedHypoglycemicEvents(data);
assert(isempty(results.time));
assert(isempty(results.duration));













