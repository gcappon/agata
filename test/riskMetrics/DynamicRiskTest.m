% Test units of the DynamicRisk function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Nunzio Camerlingo
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(60); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 260;
data.glucose(11) = nan;
data.glucose(12) = 260;
data.glucose(13) = 265;

%% Test 1: check NaN presence only if NaN were present in the original trace
results = DynamicRisk(data);
assert( not(xor(isempty(find(isnan(data.glucose),1)), isempty(find(isnan(results),1)))));

%% Test 2: check the mean result
results = nanmean(DynamicRisk(data));
assert(round(results*100)/100 == 8.28);
