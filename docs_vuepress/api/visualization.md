# Visualization

## plotGlucose
```MATLAB
function plotGlucose(data,varargin)
```
Function that visualizes the given data.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucose` is not CI tested.
:::

## plotGlucoseAsOneDay
```MATLAB
function plotGlucoseAsOneDay(data,varargin) 
```
Function that generates a plot of data in a single plot where each daily glucose profile is overlapped to each other.

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseAsOneDay` is not CI tested.
:::


## plotGlucoseAsOneDayComparison
```MATLAB
function plotGlucoseAsOneDayComparison(data1,data2,varargin) 
```
Function that generates a plot of two glucose profiles in a single plot where each daily glucose profile is overlapped to each other.

### Inputs
   - **data1: timetable (required)** <br>
   A timetable with column `Time` and `glucose` containing the first set of glucose data to analyze (in mg/dl);
   - **data2: timetable (required)** <br>
   A timetable with column `Time` and `glucose` containing the second set of glucose data to analyze (in mg/dl);
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.
### Preconditions
   - `data1` and `data2` must be a timetable having an homogeneous time grid;
   - `data1` and `data2` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseAsOneDayComparison` is not CI tested.
:::

## generateAGP
```MATLAB
function generateAGP(data,varargin) 
```
Function that generates the ambulatory glucose profile (AGP) reports of the given data. A report is generated every 14 days of recordings starting backwards from last 14 days.

### Inputs
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);

   - **Name: vector of characters (optional, default: '')** <br>
   A vector of characters defining the name of the patient; 
   - **MRN: vector of characters (optional, default: '')** <br> 
   A vector of characters defining the medical record number of the patient; 
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `Name` must be a vector of characters;
   - `MRN` must be a vector of characters;
   - `PrintFigure` can be 0 or 1.
### Reference
   - Danne et al., "International consensus on use of continuous glucose monitoring", Diabetes Care, 2017, vol. 40, pp. 1631-1640. DOI: [10.2337/dc17-1600](https://doi.org/10.2337/dc17-1600).

::: warning
Currently `generateAGP` is not CI tested and requires a screen "big enough".
:::

## plotCVGA
```MATLAB
function plotCVGA(glucoseProfiles, varargin)
```
Function that plots the control variablity grid analysis (CVGA).

### Input
   - **glucoseProfiles: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl). 
   - **PlotZoneNames (optional, default: 1, {0, 1})** <br>
   A numerical flag defining whether to plot the zone names in the CVGA plot or not.
   - **HighlightBestControl (optional, default: 1, {0, 1})** <br> 
   A numerical flag defining whether to highlight the best controlled profile in the CVGA plot or not.
   - **FontSize: integer (optional, default: 16)** <br> 
   A scalar defining the font size of the CVGA plot.
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to generated CVGA.

### Preconditions
   - `glucoseProfiles` must be a cell array containing timetables;
   - Each timetable in `glucoseProfiles` must have a column names `Time` and a column named `glucose`;
   - `PlotZoneNames` can be 0 or 1;
   - `HighlightBestControl` can be 0 or 1;
   - `PrintFigure` can be 0 or 1.

### Reference
  - Magni et al., "Evaluating the efficacy of closed-loop glucose regulation via control-variability grid analysis", Journal of Diabetes Science and Technology, 2008, vol. 2, pp. 630-635. DOI: 10.1177/193229680800200414.

::: warning
Currently `plotCVGA` is not CI tested.
:::

## plotGRI
```MATLAB
function plotGRI(glucoseProfiles, varargin)
```
Function that plots the control variablity grid analysis (CVGA).

### Input
   - **glucoseProfiles: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl). 
   - **HighlightBest: integer (optional, default: 1, {0, 1})** <br>
   A numerical flag defining whether to highlight the best GRI dot in the plot or not.
   - **FontSize: integer (optional, default: 16)** <br> 
   A scalar defining the font size of the GRI plot.
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.

### Preconditions
   - `glucoseProfiles` must be a cell array containing timetables;
   - Each timetable in `glucoseProfiles` must have a column names `Time` and a column named `glucose`;
   - `HighlightBest` can be 0 or 1.
   - `PrintFigure` can be 0 or 1.

### Reference
  - Klonoff et al., "A Glycemia Risk Index (GRI) of hypoglycemia and hyperglycemia for continuous glucose monitoring validated by clinician ratings", Journal of Diabetes Science and Technology, 2022, pp. 1-17. DOI: 10.1177/19322968221085273.

::: warning
Currently `plotGRI` is not CI tested.
:::