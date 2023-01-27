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
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
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
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
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
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data1` and `data2` must be a timetable having an homogeneous time grid;
   - `data1` and `data2` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseAsOneDayComparison` is not CI tested.
:::


## plotGlucoseArmAsOneDay
```MATLAB
function plotGlucoseArmAsOneDay(arm,varargin) 
```
Function that generates a plot of an arm in a single plot where each daily profile is overlapped to each other.

### Inputs
   - **arm: cell array of timetable (required)** <br>  
   A cell array of timetables containing the glucose data of the arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `arm` must be a cell array containing timetables;
   - Each timetable in `arm` must have a column names `Time` and a column named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseArmAsOneDay` is not CI tested.
:::

## plotGlucoseArmAsOneDayComparison
```MATLAB
function plotGlucoseArmAsOneDayComparison(arm1,arm2,varargin) 
```
Function that generates a plot of an arm in a single plot where each daily profile is overlapped to each other.

### Inputs
   - **arm1: cell array of timetable (required)** <br>  
   A cell array of timetables containing the glucose data of the first arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
   - **arm2: cell array of timetable (required)** <br>  
   A cell array of timetables containing the glucose data of the second arm. Each timetable corresponds to a patient and contains a column `Time` and a column `glucose` containg the glucose recordings (in mg/dl);
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `arm1` must be a cell array containing timetables;
   - Each timetable in `arm1` must have a column names `Time` and a column named `glucose`;
   - `arm2` must be a cell array containing timetables;
   - Each timetable in `arm2` must have a column names `Time` and a column named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseArmAsOneDayComparison` is not CI tested.
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
   - **DOB: vector of characters (optional, default: '')** <br> 
   A vector of characters defining the date of birth of the patient; 
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to each AGP or not.
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `Name` must be a vector of characters;
   - `DOB` must be a vector of characters;
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
   - `FontSize` must be an integer.

### Reference
  - Magni et al., "Evaluating the efficacy of closed-loop glucose regulation via control-variability grid analysis", Journal of Diabetes Science and Technology, 2008, vol. 2, pp. 630-635. DOI: 10.1177/193229680800200414.

::: warning
Currently `plotCVGA` is not CI tested.
:::

## plotCVGAComparison
```MATLAB
function plotCVGAComparison(glucoseProfilesArm1,glucoseProfilesArm2, varargin)
```
Function that plots and visually compares the control variablity grid analysis (CVGA) of two arms.

### Input
   - **glucoseProfilesArm1: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl) of arm 1.
   - **glucoseProfilesArm2: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl) of arm 2.  
   - **PlotZoneNames (optional, default: 1, {0, 1})** <br>
   A numerical flag defining whether to plot the zone names in the CVGA plot or not.
   - **HighlightBestControl (optional, default: 1, {0, 1})** <br> 
   A numerical flag defining whether to highlight the best controlled profile in the CVGA plot or not.
   - **FontSize: integer (optional, default: 16)** <br> 
   A scalar defining the font size of the CVGA plot.
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to generated CVGA.

### Preconditions
   - `glucoseProfilesArm1` must be a cell array containing timetables;
   - Each timetable in `glucoseProfilesArm1` must have a column names `Time` and a column named `glucose`;
   - `glucoseProfilesArm2` must be a cell array containing timetables;
   - Each timetable in `glucoseProfilesArm2` must have a column names `Time` and a column named `glucose`;
   - `PlotZoneNames` can be 0 or 1;
   - `HighlightBestControl` can be 0 or 1;
   - `PrintFigure` can be 0 or 1.
   - `FontSize` must be an integer.

### Reference
  - Magni et al., "Evaluating the efficacy of closed-loop glucose regulation via control-variability grid analysis", Journal of Diabetes Science and Technology, 2008, vol. 2, pp. 630-635. DOI: 10.1177/193229680800200414.

::: warning
Currently `plotCVGAComparison` is not CI tested.
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
   A numeric flag defining whether to output the .pdf files associated to the figure or not.

### Preconditions
   - `glucoseProfiles` must be a cell array containing timetables;
   - Each timetable in `glucoseProfiles` must have a column names `Time` and a column named `glucose`;
   - `HighlightBest` can be 0 or 1.
   - `FontSize` must be an integer.
   - `PrintFigure` can be 0 or 1.

### Reference
  - Klonoff et al., "A Glycemia Risk Index (GRI) of hypoglycemia and hyperglycemia for continuous glucose monitoring validated by clinician ratings", Journal of Diabetes Science and Technology, 2022, pp. 1-17. DOI: 10.1177/19322968221085273.

::: warning
Currently `plotGRI` is not CI tested.
:::

