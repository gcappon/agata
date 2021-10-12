% Test units of the glucoseROC function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2021 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','variabilityMetrics'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 260;
data.glucose(11) = nan;

%% Test 1: check if results is a timetable
results = glucoseROC(data);
assert(istimetable(results));

%% Test 2: check if the resulting timetable has an homogeneous timegrid
results = glucoseROC(data);
assert(~(var(seconds(diff(results.Time))) > 0 || isnan(var(seconds(diff(results.Time))))));

%% Test 3: check if results contains a glucoseROC column
results = glucoseROC(data);
assert(any(strcmp(fieldnames(results),'glucoseROC')));

%% Test 4: check that the first and last timestamps coincide with the one of the input
results = glucoseROC(data);
assert(results.Time(1)==data.Time(1) && data.Time(end) == results.Time(end));

%% Test 5: check that the length coincides with the one of the input
results = glucoseROC(data);
assert(height(results) == height(data));

%% Test 6: check results calculation
results = glucoseROC(data);
assert(isnan(results.glucoseROC(1)));
assert(isnan(results.glucoseROC(2)));
assert(isnan(results.glucoseROC(3)));
assert(round(results.glucoseROC(4)*100)/100 == 2.67);
assert(round(results.glucoseROC(5)*100)/100 == 4.67);
assert(round(results.glucoseROC(6)*100)/100 == 4.67);
assert(round(results.glucoseROC(7)*100)/100 == 8);
assert(round(results.glucoseROC(8)*100)/100 == 5.33);
assert(round(results.glucoseROC(9)*100)/100 == 9.33);
assert(round(results.glucoseROC(10)*100)/100 == 4);
assert(isnan(results.glucoseROC(11)));