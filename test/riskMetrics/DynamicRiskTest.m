% Test units of the dynamicRisk function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Nunzio Camerlingo
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

addpath(fullfile('..','..','src','riskMetrics'));

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
results = dynamicRisk(data);
assert( not(xor(isempty(find(isnan(data.glucose),1)), isempty(find(isnan(results),1)))));

%% Test 2: check the first value of result (independent on any parameter)
results = dynamicRisk(data);
assert(round(results(1)*100)/100 == -36.42);

%% Test 3: test the function with different AmplificationFunction parameter
results = dynamicRisk(data,'AmplificationFunction','exp');
assert(round(results(1)*100)/100 == -36.42); 
assert(round(nanmean(results)/10)*10 == 5630);
assert(round(results(end)*100)/100 == 45.87);

%% Test 4: test the function with different MaximumAmplification parameter
results = dynamicRisk(data,'MaximumAmplification',1.2);
assert(round(results(1)*100)/100 == -36.42);
assert(round(nanmean(results)*100)/100 == 3.07);
assert(round(results(end)*100)/100 == 28.44);

%% Test 5: test the function with different AmplificationRapidity parameter
results = dynamicRisk(data,'AmplificationRapidity',2.5);
assert(round(results(1)*100)/100 == -36.42);
assert(round(nanmean(results)*100)/100 == 8.23);
assert(round(results(end)*100)/100 == 37.93);

%% Test 6: test the function with different MaximumDumping parameter
results = dynamicRisk(data,'MaximumDamping',1.8);
assert(round(results(1)*100)/100 == -36.42);
assert(round(nanmean(results)*100)/100 == 12.71);
assert(round(results(end)*100)/100 == 118.7);

%% Test 7: test the function with a combination of parameters
results = dynamicRisk(data,'AmplificationFunction','tanh','MaximumAmplification',2.2,...
    'AmplificationRapidity',1.7,'MaximumDamping',1.1);
assert(round(results(1)*100)/100 == -36.42);
assert(round(nanmean(results)*100)/100 == 4.59);
assert(round(results(end)*100)/100 == 22.12);

%% Test 8: test different order of parameters
results = dynamicRisk(data,'AmplificationRapidity',1.7,'MaximumAmplification',2.2,...
    'MaximumDamping',1.1,'AmplificationFunction','tanh');
assert(round(results(1)*100)/100 == -36.42);
assert(round(nanmean(results)*100)/100 == 4.59);
assert(round(results(end)*100)/100 == 22.12);

%% Test 9: test the positions of nan in the data are a subset of the position of nan in results 
results = dynamicRisk(data);
originalNanPositions = find(isnan(data.glucose));
resultsNanPositions = find(isnan(results));
originalInResultsNaNPositions = ismember(originalNanPositions,resultsNanPositions);
assert(sum(originalInResultsNaNPositions)==length(originalInResultsNaNPositions));
