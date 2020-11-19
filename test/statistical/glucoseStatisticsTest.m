% Test units of the glucoseStatistics function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','statistical'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(60);
data = timetable(randn(length(time),1)*30+140,'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1:3) = nan;

%% Test 1: check results fields
results = glucoseStatistics(data);

assert(isfield(results,'mean'));
assert(isfield(results,'std'));
assert(isfield(results,'cv'));
assert(isfield(results,'median'));
assert(isfield(results,'range'));
assert(isfield(results,'iqr'));
assert(isfield(results,'jIndex'));

%% Test 2: check NaN presence
results = glucoseStatistics(data);

assert(~isnan(results.mean));
assert(~isnan(results.std));
assert(~isnan(results.cv));
assert(~isnan(results.median));
assert(~isnan(results.range));
assert(~isnan(results.iqr));
assert(~isnan(results.jIndex));

%% Test 3: check statistics calculation
results = glucoseStatistics(data);

nonNanGlucose = data.glucose(~isnan(data.glucose));

assert(results.mean == mean(nonNanGlucose));
assert(results.std == std(nonNanGlucose));
assert(results.cv == 100*std(nonNanGlucose)/mean(nonNanGlucose));
assert(results.median == median(nonNanGlucose));
assert(results.range == (max(nonNanGlucose)-min(nonNanGlucose)));
assert(results.iqr == iqr(nonNanGlucose));
assert(results.jIndex == (1e-3 * (mean(nonNanGlucose) + std(nonNanGlucose)) ^ 2));
