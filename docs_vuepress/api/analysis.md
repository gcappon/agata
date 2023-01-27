# Analysis

## analyzeGlucoseProfile
```MATLAB
function results = analyzeGlucoseProfile(data)
```
Function that computes the glycemic outcomes of a glucose profile.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **results: structure** <br>
   A structure with fields containing the computed metrics and stats in the glucose profile, i.e.:
       - `variabilityMetrics`: a structure with fields containing the values of the computed variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`, `cvGlucose`, `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) of the glucose profile;
       - `riskMetrics`: a structure with fields containing the values of the computed risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`, `gri`}) of the glucose profile; 
       - `dataQualityMetrics`: a structure with fields containing the values of the computed data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) of the glucose profile;
       - `timeMetrics`: a structure with fields containing the values of the computed time related metrics (i.e., {`timeInHyperglycemia`, `timeInL1Hyperglycemia`, `timeInL2Hyperglycemia`, `timeInHypoglycemia`, `timeInL1Hypoglycemia`, `timeInL2Hypoglycemia`, `timeInTarget`, `timeInTightTarget`}) of the glucose profile;
       - `glycemicTransformationMetrics`: a structure with fields containing the values of the computed glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, `igc`, `mrIndex`}) of the glucose profile; 
       - `eventMetrics`: a structure with fields containing the values of the computed event related metrics (i.e., {`hypoglycemicEvents`, `hyperglycemicEvents`, `extendedHypoglycemicEvents`}) of the glucose profile.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - None

::: warning
Currently `analyzeGlucoseProfile` is not CI tested.
:::

## analyzeOneArm
```MATLAB
function results = analyzeOneArm(arm)
```
Function that computes the glycemic outcomes of one arm.

### Input
   - **arm: cell array of timetable (required)** <br>
   A cell array of timetables containing the glucose data of the first arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl).
### Output
   - **results: structure** <br>
   A structure with fields containing the computed metrics and stats in the arm, i.e.:
       - `variabilityMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`, `cvGlucose`, `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;   
       - `riskMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`, `gri`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;   
       - `dataQualityMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;  
       - `timeMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed time related metrics (i.e., {`timeInHyperglycemia`, `timeInL1Hyperglycemia`, `timeInL2Hyperglycemia`, `timeInHypoglycemia`, `timeInL1Hypoglycemia`, `timeInL2Hypoglycemia`, `timeInTarget`, `timeInTightTarget`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
       - `glycemicTransformationMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, `igc`, `mrIndex`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
       - `eventMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed event related metrics (i.e., {`hypoglycemicEvents`, `hyperglycemicEvents`, `extendedHypoglycemicEvents`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
### Preconditions
   - `arm` must be a cell array containing timetables;
   - Each timetable in `arm` must have a column names `Time` and a
   column named `glucose`.
   - Each timetable in `arm` must have an homogeneous time grid.
### Reference
   - None

::: warning
Currently `analyzeOneArm` is not CI tested.
:::

## compareTwoArms
```MATLAB
function [results, stats] = compareTwoArms(arm1,arm2,isPaired,alpha)
```
Function that compares the glycemic outcomes of two arms.

### Inputs
   - **arm1: cell array of timetable (required)** <br>
   A cell array of timetables containing the glucose data of the first arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
   - **arm2: cell array of timetable (required)** <br>
   A cell array of timetables containing the glucose data of the second arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
   - **isPaired: integer (required)** <br>
   A numeric flag defining whether to run paired or unpaired analysis. Commonly paired tests are performed when data of the same patients are present in both arms, unpaired otherwise;
   - **alpha: double (required)** <br>
   A double representing the significance level to use.
### Outputs
   - **results: structure** <br>
   A structure with field `arm1` and `arm2`, that are two structures with field containing the computed metrics in the two arms, i.e.:
       - `variabilityMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed variability metrics (i.e., {`aucGlucose`, `CVGA`, `cogi`, `cvGlucose`, `efIndex`, `gmi`, `iqrGlucose`, `jIndex`, `mageIndex`, `magePlusIndex`, `mageMinusIndex`, `meanGlucose`, `medianGlucose`, `rangeGlucose`, `sddmIndex`, `sdwIndex`, `stdGlucose`,`conga`,`modd`, `stdGlucoseROC`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;   
       - `riskMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed risk metrics (i.e., {`adrr`, `bgri`, `hbgi`, `lbgi`, `gri`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;   
       - `dataQualityMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed data quality metrics (i.e., {`missingGlucosePercentage`,`numberDaysOfObservation`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`;  
       - `timeMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed time related metrics (i.e., {`timeInHyperglycemia`, `timeInL1Hyperglycemia`, `timeInL2Hyperglycemia`, `timeInHypoglycemia`, `timeInL1Hypoglycemia`, `timeInL2Hypoglycemia`, `timeInTarget`, `timeInTightTarget`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
       - `glycemicTransformationMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed glycemic transformed metrics (i.e., {`gradeScore`, `gradeEuScore`, `gradeHyperScore`, `gradeHypoScore`, `hypoIndex`, `hyperIndex`, `igc`, `mrIndex`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
       - `eventMetrics`: a structure with fields:
           - `values`: a vector containing the values of the computed event related metrics (i.e., {`hypoglycemicEvents`, `hyperglycemicEvents`, `extendedHypoglycemicEvents`}) for each glucose profile;
           - `mean`: the mean of `values`;
           - `median`: the median of `values`;
           - `std`: the standard deviation of `values`;
           - `prc5`: the 5th percentile of `values`;
           - `prc25`: the 25th percentile of `values`;
           - `prc75`: the 75th percentile of `values`;
           - `prc95`: the 95th percentile of `values`; 
   - **stats: structure** <br>
   A structure that contains for each of the considered metrics the result of the statistical test with field `p` (p-value value) and `h` null hypothesis accepted or rejcted. Statistical tests are: 
       - *t-test* if the test `isPaired` and the samples are both gaussian distributed (checked with the Lilliefors test);
       - *unpaired t-test* if the test not `isPaired` and the samples are both gaussian distributed (checked with the Lilliefors test);
       - *Wilcoxon rank test* if the test `isPaired` and at least one of the samples is not gaussian distributed (checked with the Lilliefors test); 
       - *Mann-Whitney U-test* if the test not `isPaired` and at least one of the samples is not gaussian distributed (checked with the Lilliefors test).
### Preconditions
   - `arm1` must be a cell array containing timetables;
   - `arm2` must be a cell array containing timetables;
   - Each timetable in `arm1` and `arm2` must have a column names `Time` and a
   column named `glucose`.
   - Each timetable in `arm1` and `arm2` must have an homogeneous time grid;
   - `isPaired` can be 0 or 1.
### Reference
   - Lilliefors et al., "On the Kolmogorov-Smirnov test for normality with mean and variance unknown," Mathematics, vol. 62, 1967, pp. 399–402. DOI: 10.1080/01621459.1967.10482916.

::: warning
Currently `compareTwoArms` is not CI tested.
:::