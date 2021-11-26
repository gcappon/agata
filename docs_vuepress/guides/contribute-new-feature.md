# Contributing to AGATA: Developing new features

This guide is intended to describe the steps to follow when you want to contribute to AGATA by solving opened issues that involves developing new AGATA features, a.k.a new functions. 

## Step 1. This is the issue you were looking for

Firstly, you have to find the issue that is made for you. Simply go to the AGATA *issues* section in Github and choose between one of the available issues labeled as ![enhancement](./enhancement.png). <br>

::: tip
If you are new to the concept of contributing to an open source repository, try to start from the issues labeled also as ![good first issue](./good-first-issue.png).
:::

Once you decided, just comment the issue saying that you will get into solving the issue ASAP, and finally propose a due date.

## Step 2. Code the required stuff

Once your development environment is set (see [Contributing to AGATA: A step-by-step guide](./contribute-guide.md) for details on this), when you are developing a new AGATA functionality, as such a new function, you are required of producing specific `*.m` files.

Lets assume you want to add a new function that compute the mean glucose concentration of a given glucose trace, and you decided to call it `meanGlucose.m`. You are required to produce **two** files:

1. The `*.m` function that implements the functionality to develop, i.e., `meanGlucose.m`;
2. The `*Test.m` script that tests `meanGlucose.m`, i.e., `meanGlucoseTest.m`.

### 1. `*.m` function requirements

The `*.m` function must implement the following concepts:

* **AGATA ❤️ timetables**: if your function need to be fed with, use, manipulate, ..., timeseries such as glucose data, you are required to use MATLAB timetables to deal with them (see [https://it.mathworks.com/help/matlab/timetables.html](https://it.mathworks.com/help/matlab/timetables.html) for more details on the timetable format);
* **NaN robust**: your fuction will, in general, deal with real data. As you know, real data are present missing values (represented in MATLAB as `NaN` values). Your function must be robust to `Nan` values and should properly manage their presence;
* **Documentation friendly**: your function must begin with a comment section briefly stating the function scope, its inputs, and its outputs;
* **Bibliographic reference is the essence**: if your function involves the computation of state-of-the-art formulae, algorithms, and so on and so forth, you need to specify in the function documentation some bibliography that reference such a thing.
* **Check for preconditions**: before running its code, your function needs to check if the preconditions are fulfilled. If not, the function should launch an error.
Common preconditions are: i) an input glucose timeseries present an homogeneous time grid, ii) all required inputs must be provided to the function, iii) correct variable type and so on and so forth. 

Here's a possible implementation of `meanGlucose.m`

```MATLAB
function meanGlucose = meanGlucose(data)
%meanGlucose function that computes the mean glucose concentration
%(ignores nan values).
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl). 
%Output:
%   - meanGlucose: mean glucose concentration.
%
%Preconditions:
%   - data must be a timetable having an homogeneous time grid.
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------
    
    %Check preconditions 
    if(~istimetable(data))
        error('meanGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('meanGlucose: data must have a homogeneous time grid.')
    end
    
    %Remove nan values from calculation
    nonNanGlucose = data.glucose(~isnan(data.glucose));
    
    %Compute mean
    meanGlucose = mean(nonNanGlucose);
    
end
```

Note that here we are computing just the mean so there is no need to add a bibliographic reference to this function.

### 2. `*Test.m` script requirements

AGATA implements [Travis CI](https://travis-ci.org/) to fast test its code and provide user with robust and (hopefully) bug-free code. 

As such, you are required to write also a proper script to unit test you `*.m` function. 

To do so, you have to write a MATLAB script that has the same name as the `*.m` function followed by the `Test` suffix, i.e., `*Test.m`.

In our example, you are required to write a `*Test.m` script for your newly developed `meanGlucose.m`, thus called `meanGlucoseTest.m`.

::: tip
Try to write a unit test that covers most of the possible input scenarios that your new function is supposed to encounter.
:::

A possible implementation of `meanGlucoseTest.m` follows

```MATLAB
% Test units of the meanGlucose function
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2020 Giacomo Cappon
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

time = datetime(2000,1,1,0,0,0):minutes(5):datetime(2000,1,1,0,0,0)+minutes(50); % length = 11;
data = timetable(zeros(length(time),1),'VariableNames', {'glucose'}, 'RowTimes', time);
data.glucose(1) = 40;
data.glucose(2:3) = 50;
data.glucose(4) = 80;
data.glucose(5:6) = 120;
data.glucose(7:8) = 200;
data.glucose(9:10) = 260;
data.glucose(11) = nan;

%% Test 1: check NaN presence
results = meanGlucose(data);
assert(~isnan(results));

%% Test 2: check results calculation
results = meanGlucose(data);
assert(results == 138);
```

::: warning
Remember to add to the working directory *PATH* of `*Test.m` the `*.m` function. Otherwise, it will generate an error during its execution.
:::

For more details on how to write and run script-based unit tests in MATLAB see [https://it.mathworks.com/help/matlab/script-based-unit-tests.html](https://it.mathworks.com/help/matlab/script-based-unit-tests.html).

## Step 3. Put your code in the right place

Once you debugged the two files, it is time to put them in the right place within AGATA.

AGATA is structured as follows:

```
├─ .
├─ docs
├─ src
│  ├─ subfolder1
│  ├─ subfolder2
│  └─ ...
└─ test
   ├─ subfolder1
   ├─ subfolder2
   └─ ...
```

You have to put your `.m` function in a subfolder of the `src` folder and your `*Test.m` script in the subfolder of the `test` folder that has the same name of the subfolder of `src` you chose (sorry for the wording).

::: tip
Choose the subfolder that relates the most with your new function scope. If none of the already existent subfolders match your ideal choice, just create a new one.
:::

## Step 4: Push and make a pull request

That's all. Push your modifications and make a pull request (see [Contributing to AGATA: A step-by-step guide](./contribute-guide.md) for details on this).


Thanks for helping improving AGATA!