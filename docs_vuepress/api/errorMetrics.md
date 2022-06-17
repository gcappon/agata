# Error metrics

## rmse
```MATLAB
function rmse = rmse(data,dataHat)
```
Function that computes the root mean squared error (RMSE) between two glucose traces (ignores nan values).

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`.
### Output 
   - **rmse: double** <br>
   The computed root mean squared error (mg/dl).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference
   - Wikipedia on RMSE: https://en.wikipedia.org/wiki/Root-mean-square_deviation. (Accessed: 2020-12-10)

## cod
```MATLAB
function cod = cod(data,dataHat)
```
Function that computes the coefficient of determination (COD) between two glucose traces (ignores nan values).

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`.
### Output 
   - **cod: double** <br>
   The computed coefficient of determination (%).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference
   - Wright, "Correlation and causation", Journal of Agricultural Research, vol. 20, 1921, pp. 557–585.

## mard
```MATLAB
function mard = mard(data,dataHat)
```
Function that computes the mean absolute relative difference (MARD) between two glucose traces (ignores nan values).

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`.
### Output 
   - **mard: double** <br>
   The mean absolute relative difference (MARD) (%).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference 
   - Gini, "Measurement of Inequality and Incomes", The Economic Journal, vol. 31, 1921, pp. 124–126. DOI:10.2307/2223319.

## clarke
```MATLAB
function results = clarke(data,dataHat)
```
Function that performs Clarke Error Grid Analysis (CEGA) (ignores nan values).

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`.
### Output 
   - **results: structure** <br>
   A structure containing the results of the CEGA with fields:
       - `A`: the percentage of time spent in Zone A (%);
       - `B`: the percentage of time spent in Zone B (%);
       - `C`: the percentage of time spent in Zone C (%);
       - `D`: the percentage of time spent in Zone D (%);
       - `E`: the percentage of time spent in Zone E (%).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference
   -  Clarke et al., "Evaluating clinical accuracy of systems for self-monitoring of blood glucose", Diabetes Care, 1987, vol. 10, pp. 622–628. DOI: 10.2337/diacare.10.5.622.

## timeDelay
```MATLAB
function timeDelay = timeDelay(data,dataHat)
```
Function that computes the time delay between two glucose traces (ignores nan values). The time delay is computed as the time shift necessary to maximize the correlation between the two traces.

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`;
### Output 
   - **timeDelay: double** <br>
   The computed time delay (min).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference 
   - Wikipedia on time delay using correlation. https://en.wikipedia.org/wiki/Cross-correlation#Time_delay_analysis (Accessed: 2020-12-10).
   
## gRMSE
```MATLAB
function gRMSE = gRMSE(data,dataHat)
```
Function that computes the glucose root mean squared erro (gRMSE) between two glucose traces (ignores nan values).

### Inputs 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **dataHat: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the inferred glucose data (mg/dl) to comapre with `data`;
### Output 
   - **gRMSE: double** <br>
   The computed glucose root mean squared error (mg/dl).
### Preconditions
   - `data` and `dataHat` must be a timetable having an homogeneous time grid;
   - `data` and `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp;
   - `data` and `dataHat` must end with the same timestamp;
   - `data` and `dataHat` must have the same length.
### Reference
   - Del Favero et al., "A glucose-specific metric to assess predictors and identify models", IEEE Transactions on Biomedical Engineering, 2012, vol. 59, pp. 1281-1290. DOI: 10.1109/TBME.2012.2185234.