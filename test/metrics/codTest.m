% Test units of the cod function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','metrics'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 260;
data.glucose(11) = nan;

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
dataHat = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
dataHat.glucose(1) = 30;
dataHat.glucose(2:3) = 70;
dataHat.glucose(4) = 70;
dataHat.glucose(5:6) = 130;
dataHat.glucose(7:8) = nan;
dataHat.glucose(9:10) = 260;
dataHat.glucose(11) = 260;


res = 100 * ( 1 - norm([10 -20 -20 10 -10 -10 0 0],2)^2 ./ ...
        norm([40 50 50 80 120 120 260 260] - mean([40 50 50 80 120 120 260 260]), 2)^2 );

%% Test 1: check NaN presence
results = cod(data,dataHat);
assert(~isnan(results));

%% Test 2: check results calculation
results = cod(data,dataHat);
assert(results == res);