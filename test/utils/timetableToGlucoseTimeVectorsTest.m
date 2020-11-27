% Test units of the timetableToGlucoseTimeVectors function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','utils'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(20); % length = 5;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2) = 50;
data.glucose(3:4) = nan;
data.glucose(5) = 120;

%% Test 1: check results (nargin = 2, timestep = 5)
[resultsG, resultsT] = timetableToGlucoseTimeVectors(data);

assert(resultsG(1) == 40);
assert(resultsG(2) == 50);
assert(isnan(resultsG(3)));
assert(isnan(resultsG(4)));
assert(resultsG(5) == 120);

assert(resultsT(1) == datetime(2000,1,1,0,0,0));
assert(resultsT(2) == datetime(2000,1,1,0,5,0));
assert(resultsT(3) == datetime(2000,1,1,0,10,0));
assert(resultsT(4) == datetime(2000,1,1,0,15,0));
assert(resultsT(5) == datetime(2000,1,1,0,20,0));

assert(length(resultsG) == 5);
assert(length(resultsT) == 5);