## plotGRIComparison
```MATLAB
function plotGRIComparison(glucoseProfiles, varargin)
```
Function that plots and visually compares the control variablity grid analysis (CVGA) of two arms.

### Input
   - **glucoseProfilesArm1: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl) of arm 1.
   - **glucoseProfilesArm2: cell array of timetable (required)** <br>  
   A cell array of timetables each with column `Time` and 
   `glucose` containing the glucose data to analyze (in mg/dl) of arm 2. 
   - **HighlightBest: integer (optional, default: 1, {0, 1})** <br>
   A numerical flag defining whether to highlight the best GRI dot in the plot or not.
   - **FontSize: integer (optional, default: 16)** <br> 
   A scalar defining the font size of the GRI plot.
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.

### Preconditions
   - `glucoseProfilesArm1` must be a cell array containing timetables;
   - Each timetable in `glucoseProfilesArm1` must have a column names `Time` and a column named `glucose`;
   - `glucoseProfilesArm2` must be a cell array containing timetables;
   - Each timetable in `glucoseProfilesArm2` must have a column names `Time` and a column named `glucose`;
   - `PlotZoneNames` can be 0 or 1;
   - `HighlightBestControl` can be 0 or 1;
   - `PrintFigure` can be 0 or 1.
   - `FontSize` must be an integer.

### Reference
  - Klonoff et al., "A Glycemia Risk Index (GRI) of hypoglycemia and hyperglycemia for continuous glucose monitoring validated by clinician ratings", Journal of Diabetes Science and Technology, 2022, pp. 1-17. DOI: 10.1177/19322968221085273.

::: warning
Currently `plotGRIComparison` is not CI tested.
:::

## plotGlucoseROC
```MATLAB
function plotGlucoseROC(data,varargin)
```
Function that visualizes the glucose ROC of the given data.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - None

::: warning
Currently `plotGlucoseROC` is not CI tested.
:::

## histGlucoseROC
```MATLAB
function histGlucoseROC(data,varargin)
```
Function that visualizes the histogram of the glucose ROC of the given data.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

::: warning
Currently `histGlucoseROC` is not CI tested.
:::

## plotAggregatedGlucose
```MATLAB
function plotAggregatedGlucose(data,varargin)
```
Function that visualizes the given data with superimposed aggregated glucose values.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

::: warning
Currently `plotAggregatedGlucose` is not CI tested.
:::

## plotPoincareGlucose
```MATLAB
function plotPoincareGlucose(data,varargin)
```
Function that generates the Poincare' plot of the ```(x,y) = (glucose(t-1),glucose(t))``` graph. 

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data` must be a timetable;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

::: warning
Currently `plotPoincareGlucose` is not CI tested.
:::

## plotPoincareGlucoseComparison
```MATLAB
function plotPoincareGlucoseComparison(data1,data2,varargin)
```
Function that generates and compares the Poincare' plot of the ```(x,y) = (glucose(t-1),glucose(t))``` graphs of two CGM profiles. 

### Input
   - **data1: timetable (required)** <br>
   A first timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **data2: timetable (required)** <br>
   A second timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **PrintFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data1` must be a timetable;
   - `data1` must contain a column named `Time` and another named `glucose`;
   - `data2` must be a timetable;
   - `data2` must contain a column named `Time` and another named `glucose`;
   - `PrintFigure` can be 0 or 1.
### Reference
   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose Monitor Data", Diabetes Technol Ther, 2009, vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.

::: warning
Currently `plotPoincareGlucoseComparison` is not CI tested.
:::

## plotClarkeErrorGrid
```MATLAB
function plotClarkeErrorGrid(data,dataHat,printFigure)
```
Function that plots the Clarke Error Grid.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
   - **dataHat: timetable (required)** <br>
   A timetable with column `Time` and `glucose` containing the inferred glucose data (in mg/dl) to compare with `data`;
   - **printFigure: integer (optional, default: 0, {0, 1})** <br> 
   A numeric flag defining whether to output the .pdf files associated to the figure or not.
### Preconditions
   - `data` must be a timetable with homogeneous timegrid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `dataHat` must be a timetable with homogeneous timegrid;
   - `dataHat` must contain a column named `Time` and another named `glucose`;
   - `data` and `dataHat` must start from the same timestamp and end with the same timestamp;
   - `data` and `dataHat` must have the same length;
   - `printFigure` can be 0 or 1.
### Reference
   - Clarke et al., "Evaluating clinical accuracy of systems for self-monitoring of blood glucose", Diabetes Care, 1987, vol. 10, pp. 622–628. DOI: 10.2337/diacare.10.5.622.

::: warning
Currently `plotClarkeErrorGrid` is not CI tested.
:::