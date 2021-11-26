# Utilities 

## glucoseVectorToTimetable
```MATLAB
dataTimetable = glucoseVectorToTimetable(data, sampleTime, startTime)
```
Function that converts a vector containing glucose samples sampled on an homogeneous timegrid with timestep `sampleTime` in a timetable. The resulting timetable timestamps will start from `startTime`. If startTime is not specified, 2000-01-01 00:00 is used as default.

## Inputs
   - **data: vector of double (required)** <br>
   A vector of doubled containing the glucose data (in mg/dl) supposed to be sampled in a homogeneous timegrid with timestep `sampleTime`; 
   - **sampleTime: integer (required)** <br>
   An integer defining the sample time of data (in min);
   - **startTime: datetime (required)** <br>
   A dateTime defining the first timestamp of the resulting timetable. If startTime is not provided, 2000-01-01 00:00, is used as default.
### Output
   - **dataTimetable: timetable** <br>
    `data` transformed in timetable having two columns: `Time`, which contains the timestamps, and `glucose` containing the corresponding glucose data (in mg/dl). 
### Preconditions
   - `data` must be a vector of double supposed to be sampled in a homogeneous timegrid with timestep `sampleTime`; 
   - `sampleTime` must be an integer;
   - `startTime` must be a datetime.
### Reference
   - None

## timetableToGlucoseVector
```MATLAB
dataVector = timetableToGlucoseVector(data)
```
Function that converts a timetable with column `Time` and `glucose` containing the glucose data, in a double vector containing the glucose data in the `glucose` column. 

## Input
   - **data: vector of double (required)** <br>
   A timetable with column `Time` and `glucose` containing the glucose data (in mg/dl). 
### Output
   - **dataVector: vector of double** <br>
    A vector of double containing the glucose data in the `glucose` column. 
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - None

## glucoseTimeVectorsToTimetable
```MATLAB
function dataTimetable = glucoseTimeVectorsToTimetable(glucose, time)
```
Function that converts the two given vectors containing the glucose samples and the corresponding timestamps, respectively, in a timetable.

### Inputs
   - **glucose: vector of double (required)** <br> 
   A vector of double containing the glucose data (in mg/dl); 
   - **time: vector of datetime (required)** <br>
   A vector of datetime containing the timestamps of each `glucose` datapoint.
### Output
   - **dataTimetable: timetable** <br>
    `data` and `time` vectors transformed in timetable having two columns: `Time`, which contains the timestamps, and `glucose` containing the corresponding glucose data (in mg/dl).

### Preconditions
   - `data` and `time` must be of the same length;
   - `glucose` must be a vector of double;
   - `time` must be a a vector of datetime.
### Reference
   - None

## timetableToGlucoseTimeVectors
```MATLAB
function [dataVector, timeVector] = timetableToGlucoseTimeVectors(data)
```
Function that converts a timetable with column `Time` and `glucose` containing the timestamps and the respective glucose data, in two vectors: one containing the timestamp data in the `Time` column and the other containing the glucose data in the `glucose` column. 

### Input
   - **data: vector of double (required)** <br>
   A timetable with column `Time` and `glucose` containing the glucose data (in mg/dl). 
### Outputs
   - **dataVector: vector of double** <br>
   A vector of double containing the glucose data
   in the `glucose` column;
   - **timeVector: vector of datetime** <br>
   A vector of datetime containing the timestamp data in the `Time` column.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - None