# List of functionalities of AGATA

This is a list of functionalities of AGATA ordered by topic.

## Analysis

List of functions that can be used to get an overall report/analysis of glucose profile/s:
   - `analyzeGlucoseProfile`: function that computes the glycemic outcomes of a glucose profile;
   - `analyzeOneArm`: function that computes the glycemic outcomes of one arm;
   - `compareTwoArms`: function that compares the glycemic outcomes of two arms.

## Time 

List of functions that can be used to compute time related glucose metrics:
   - `timeInHypoglycemia`: function that computes the percentage of time spent in hypoglycemia;
   - `timeInHyperglycemia`: function that computes the percentage of time spent in hyperglycemia;
   - `timeInTarget`: function that computes the percentage of time spent in the target range;
   - `timeInSevereHypoglycemia`: function that computes the percentage of time spent in severe hypoglycemia;
   - `timeInSevereHyperglycemia`: function that computes the percentage of time spent in severe hyperglycemia;
   - `timeInTightTarget`: function that computes the percentage of time spent in the tight target range;
   - `timeInGivenRange`: function that computes the percentage of time spent in the given range.

## Variability 

List of functions that can be used to compute variability related glucose metrics:
   - `meanGlucose`: function that computes the mean glucose concentration;
   - `stdGlucose`: function that computes the standard deviation of the  glucose concentration;
   - `cvGlucose`: function that computes the coefficient of variation of the glucose concentration;
   - `medianGlucose`: function that computes the median glucose concentration;
   - `rangeGlucose`: function that computes the range spanned by the glucose concentration;
   - `iqrGlucose`: function that computes the interquartile range of the glucose concentration;
   - `jIndex`: function that computes the J-Index of the glucose concentration;
   - `aucGlucose`: function that computes the area under the curve (AUC) of glucose concentration, i.e., the area between the glucose trace and zero. It assumes that the glucose value between two samples is constant;
   - `aucGlucoseOverBasal`: function that computes the area under the curve (AUC) of glucose concentration over a basal value. This means that glucose values above a given basal value will sum up positive AUC, while glucose values below the given basal value will sum up in negative AUC. It assumes that the glucose value between two samples is constant;
   - `gmi`: function that computes the glucose management indicator (GMI) of the given data;
   - `sddmIndex`: function that computes the standard deviation of within-day means index (SDDM);
   - `sdwIndex`: function that computes the mean of within-day standard deviation index (SDW);
   - `mageIndex`: function that computes the mean amplitude of glycemic excursion (MAGE) index;
   - `magePlusIndex`: function that computes the mean amplitude of positive glycemic excursion (MAGE+) index;
   - `mageMinusIndex`: function that computes the mean amplitude of negative glycemic excursion (MAGE-) index;
   - `efIndex`: function that computes the excursion frequency (EF) index, i.e., the number of excursion > 75;
   - `CVGA`: function that performs the control variablity grid analysis (CVGA).

## Error metrics

List of functions that can be used to compute some error metric between two glucose profiles:
   - `rmse`: function that computes the root mean squared error (RMSE) between two glucose traces;
   - `cod`: function that computes the coefficient of determination (COD) between two glucose traces;
   - `mad`: function that computes the mean absolute difference (MAD) between two glucose traces;
   - `mard`: function that computes the mean absolute relative difference (MARD) between two glucose traces;
   - `clarke`: function that performs Clarke Error Grid Analysis (CEGA);
   - `timeDelay`: function that computes the time delay between two glucose traces. The time delay is computed as the time shift necessary to maximize the correlation between the two traces;
   - `gRMSE`: function that computes the glucose root mean squared error (gRMSE) between two glucose traces.

## Risk metrics

List of functions that can be used to compute risk glucose metrics:
   - `lbgi`: function that computes the low blood glucose index (LBGI) of the glucose concentration;
   - `hbgi`: function that computes the high blood glucose index (HBGI) of the glucose concentration;
   - `bgri`: function that computes the blood glucose risk index (BRGI) of the glucose concentration;
   - `dynamicRisk`: function that computes the dynamic risk based on current
    glucose concentration and its rate-of-change;
   - `adrr`: function that computes the average daily risk range (ADRR) of the glucose concentration.
   - `gri` : function that computes the Glycemic Risk Index (GRI) proposed Klonoff et al. 

## Glycemic transformation

List of functions that can be used to compute glucose metrics that uses transformations of the glucose scale:
   - `hypoIndex`: function that computes the hypoglycemic index;
   - `hyperIndex`: function that computes the hyperglycemic index;
   - `igc`: function that computes the index of glycemic control (IGC);
   - `mrIndex`: function that computes the mr value;
   - `gradeScore`: function that computes the glycemic risk assessment diabetes equation score (GRADE);
   - `gradeEuScore`: function that computes the glycemic risk assessment diabetes equation score in the euglycemic range (GRADEeu);
   - `gradeHypoScore`: function that computes the glycemic risk assessment diabetes equation score in the hypoglycemic range (GRADEhypo);
   - `gradeHyperScore`: function that computes the glycemic risk assessment diabetes equation score in the hyperglycemic range (GRADEhyper).

## Processing

List of functions that can be used to process glucose profiles:
   - `retimeGlucose`: function that retimes the given data timetable to a  
    new timetable with homogeneous timestep;
   - `imputeGlucose`: function that imputes missing glucose data using linear interpolation;
   - `detrendGlucose`: function that detrends glucose data. To do that, the function computes the slope of the immaginary line that "links" the first and last glucose datapoints in the timeseries, then it "flatten" the entire timeseries according to that slope.

## Inspection

List of functions that can be used to find particular events in a given glucose profile:
   - `findNanIslands`: function that locates nan sequences in vector `data`, and classifies them based on their length;
   - `findHypoglycemicEvents`: function that finds the hypoglycemic events in a 
   given glucose trace;
   - `findHyperglycemicEvents`: function that finds the hyperglycemic events in a 
   given glucose trace;
   - `findProlongedHypoglycemicEvents`: function that finds the prolonged hypoglycemic events in a given glucose trace;
   - `missingGlucosePercentage`: function that computes the percentage of missing values in the given glucose trace.

## Utilities 

List of function utilities that can be used to facilitate the use of AGATA:
   - `glucoseVectorToTimetable`: function that converts a vector containing glucose samples sampled on an homogeneous timegrid with fixed timestep in a timetable;
   - `timetableToGlucoseVector`: function that converts a timetable with column `Time` and `glucose` containing the glucose data, in a double vector containing the glucose data in the `glucose` column;
   - `glucoseTimeVectorsToTimetable`: function that converts the two given vectors containing the glucose samples and the corresponding timestamps, respectively, in a timetable;
   - `timetableToGlucoseTimeVectors`: function that converts a timetable with column `Time` and `glucose` containing the timestamps and the respective glucose data, in two vectors: one containing the timestamp data in the `Time` column and the other containing the glucose data in the `glucose` column.

## Visualization

List of functions that can be used to visualize glucose data:
   - `plotGlucose`: function that visualizes the given glucose profile;
   - `plotGlucoseAsOneDay`: function that generates a plot of data in a single plot where each daily glucose profile is overlapped to each other;
   - `plotGlucoseAsOneDayComparison`: function that generates a plot of two glucose profiles in a single plot where each daily glucose profile is overlapped to each other;
   - `generateAGP`: function that generates the ambulatory glucose profile (AGP) reports of the given data. A report is generated every 14 days of recordings starting backwards from last 14 days;
   - `plotCVGA`: function that plots the control variablity grid analysis (CVGA).
   - `plotGRI`: function that plots the GRI grid.

