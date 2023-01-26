% Test units of the numberDaysOfObservationTest function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2023 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','inspection'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(420);
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(:) = 120;
data.glucose(10:13) = 200;
data.glucose(30:60) = 200;
data.glucose(32:33) = nan;
data.glucose(62:63) = 200;
data.glucose(70:72) = 200;
data.glucose(76:78) = 200;
data.glucose(80:82) = 200;
data.glucose(81) = nan;

%% Test 1: check NaN presence
results = numberDaysOfObservation(data);
assert(~isnan(results));

%% Test 2: check calculation
results = numberDaysOfObservation(data);
assert(round(results(1)*100)/100 == 0.29);