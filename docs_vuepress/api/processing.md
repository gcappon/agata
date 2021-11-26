# Processing

## retimeGlucose
```MATLAB
function dataRetimed = retimeGlucose(data, timestep)
```
Function that retimes the given `data` timetable to a  
new timetable with homogeneous `timestep`. It puts nans where glucose datapoints are missing and it uses mean to solve conflicts (i.e., when two glucose datapoints have the same retimed timestamp.

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **timestep: integer (required)** <br>
   An integer defining the timestep to use in the new timetable. 
### Output
   - **dataRetimed: timetable** <br>
   The retimed timetable with columns `Time` and `glucose`. 
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `timestep` must be an integer.
### Reference
   - None

## imputeGlucose
```MATLAB
function dataImputed = imputeGlucose(data, timestep)
```
Function that imputes missing glucose data using linear interpolation. The function imputes only missing data gaps of maximum `maxGap` minutes. Gaps longer than `maxGap` minutes are ignored.

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **maxGap: integer (required)** <br>
   An integer defining the maximum interpol-able missing data gaps (min).  
### Output
   - **dataImputed: timetable** <br>
   The imputed timetable with columns `Time` and `glucose`. 
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `maxGap` must be an integer.
### Reference
   - None

## detrendGlucose
```MATLAB
function dataDetrended = detrendGlucose(data)
```
Function that detrends glucose data. To do that, the function computes the slope of the immaginary line that "links" the first and last glucose datapoints in the timeseries, then it "flatten" the entire timeseries according to that slope.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **detrendGlucose: timetable** <br>
   The detrended timetable with columns `Time` and `glucose`. 
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `maxGap` must be an integer.
### Reference
   - None