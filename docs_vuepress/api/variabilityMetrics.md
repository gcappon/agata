# Variability metrics

## meanGlucose
```MATLAB
function meanGlucose = meanGlucose(data)
```
Function that computes the mean glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **meanGlucose: double** <br>
   Mean glucose concentration (mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on mean: https://en.wikipedia.org/wiki/Mean (Accessed: 2020-12-10).

## stdGlucose
```MATLAB
function stdGlucose = stdGlucose(data)
```
Function that computes the standard deviation of the  glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **stdGlucose: double** <br>
   Standard deviation of the glucose concentration (mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on standard deviation: https://en.wikipedia.org/wiki/Standard_deviation (Accessed: 2020-12-10).

## cvGlucose
```MATLAB
function cvGlucose = cvGlucose(data)
```
Function that computes the coefficient of variation of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **cvGlucose: double** <br>
   Coefficient of variation of the glucose concentration (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on coefficient of variation: https://en.wikipedia.org/wiki/Coefficient_of_variation (Accessed: 2020-12-10).

## medianGlucose
```MATLAB
function medianGlucose = medianGlucose(data)
```
Function that computes the median glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **medianGlucose: double** <br>
   Median glucose concentration (mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on median: https://en.wikipedia.org/wiki/Median (Accessed: 2020-12-10).

## rangeGlucose
```MATLAB
function rangeGlucose = rangeGlucose(data)
```
Function that computes the range spanned by the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **rangeGlucose: double** <br>
   Range spanned by the glucose concentration (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on range: https://en.wikipedia.org/wiki/Range_(statistics) (Accessed: 2020-12-10).

## iqrGlucose
```MATLAB
function iqrGlucose = iqrGlucose(data)
```
Function that computes the interquartile range of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **iqrGlucose: double** <br>
   Interquartile range of the glucose concentration (mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on IQR: https://en.wikipedia.org/wiki/Interquartile_range (Accessed: 2020-12-10).

## jIndex
```MATLAB
function jIndex = jIndex(data)
```
Function that computes the J-Index of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **jIndex: double** <br>
   J-Index of the glucose concentration (mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wójcicki, "J-index. A new proposition of the assessment of current glucose control in diabetic patients", Hormone and Metabolic Reseach, 1995, vol. 27, pp. 41-42. DOI: 10.1055/s-2007-979906.

## aucGlucose
```MATLAB
function aucGlucose = aucGlucose(data)
```
Function that computes the area under the curve (AUC) of glucose concentration (ignores nan values), i.e., the area between the glucose trace and zero. It assumes that the glucose value between two samples is constant.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **aucGlucose: double** <br>
   The area under the curve of glucose concentration (mg/dl*min).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on AUC: https://en.wikipedia.org/wiki/Integral (Accessed: 2020-12-10).

## aucGlucoseOverBasal
```MATLAB
function aucGlucoseOverBasal = aucGlucoseOverBasal(data,basal)
```
Function that computes the area under the curve (AUC) of glucose concentration over a basal value (ignores nan values). This means that glucose values above the given `basal` value will sum up positive AUC, while glucose values below the given `basal` value will sum up
in negative AUC. It assumes that the glucose value between two samples is constant.

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **basal: double (required)** <br>
   A double defining the basal value to use (mg/dl). 
### Output
   - **aucGlucoseOverBasal: double** <br>
   The area under the curve of glucose concentration (mg/dl*min) over the basal value.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Wikipedia on AUC: https://en.wikipedia.org/wiki/Integral (Accessed: 2020-12-10).

## gmi
```MATLAB
function gmi = gmi(data)
```
Function that computes the glucose management indicator (GMI) of the given data (ignores nan values). Generates a warning if the given `data` spans less than 12 days.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **gmi: double** <br>
   Glucose management indicator of the given data (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Bergenstal et al., "Glucose Management Indicator (GMI): A new term for estimating A1C from continuous glucose monitoring", Diabetes Care, 2018, vol. 41, pp. 2275-2280. DOI: 10.2337/dc18-1581.

## sddmIndex
```MATLAB
function sddmIndex = sddmIndex(data)
```
Function that computes the standard deviation of within-day means index (SDDM) (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **sddmIndex: double** <br>
   The standard deviation of within-day means index (SDDM) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Rodbard et al., "New and improved methods to characterize glycemic variability using continuous glucose monitoring", Diabetes Technology & Therapeutics, 2009, vol. 11, pp. 551-565. DOI: 10.1089/dia.2009.0015.

## sdwIndex
```MATLAB
function sdwIndex = sdwIndex(data)
```
Function that computes the mean of within-day standard deviation index (SDW) (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **sdwIndex: double** <br>
   The mean of within-day standard deviation (SDW) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Rodbard et al., "New and improved methods to characterize glycemic variability using continuous glucose monitoring", Diabetes Technology & Therapeutics, 2009, vol. 11, pp. 551-565. DOI: 10.1089/dia.2009.0015.

## mageIndex 
```MATLAB
function mageIndex = mageIndex(data)
```
Function that computes the mean amplitude of glycemic excursion (MAGE) index (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **mageIndex: double** <br>
   The mean amplitude of glycemic excursion (MAGE) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Service et al., "Mean amplitude of glycemic excursions, a measure of diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 10.2337/diab.19.9.644.

## magePlusIndex 
```MATLAB
function magePlusIndex = magePlusIndex(data)
```
Function that computes the mean amplitude of positive glycemic excursion (MAGE+) index (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **magePlusIndex: double** <br>
   The mean amplitude of positive glycemic excursion (MAGE+) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Service et al., "Mean amplitude of glycemic excursions, a measure of diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 10.2337/diab.19.9.644.

## mageMinusIndex 
```MATLAB
function mageMinusIndex = mageMinusIndex(data)
```
Function that computes the mean amplitude of negative glycemic excursion (MAGE-) index (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **mageMinusIndex: double** <br>
   The mean amplitude of negative glycemic excursion (MAGE-) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Service et al., "Mean amplitude of glycemic excursions, a measure of diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 10.2337/diab.19.9.644.

## efIndex 
```MATLAB
function efIndex = efIndex(data)
```
Function that computes the excursion frequency (EF) index, i.e., the number of excursion > 75 (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **efIndex: double** <br>
   The excursion frequency (EF) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Service et al., "Mean amplitude of glycemic excursions, a measure of diabetic instability", Diabetes, 1970, vol. 19, pp. 644-655. DOI: 10.2337/diab.19.9.644.

## CVGA
```MATLAB
function [profileAssessment,profileCoordinates, bestControlIndex, bestControlledCoordinates]=CVGA(glucoseProfiles)
```
Function that performs the control variablity grid analysis (CVGA).

### Input
   - **glucoseProfiles: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl). 
### Outputs
   - **profileAssessment: vector of double** <br>
   A vector of double containing, for each timetable in `glucoseProfiles`, the euclidian distance of each point in the CVGA space from the CVGA origin;
   - **profileCoordinates: bidimensional vector of double** <br>
   A bidimensional vector containing in the first column the CVGA coordinate in the x-axis and in the second column the CVGA coordinate in the y-axis of each glucose profile;
   - **bestControlIndex: integer** <br>
   An integer containing the index of the best glucose profile (i.e., the glucose profile with minimum `profileAssessment` value);
   - **bestControlledCoordinates: bidimensional vector of double** <br>
   A bidimensional vector containing in the first column the CVGA coordinate in the x-axis and in the second column the CVGA coordinate in the y-axis of the best glucose profile (i.e., the glucose profile with minimum `profileAssessment` value).
### Preconditions
   - `glucoseProfiles` must be a cell array containing timetables;
   - Each timetable in `glucoseProfiles` must have a column names `Time` and a column named `glucose`.

### Reference
  - Magni et al., "Evaluating the efficacy of closed-loop glucose regulation via control-variability grid analysis", Journal of Diabetes Science and Technology, 2008, vol. 2, pp. 630-635. DOI: 10.1177/193229680800200414.

## conga
```MATLAB
function conga = conga(data)
```
Function that computes the Continuous Overall Net Glycemic Action (CONGA) index.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **conga: double** <br>
   Continuous Overall Net Glycemic Action (CONGA) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - McDonnell et al., "A novel approach to continuous glucose analysis utilizing glycemic variation. Diabetes Technol Ther, 2005, vol. 7, pp. 253–263. DOI: 10.1089/dia.2005.7.253.

## modd
```MATLAB
function modd = modd(data)
```
Function that computes the mean of daily difference (MODD) index.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **modd: double** <br>
   Mean of daily difference (MODD) index.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Molnar et al., "Day-to-day variation of continuously monitored glycaemia: a further measure of diabetic instability", Diabetologia, 1972, vol. 8, pp. 342–348. DOI: 10.1007/BF01218495.

## poincareGlucose
```MATLAB
function poincareGlucose = poincareGlucose(data)
```
Function that fits an ellipse corresponding to the Poincare' plot of the ```(x,y) = (glucose(t-1),glucose(t))``` graph. To do so, it uses the least square method. If an ellipse was not detected (but a parabola or hyperbola), then an empty structure is returned.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **poincareGlucose: structure** <br>
   A structure with fields containing the parameter of the fitted Poincare' ellipse, i.e.:
      - `a`: sub axis (radius) of the X axis of the non-tilt ellipse;
      - `b`: sub axis (radius) of the Y axis of the non-tilt ellipse;
      - `phi`: sub axis (radius) of the X axis of the non-tilt ellipse;
      - `X0`: center at the X axis of the non-tilt ellipse;
      - `Y0`: center at the Y axis of the non-tilt ellipse;
      - `X0_in`: center at the X axis of the tilted ellipse;
      - `Y0_in`: center at the Y axis of the tilted ellipse;
      - `long_axis`: size of the long axis of the ellipse;
      - `short_axis`: size of the short axis of the ellipse;
      - `status`: status of detection of an ellipse;     
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.
   - Based on fit_ellipse function by Ohad Gal. https://it.mathworks.com/matlabcentral/fileexchange/3215-fit_ellipse

## glucoseROC
```MATLAB
function glucoseROC = glucoseROC(data)
```
Function that computes the glucose rate-of-change (ROC) trace. As defined in the given reference, ROC at time t is defined as the difference between the glucose at time t and t-15 minutes divided by 15 (ignores nan values). By definition, the first two samples are always nan.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **glucoseROC: timetable** <br>
   A timetable with column `Time` and `glucoseROC` containing the glucose ROC (in mg/dl/min).  
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

## stdGlucoseROC
```MATLAB
function stdGlucoseROC = stdGlucoseROC(data)
```
Function that computes the standard deviation of the glucose ROC (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **stdGlucoseROC: double** <br>
   Standard deviation of the glucose ROC. 
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

## cogi
```MATLAB
function cogi = cogi(data)
```
Function that computes the Continuous Glucose Monitoring Index (COGI) (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **cogi: double** <br>
   the COGI index. 
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Leelaranthna et al., "Evaluating glucose control with a novel composite Continuous Glucose Monitoring Index", Journal of Diabetes Science and Technology, 2019, vol. 14, pp. 277-283. DOI: 10.1177/1932296819838525.