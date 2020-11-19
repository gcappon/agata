% Test units of the timePercentages function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','time'));

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(60);
data = timetable(randn(length(time),1)*30+140,'VariableNames', {'glucose'}, 'RowTimes', time);


%% Test 1: check results fields
results = timePercentages(data);

assert(isfield(results,'tHypo'));
assert(isfield(results,'tHyper'));
assert(isfield(results,'tTarget'));
assert(isfield(results,'tTightTarget'));
assert(isfield(results,'tSevereHypo'));
assert(isfield(results,'tSevereHyper'));

%% Test 2: check NaN presence
results = timePercentages(data);

assert(~isnan(results.tHypo));
assert(~isnan(results.tHyper));
assert(~isnan(results.tTarget));
assert(~isnan(results.tSevereHypo));
assert(~isnan(results.tSevereHyper));
assert(~isnan(results.tTightTarget));

%% Test 3: check percentages calculation
results = timePercentages(data);

N = height(data);
assert(results.tHypo == 100*sum(data.glucose < 70)/N);
assert(results.tHyper == 100*sum(data.glucose > 180)/N);
assert(results.tTarget == 100*sum(data.glucose >= 70 & data.glucose <= 180)/N);
assert(results.tSevereHypo == 100*sum(data.glucose < 50)/N);
assert(results.tSevereHyper == 100*sum(data.glucose > 250)/N);
assert(results.tTightTarget == 100*sum(data.glucose >= 90 & data.glucose <= 140)/N);