# Glycemic transformation metrics

## hypoIndex
```MATLAB
function hypoIndex = hypoIndex(data)
```
Function that computes the hypoglycemic index by Rodbard (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **hypoIndex: double** <br>
   The hypoglycemic index (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   -  Rodbard et al., "Interpretation of continuous glucose monitoring data: glycemic variability and quality of glycemic control", Diabetes Technology & Therapeutics, 2009, vol. 11, pp. S55-S67. DOI: 10.1089/dia.2008.0132.

## hyperIndex
```MATLAB
function hyperIndex = hyperIndex(data)
```
Function that computes the hyperglycemic index by Rodbard (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **hyperIndex: double** <br>
   The hyperglycemic index (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   -  Rodbard et al., "Interpretation of continuous glucose monitoring data: glycemic variability and quality of glycemic control", Diabetes Technology & Therapeutics, 2009, vol. 11, pp. S55-S67. DOI: 10.1089/dia.2008.0132.

## igc
```MATLAB
function igc = igc(data)
```
Function that computes the index of glycemic control (IGC) by Rodbard (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **igc: double** <br>
   The index of glycemic control (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   -  Rodbard et al., "Interpretation of continuous glucose monitoring data: glycemic variability and quality of glycemic control", Diabetes Technology & Therapeutics, 2009, vol. 11, pp. S55-S67. DOI: 10.1089/dia.2008.0132.

## mrIndex
```MATLAB
function mrIndex = mrIndex(data,r)
```
Function that computes the mr value by Schlichtkrull (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl);
   - **r: integer (optional, default: 100 )** <br>
   An integer that is a parameter for mr index calculation. 
### Output 
   - **mrIndex: double** <br>
   The mr value (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`;
   - `r` must be an integer.
### Reference
   - Schlichtkrull et al., "The M-value, an index of blood-sugar control in diabetics", Acta Medica Scandinavica, 1965, vol. 177, pp. 95-102. DOI: 10.1111/j.0954-6820.1965.tb01810.x.

## gradeScore 
```MATLAB
function gradeScore = gradeScore(data)
```
Function that computes the glycemic risk assessment diabetes equation score (GRADE) by Hill (ignores nan values).

### Input 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **gradeScore: double** <br>
   The glycemic risk assessment diabetes equation score (GRADE) (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Hill et al., "A method for assessing quality of control from glucose profiles", Diabetic Medicine , 2007, vol. 24, pp. 753-758. DOI: 10.1111/j.1464-5491.2007.02119.x.

## gradeEuScore
```MATLAB
function gradeEuScore = gradeEuScore(data)
```
Function that computes the glycemic risk assessment diabetes equation score in the euglycemic range (GRADEeu) by Hill (ignores nan values).

### Input 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **gradeEuScore: double** <br>
   The glycemic risk assessment diabetes equation score in the euglycemic range (GRADEeu) (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Hill et al., "A method for assessing quality of control from glucose profiles", Diabetic Medicine , 2007, vol. 24, pp. 753-758. DOI: 10.1111/j.1464-5491.2007.02119.x.

## gradeHypoScore
```MATLAB
function gradeHypoScore = gradeHypoScore(data)
```
Function that computes the glycemic risk assessment diabetes equation score in the hypoglycemic range (GRADEhypo) by Hill (ignores nan values).

### Input 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **gradeHypoScore: double** <br>
   The glycemic risk assessment diabetes equation score in the hypoglycemic range (GRADEhypo) (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid.
### Reference
   - Hill et al., "A method for assessing quality of control from glucose profiles", Diabetic Medicine , 2007, vol. 24, pp. 753-758. DOI: 10.1111/j.1464-5491.2007.02119.x.

## gradeHyperScore
```MATLAB
function gradeHyperScore = gradeHyperScore(data)
```
Function that computes the glycemic risk assessment diabetes equation score in the hyperglycemic range (GRADEhyper) by Hill (ignores nan values).

### Input 
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **gradeHyperScore: double** <br>
   The glycemic risk assessment diabetes equation score in the hyperglycemic range (GRADEhyper) (%).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Hill et al., "A method for assessing quality of control from glucose profiles", Diabetic Medicine , 2007, vol. 24, pp. 753-758. DOI: 10.1111/j.1464-5491.2007.02119.x.