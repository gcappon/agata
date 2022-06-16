# Risk metrics

## lbgi
```MATLAB
function lbgi = lbgi(data)
```
Function that computes the low blood glucose index (LBGI) of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **lbgi: double** <br>
   The low blood glucose index (LBGI) of the glucose concentration (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Kovatchev et al., "Symmetrization of the blood glucose measurement scale and
   its applications", Diabetes Care, 1997, vol. 20, pp. 1655-1658. DOI: 10.2337/diacare.20.11.1655.

## hbgi
```MATLAB
function hbgi = hbgi(data)
```
Function that computes the high blood glucose index (HBGI) of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **hbgi: double** <br>
   The low blood glucose index (HBGI) of the glucose concentration (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Kovatchev et al., "Symmetrization of the blood glucose measurement scale and
   its applications", Diabetes Care, 1997, vol. 20, pp. 1655-1658. DOI: 10.2337/diacare.20.11.1655.
   
## bgri
```MATLAB
function bgri = bgri(data)
```
Function that computes the blood glucose risk index (BRGI) of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **bgri: double** <br>
   The blood glucose risk index (BGRI) of the glucose concentration (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Kovatchev et al., "Symmetrization of the blood glucose measurement scale and
   its applications", Diabetes Care, 1997, vol. 20, pp. 1655-1658. DOI: 10.2337/diacare.20.11.1655.
   
## dynamicRisk
```MATLAB
function dynamicRisk = dynamicRisk(data,varargin)
```
Function that computes the dynamic risk based on current
glucose concentration and its rate-of-change. An `AmplificationFunction` is used to eventually amplify the effect of the rate-of-change. The function treats nan values as missing values.

### Inputs
  - **data: timetable (required)** <br>
  A timetable with column `Time` and `glucose` containing the glucose data to analyze (in mg/dl);
  - **AmplificationFunction: vector of char (optional, default: 'tanh', {'tanh','exp'})** <br>
  Function to use for amplyfing the rate-of-change impact on the dynamic risk calculation;
  - **MaximumAmplification: double (optional, default: 2.5)** <br>
  Intensity of amplification;
  - **AmplificationRapidity: double (optional, default: 2)** <br>
  Rapidity of the amplification;
  - **MaximumDamping: double (optional, default: 0.6)** <br>
  Damping of amplification. 
### Output
  - **dynamicRisk: vector of double** <br>
  The dynamic risk timeseries. It has the same length as `data`.
### Preconditions
  - `data` must be a timetable having an homogeneous time grid;
  - `data` must contain a column named `Time` and another named `glucose`;
  - `AmplificationFunction` must be *exp* or *tanh*;
  - `MaximumAmplification` must be a scalar > 1;
  - `AmplificationRapidity` must be a scalar > 0;
  - `MaximumDamping` must be a scalar > 0. 
### Reference 
  - S. Guerra et al., "A Dynamic Risk Measure from Continuous Glucose Monitoring Data", Diabetes Technology & Therapeutics, 2011, vol. 13, pp. 843-852. DOI: 10.1089/dia.2011.0006

## adrr
```MATLAB
function adrr = adrr(data)
```
Function that computes the average daily risk range (ADRR) of the glucose concentration (ignores nan values).

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **adrr: double** <br>
   The average daily risk range (ADRR) of the glucose concentration (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Kovatchev et al., "Evaluation of a new measure of blood glucose variability in
   diabetes", Diabetes Care, 2006, vol. 29, pp. 2433-2438. DOI: 10.2337/dc06-1085.

## gri
```MATLAB
function gri = gri(data)
```
Function that computes the Glycemic Risk Index (GRI) proposed Klonoff et al. (ignoring nan values). GRI seems to be rounded by the authors however it is not explicitly stated. Therefore, GRI is not rounded here.

### Input
   - **data: timetable (required)** <br>
   A timetable with columns `Time` and `glucose` containing the glucose data to analyze (mg/dl).
### Output 
   - **adrr: double** <br>
   The average daily risk range (ADRR) of the glucose concentration (unitless).
### Preconditions
   - `data` must be a timetable having an homogeneous time grid;
   - `data` must contain a column named `Time` and another named `glucose`.
### Reference
   - Klonoff et al., "A Glycemia Risk Index (GRI) of hypoglycemia and hyperglycemia for continuous glucose monitoring validated by clinician ratings", Journal of Diabetes Science and Technology, 2022, pp. 1-17. DOI: 10.1177/19322968221085273.