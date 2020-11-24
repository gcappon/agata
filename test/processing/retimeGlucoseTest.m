% Test units of the retimeGlucose function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','processing'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(25); % length = 6;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.Time.Second = [17; 33; 58; 58; 10; 59];
data.glucose(1) = 40;
data.glucose(2) = 50;
data.glucose(3:4) = nan;
data.glucose(5:6) = 120;


%% Test 1: check retime (timestep = 5)
results = retimeGlucose(data,5);

assert(results.glucose(1) == 40);
assert(results.glucose(2) == 50);
assert(isnan(results.glucose(3)));
assert(isnan(results.glucose(4)));
assert(results.glucose(5) == 120);
assert(results.glucose(6) == 120);

assert(sum(results.Time.Second) == 0);

assert(results.Time.Minute(1) == 0);
assert(results.Time.Minute(2) == 5);
assert(results.Time.Minute(3) == 10);
assert(results.Time.Minute(4) == 15);
assert(results.Time.Minute(5) == 20);
assert(results.Time.Minute(6) == 25);


%% Test 2: check retime (timestep = 10)
results = retimeGlucose(data,10);

assert(results.glucose(1) == 40);
assert(results.glucose(2) == 50);
assert(results.glucose(3) == 120);

assert(sum(results.Time.Second) == 0);

assert(results.Time.Minute(1) == 0);
assert(results.Time.Minute(2) == 10);
assert(results.Time.Minute(3) == 20);

%% Test 3: check retime (timestep = 12)
results = retimeGlucose(data,12);

assert(results.glucose(1) == 45);
assert(isnan(results.glucose(2)));
assert(results.glucose(3) == 120);

assert(sum(results.Time.Second) == 0);

assert(results.Time.Minute(1) == 0);
assert(results.Time.Minute(2) == 12);
assert(results.Time.Minute(3) == 24);
