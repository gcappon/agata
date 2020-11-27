% Test units of the glucoseVectorToTimetable function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','utils'));

data = [40 50 nan nan 120];

%% Test 1: check results (nargin = 2, timestep = 5)
results = glucoseVectorToTimetable(data,5);

assert(results.glucose(1) == 40);
assert(results.glucose(2) == 50);
assert(isnan(results.glucose(3)));
assert(isnan(results.glucose(4)));
assert(results.glucose(5) == 120);

assert(results.Time(1) == datetime(2000,1,1,0,0,0));
assert(results.Time(2) == datetime(2000,1,1,0,5,0));
assert(results.Time(3) == datetime(2000,1,1,0,10,0));
assert(results.Time(4) == datetime(2000,1,1,0,15,0));
assert(results.Time(5) == datetime(2000,1,1,0,20,0));

%% Test 2: check results (nargin = 2, timestep = 10)
results = glucoseVectorToTimetable(data,10);

assert(results.glucose(1) == 40);
assert(results.glucose(2) == 50);
assert(isnan(results.glucose(3)));
assert(isnan(results.glucose(4)));
assert(results.glucose(5) == 120);

assert(results.Time(1) == datetime(2000,1,1,0,0,0));
assert(results.Time(2) == datetime(2000,1,1,0,10,0));
assert(results.Time(3) == datetime(2000,1,1,0,20,0));
assert(results.Time(4) == datetime(2000,1,1,0,30,0));
assert(results.Time(5) == datetime(2000,1,1,0,40,0));

%% Test 3: check results (nargin = 3, timestep = 5)
results = glucoseVectorToTimetable(data,5,datetime(2011,2,2,4,3,0));

assert(results.glucose(1) == 40);
assert(results.glucose(2) == 50);
assert(isnan(results.glucose(3)));
assert(isnan(results.glucose(4)));
assert(results.glucose(5) == 120);

assert(results.Time(1) == datetime(2011,2,2,4,3,0));
assert(results.Time(2) == datetime(2011,2,2,4,8,0));
assert(results.Time(3) == datetime(2011,2,2,4,13,0));
assert(results.Time(4) == datetime(2011,2,2,4,18,0));
assert(results.Time(5) == datetime(2011,2,2,4,23,0));

