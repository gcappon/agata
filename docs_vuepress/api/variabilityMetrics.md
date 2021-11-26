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