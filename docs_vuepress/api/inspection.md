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
function hypoglycemicEvents = findHypoglycemicEvents(data, varargin)
```
Function that finds the hypoglycemic events in a given glucose trace. The definition of hypoglycemic event can be found in Battellino et al. (event begins: at least consecutive 15 minutes < threshold, event ends: at least 15 consecutive minutes > threshold).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **th: integer (optional)** <br>
   An integer with the selected hypoglycemia threshold (in mg/dl) the default value is 70 mg/dl.
### Output
   - **hypoglycemicEvents: structure** <br>
   A structure containing the information on the hypoglycemic events found by the function with fields:
      - **timeStart: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found hypoglycemic event;
      - **timeEnd: vector of datetime** <br> 
      A vector of datetime containing the ending timestamps of each found hypoglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found hypoglycemic event;
      - **meanDuration: double** <br> 
      Metric, the average duration of the events;
      - **duration: double** <br> 
      Metric, the number of events per week.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## findHypoglycemicEventsByLevel
```MATLAB
function hypoglycemicEvents = findHypoglycemicEventsByLevel(data)
```
Function that finds the hypoglycemic events in a given glucose trace classifying them by level, i.e., hypo, level 1 hypo or level 2 hypo. The definition of hypoglycemic event can be found in Battellino et al.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **hypoglycemicEvents: structure** <br>
   A structure containing the information on the hypoglycemic events found by the function with fields:
      - **hypo: structure** <br>
      A structure containing the information on the hypo events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found hypoglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found hypoglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found hypoglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
      - **l1: structure** <br>
      A structure containing the information on the L1 hypo events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found L1 hypoglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found L1 hypoglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found L1 hypoglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
      - **l2: structure** <br>
      A structure containing the information on the L2 hypo events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found L2 hypoglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found L2 hypoglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found L2 hypoglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## findHyperglycemicEvents
```MATLAB
function hyperglycemicEvents = findHyperglycemicEvents(data, varargin)
```
Function that finds the hyperglycemic events in a given glucose trace. The definition of hyperglycemic event can be found in Battellino et al. (event begins: at least consecutive 15 minutes > threshold, event ends: at least 15 consecutive minutes < threshold).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **th: integer (optional)** <br>
   An integer with the selected hyperglycemia threshold (in mg/dl) the default value is 70 mg/dl.
### Output
   - **hyperglycemicEvents: structure** <br>
   A structure containing the information on the hyperglycemic events found by the function with fields:
      - **timeStart: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found hyperglycemic event;
      - **timeEnd: vector of datetime** <br> 
      A vector of datetime containing the ending timestamps of each found hyperglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found hyperglycemic event;
      - **meanDuration: double** <br> 
      Metric, the average duration of the events;
      - **duration: double** <br> 
      Metric, the number of events per week.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## findHyperglycemicEventsByLevel
```MATLAB
function hyperglycemicEvents = findHyperglycemicEventsByLevel(data)
```
Function that finds the hyperglycemic events in a given glucose trace classifying them by level, i.e., hyper, level 1 hyper or level 2 hyper. The definition of hyperglycemic event can be found in Battellino et al.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output
   - **hyperglycemicEvents: structure** <br>
   A structure containing the information on the hyperglycemic events found by the function with fields:
      - **hyper: structure** <br>
      A structure containing the information on the hyper events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found hyperglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found hyperglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found hyperglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
      - **l1: structure** <br>
      A structure containing the information on the L1 hyper events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found L1 hyperglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found L1 hyperglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found L1 hyperglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
      - **l2: structure** <br>
      A structure containing the information on the L2 hypo events with fields:
         - **timeStart: vector of datetime** <br> 
         A vector of datetime containing the starting timestamps of each found L2 hyperglycemic event;
         - **timeEnd: vector of datetime** <br> 
         A vector of datetime containing the ending timestamps of each found L2 hyperglycemic event;
         - **duration: vector of integer** <br> 
         A vector of integer containing the duration (min) of each found L2 hyperglycemic event;
         - **meanDuration: double** <br> 
         Metric, the average duration of the events;
         - **duration: double** <br> 
         Metric, the number of events per week.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.

## findExtendedHypoglycemicEvents
```MATLAB
function extendedHypoglycemicEvents = findExtendedHypoglycemicEvents(data)
```
Function that finds the prolonged hypoglycemic events in a given glucose trace. The definition of extended hypoglycemic event can be found in Battellino et al. (event begins: at least consecutive 120 minutes < threshold mg/dl, event ends: at least 15 consecutive minutes > threshold mg/dl)

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **th: integer (optional)** <br>
   An integer with the selected extended hypoglycemia threshold (in mg/dl) the default value is 70 mg/dl.
### Output
   - **extendedHypoglycemicEvents: structure** <br>
   A structure containing the information on the extended hypoglycemic events found by the function with fields:
      - **timeStart: vector of datetime** <br> 
      A vector of datetime containing the starting timestamps of each found extended hypoglycemic event;
      - **timeEnd: vector of datetime** <br> 
      A vector of datetime containing the ending timestamps of each found extended hypoglycemic event;
      - **duration: vector of integer** <br> 
      A vector of integer containing the duration (min) of each found extended hypoglycemic event;
      - **meanDuration: double** <br> 
      Metric, the average duration of the events;
      - **duration: double** <br> 
      Metric, the number of events per week.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Battelino et al., "Continuous glucose monitoring and merics for clinical trials: An international consensus statement", The Lancet Diabetes & Endocrinology, 2022, pp. 1-16. DOI: https://doi.org/10.1016/S2213-8587(22)00319-9.
   
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
   