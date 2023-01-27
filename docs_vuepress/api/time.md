# Time

## timeInHypoglycemia
```MATLAB
function timeInHypoglycemia = timeInHypoglycemia(data)
```
Function that computes the percentage of time spent in hypoglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInHypoglycemia: double** <br>
   Percentage of time in hypoglycemia (i.e., < 70 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## timeInL1Hypoglycemia
```MATLAB
function timeInL1Hypoglycemia = timeInL1Hypoglycemia(data)
```
Function that computes the percentage of time spent in level 1 hypoglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInL1Hypoglycemia: double** <br>
   Percentage of time in level 1 hypoglycemia (i.e., 54-70 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## timeInL2Hypoglycemia
```MATLAB
function timeInL2Hypoglycemia = timeInL2Hypoglycemia(data)
```
Function that computes the percentage of time spent in level 2 hypoglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInL2Hypoglycemia: double** <br>
   Percentage of time in level 2 hypoglycemia (i.e., < 54 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## timeInHyperglycemia
```MATLAB
function timeInHyperglycemia = timeInHyperglycemia(data)
```
Function that computes the percentage of time spent in hyperglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInHyperglycemia: double** <br>
   Percentage of time in hyperglycemia (i.e., > 180 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## timeInL1Hyperglycemia
```MATLAB
function timeInL1Hyperglycemia = timeInL1Hyperglycemia(data)
```
Function that computes the percentage of time spent in level 1 hyperglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInL1Hyperglycemia: double** <br>
   Percentage of time in level 1 hyperglycemia (i.e., 180-250 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## timeInL2Hyperglycemia
```MATLAB
function timeInL2Hyperglycemia = timeInL2Hyperglycemia(data)
```
Function that computes the percentage of time spent in level 2 hyperglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInL2Hyperglycemia: double** <br>
   Percentage of time in level 2 hyperglycemia (i.e., > 250 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

   
## timeInTarget
```MATLAB
function timeInTarget = timeInTarget(data)
```
Function that computes the percentage of time spent in the target range (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInTarget: double** <br>
   Percentage of time in the target range (i.e., >= 70 and <= 180 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
   
## timeInTightTarget
```MATLAB
function timeInTightTarget = timeInTightTarget(data)
```
Function that computes the percentage of time spent in the tight target range (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInTightTarget: double** <br>
   Percentage of time in the tight target range (i.e., >= 70 and <= 140 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

   
## timeInGivenRange
```MATLAB
function timeInGivenRange = timeInGivenRange(data, minValue, maxValue)
```
Function that computes the percentage of time spent in the given range (ignoring nan values).

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **minValue: double (required)** <br>
   A double containing the lower range value (mg/dl);
   - **maxValue: double (required)** <br>
   A double containing the upper range value (mg/dl).
### Output
   - **timeInTightTarget: double** <br>
   Percentage of time in the given range (i.e., >= minValue and <= maxValue mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `minValue` must be smaller or qual to `maxValue`.
### Reference 
   - None   