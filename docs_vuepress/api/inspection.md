# Inspection

## findNanIslands
```MATLAB
function [shortNan, longNan, nanStart, nanEnd] = findNanIslands(data,TH)
```
Function that locates nan sequences in vector `data`, and classifies them based on their length (longer or not than the specified threshold `TH`).

### Inputs
   - **data: vector of double (required)** <br>
   A vector of double of equally spaced (in time) values;
   - **TH: integer (required)**
   A integer defining the threshold, expressed in number of samples, to distinguish between long and short nan sequences.
### Outputs
   - **shortNan: vector of integer** <br> 
   Vector of integer that contains the indices of "short nan" sequences (i.e., sequences shorter than `TH` consecutive nan samples);
   - **longNan: vector of integer** <br> 
   Vector of integer that contains the indices of "long nan" sequences (i.e., sequences having `TH` consecutive nan samples or more);
   - **nanStart: vector of integer** <br>
   Vector of integer containing the start indices of the nan sequences;
   - **nanEnd: vector of integer** <br>
   Vector of integer containing the last indices of the nan sequences.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `TH` must be an integer.
### Reference
   - None

## findHypoglycemicEvents
```MATLAB
function hypoglycemicEvents = findHypoglycemicEvents(data)
```
Function that finds the hypoglycemic events in a 
given glucose trace. The definition of hypoglycemic event can be found in Danne et al.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **hypoglycemicEvents: structure** <br>
   A structure containing the information on the hypoglycemic events found by the function with fields:
      - **time: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found hypoglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found hypoglycemic event.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Danne et al., "International consensus on use of continuous glucose monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: [10.2337/dc17-1600](https://doi.org/10.2337/dc17-1600).

## findHyperglycemicEvents
```MATLAB
function hyperglycemicEvents = findHyperglycemicEvents(data)
```
Function that finds the hyperglycemic events in a 
given glucose trace. The definition of hyperglycemic event can be found in Danne et al.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **hyperglycemicEvents: structure** <br>
   A structure containing the information on the hyperglycemic events found by the function with fields:
      - **time: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found hyperglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found hyperglycemic event.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Danne et al., "International consensus on use of continuous glucose monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: [10.2337/dc17-1600](https://doi.org/10.2337/dc17-1600).


## findProlongedHypoglycemicEvents
```MATLAB
function prolongedHypoglycemicEvents = findProlongedHypoglycemicEvents(data)
```
Function that finds the prolonged hypoglycemic events in a given glucose trace. The definition of prolonged hypoglycemic event can be found in Danne et al.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **prolongedHypoglycemicEvents: structure** <br>
   A structure containing the information on the prolonged hypoglycemic events found by the function with fields:
      - **time: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found prolonged hypoglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found prolonged hypoglycemic event.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Danne et al., "International consensus on use of continuous glucose monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: [10.2337/dc17-1600](https://doi.org/10.2337/dc17-1600).

   
## missingGlucosePercentage
```MATLAB
function missingGlucosePercentage = missingGlucosePercentage(data)
```
Function that computes the percentage of missing values in the given glucose trace.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **missingGlucosePercentage: double** <br>
   Percentage of missing glucose values.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - None

## numberDaysOfObservation
```MATLAB
function numberDaysOfObservation = numberDaysOfObservation(data)
```
Function that computes the number of days of observation of the given glucose trace.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **numberDaysOfObservation: double** <br>
   Number of days of observation.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference 
   - None
   