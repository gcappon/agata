% Test units of the poincareGlucose function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','variabilityMetrics'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(70); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 253.8;
data.glucose(2) = 250.2;
data.glucose(3) = 246.6;
data.glucose(4) = 244.8;
data.glucose(5) = 244.8;
data.glucose(6) = 243;
data.glucose(7) = 239.4;
data.glucose(8) = 230.4;
data.glucose(9) = 232.2;
data.glucose(10) = 219.6;
data.glucose(11) = 208.8;
data.glucose(12) = 226.8;
data.glucose(13) = 226.8;
data.glucose(14) = nan;
data.glucose(15) = nan;

%% Test 1: check results calculation
results = poincareGlucose(data);
assert(round(results.a*100)/100 == 32.62);
assert(round(results.b*100)/100 == 10.57);
assert(round(results.phi*100)/100 == -0.65);
assert(round(results.X0*100)/100 == 317.00);
assert(round(results.Y0*100)/100 == 43.21);
assert(round(results.X0_in*100)/100 == 225.74);
assert(round(results.Y0_in*100)/100 == 226.71);
assert(round(results.long_axis*100)/100 == 65.23);
assert(round(results.short_axis*100)/100 == 21.15);
assert(isempty(results.status));