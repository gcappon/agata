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
   - None

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
   - None
   
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
   - None
   
## timeInSevereHypoglycemia
```MATLAB
function timeInSevereHypoglycemia = timeInSevereHypoglycemia(data)
```
Function that computes the percentage of time spent in severe hypoglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInSevereHypoglycemia: double** <br>
   Percentage of time in severe hypoglycemia (i.e., < 54 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - None
   
## timeInSevereHyperglycemia
```MATLAB
function timeInSevereHyperglycemia = timeInSevereHyperglycemia(data)
```
Function that computes the percentage of time spent in severe hyperglycemia (ignoring nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **timeInSevereHyperglycemia: double** <br>
   Percentage of time in severe hyperglycemia (i.e., > 250 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - None
   
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
   Percentage of time in the tight target range (i.e., >= 90 and <= 140 mg/dl).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - None
   
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