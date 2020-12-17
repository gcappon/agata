function dynamicRisk = dynamicRisk(data,varargin)
%dynamicRisk Function that computes the dynamic risk based on current
%glucose concentration and its rate-of-change. An `AmplificationFunction` 
%is used to eventually amplify the effect of the rate-of-change. 
%The function treats nan values as missing values.
% 
%Inputs:
%  - data: a timetable with column 'Time' and 'glucose' containing the
%  glucose data to analyze (in mg/dL)
%  - AmplificationFunction (optional): function to use for amplyfing the
%  rate-of-change contribution to the dynamic risk. Set it as 
%  'AmplificationFunction','fncname' (possible fncname: 'exp', 'tanh')
%  - MaximumAmplification (optional): intensity of amplification. Set it
%  as 'MaximumAmplification',x (x must be a scalar>1. Default value: 2.5) 
%  - AmplificationRapidity (optional): rapidity of the amplification. Set 
%  it as 'AmplificationRapidity',x (x must be a scalar>0. Default value: 2) 
%  - MaximumDamping (optional): damping of amplification. Set it as
%  'MaximumDamping',x (x must be a scalar>0. Default value: 0.6) 
%
%Output:
%  - dynamicRisk: dynamic risk timeseries, with the same length as data.
%
%Preconditions:
%  - data must be a timetable having an homogeneous time grid;
%  - data must contain a column named `Time` and another named `glucose`.
%  - AmplificationFunction must be a 'exp' or 'tanh';
%  - MaximumAmplification must be a scalar > 1;
%  - AmplificationRapidity must be a scalar > 0;
%  - MaximumDamping must be a scalar > 0.
% 
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - S. Guerra et al., "A Dynamic Risk Measure from Continuous Glucose Monitoring 
%  Data", Diabetes Technology & Therapeutics, 2011, vol. 13, pp. 843-852. DOI: 10.1089/dia.2011.0006
% 
% ------------------------------------------------------------------------
% 
% Copyright (C) 2020 by Nunzio Camerlingo
% 
% This file is part of AGATA.
%
% ------------------------------------------------------------------------


    %Input parser and check preconditions
    default_AmplificationFunction = 'tanh';
    expected_AmplificationFunction = {'tanh','exp'};
    default_MaximumAmplification = 2.5;
    default_AmplificationRapidity = 2;
    default_MaximumDamping = 0.6;

    params = inputParser;
    params.CaseSensitive = false;
    validScalar = @(x) isnumeric(x) && isscalar(x) && (x>=0);

    addRequired(params,'data',@(x) validData(x));
    addParameter(params,'AmplificationFunction',default_AmplificationFunction,...
        @(x) any(validatestring(x,expected_AmplificationFunction)));
    addOptional(params,'MaximumAmplification',default_MaximumAmplification, @(x) (validScalar(x) && (x>=1)));
    addOptional(params,'AmplificationRapidity',default_AmplificationRapidity,validScalar);
    addOptional(params,'MaximumDamping',default_MaximumDamping,validScalar);

    parse(params,data,varargin{:});

    %Initialization
    alpha = 1.084;      
    beta = 5.381;       
    gamma = 1.509;
    amplificationFunction = params.Results.AmplificationFunction;
    maximumAmplification = params.Results.MaximumAmplification;
    amplificationRapidity = params.Results.AmplificationRapidity;
    maximumDamping = params.Results.MaximumDamping;
    drdelta=(maximumAmplification-maximumDamping)/2;
    drbeta=drdelta+maximumDamping;
    drgamma=atanh((1-drbeta)/drdelta);
    rl = zeros(length(data.glucose),1); %low risk
    rh = zeros(length(data.glucose),1); %high risk

    %Compute rate-of-change
    roc = [0;diff(data.glucose)/minutes(unique(diff(data.Time)))];

    %Dynamic Risk computation
    for i = 1:length(data.glucose)
        f = gamma*(((log(data.glucose(i)))^alpha)-beta);
        if f<0
            rl(i,1) = 10*(f^2);
        elseif f>0
            rh(i,1) = 10*(f^2);
        end
    end

    SR(:,1) = rh-rl;

    modulation_factor = ones(length(data.glucose),1);
    dr_over_dg(:,1) = 10*gamma^2*2*alpha*(log(data.glucose).^(2*alpha-1)-beta*log(data.glucose).^(alpha-1))./data.glucose;

    switch amplificationFunction
        case 'exp'
            modulation_factor = exp(maximumAmplification*dr_over_dg.*roc);
        case 'tanh'
            modulation_factor = drdelta*tanh(amplificationRapidity*dr_over_dg.*roc+drgamma)+drbeta;
    end

    dynamicRisk = SR.*modulation_factor;

end

function valid = validData(data)
    %Input validator function handler 
    
    valid = istimetable(data);
    if(~valid)
        error('dynamicRisk: data must be a timetable.');
    end
    
    valid = var(seconds(diff(data.Time))) == 0 && ~isnan(var(seconds(diff(data.Time))));
    if(~valid)
        error('dynamicRisk: data must have a homogeneous time grid.')
    end
    
    valid = any(strcmp(fieldnames(data),'Time'));
    if(~valid)
        error('dynamicRisk: data must have a column named `Time`.')
    end
    
    valid = any(strcmp(fieldnames(data),'glucose'));
    if(~valid)
        error('dynamicRisk: data must have a column named `glucose`.')
    end
    
end
