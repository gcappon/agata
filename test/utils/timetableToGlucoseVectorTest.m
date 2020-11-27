% Test units of the timetableToGlucoseVector function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','utils'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(25); % length = 6;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2) = 50;
data.glucose(3:4) = nan;
data.glucose(5:6) = 120;

%% Test 1: check results (nargin = 2, timestep = 5)
results = timetableToGlucoseVector(data);

assert(results(1) == 40);
assert(results(2) == 50);
assert(isnan(results(3)));
assert(isnan(results(4)));
assert(results(5) == 120);
assert(results(6) == 120);

assert(length(results) == 6);