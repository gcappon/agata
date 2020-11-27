% Test units of the glucoseTimeVectorsToTimetable function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','utils'));

glucose = [40 50 nan nan 120];
time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(20);

%% Test 1: check results
results = glucoseTimeVectorsToTimetable(glucose,time);

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

assert(height(results) == 5);