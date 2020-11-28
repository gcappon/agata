function DynamicRisk = DynamicRisk(data)
%DynamicRisk function that compute the dynamic risk based on current
%glucose concentration and its rate-of-change, using hyperbolic tangent with
%pre-defined parameters as amplification function
%
%Reference:
%  - S. Guerra et al., "A Dynamic Risk Measure from Continuous Glucose
%  Monitoring Data", Diabetes Technol. Ther., 2011. 
%  doi: https://doi.org/10.1089/dia.2011.0006
%
% The function ignores nan values
% 
%Input:
%  - data: a timetable with column 'Time' and 'glucose' containing the
%  glucose data to analyze (in mg/dL)
%Output:
%  - DynamicRisk: dynamic risk value.
%
%Preconfitions:
%  - data must be a timetable having an homogeneous time grid.
%
% ------------------------------------------------------------------------
%
% This file is part of AGATA.
%
% ------------------------------------------------------------------------


%Check preconditions
if(~istimetable(data))
    error('DynamicRisk: data must be a timetable.');
end
if(length(unique(diff(data.Time))) ~= 1)
    error('DynamicRisk: data must have a homogeneous time grid.')
end


%Compute rate-of-change
ROC = [0;diff(data.glucose)/minutes(unique(diff(data.Time)))];

%Initialization
alpha = 1.084;      
beta = 5.381;       
gamma = 1.509;

MaximumAmplification = 2.5;
MaximumDamping = 0.65;
AmplificationRapidity = 3;
DRdelta=(MaximumAmplification-MaximumDamping)/2;
DRbeta=DRdelta+MaximumDamping;
DRgamma=atanh((1-DRbeta)/DRdelta);
rl = zeros(length(data.glucose),1); %low risk
rh = zeros(length(data.glucose),1); %high risk

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

dr_over_dg(:,1) = 10*gamma^2*2*alpha*(log(data.glucose).^(2*alpha-1)-beta*log(data.glucose).^(alpha-1))./data.glucose;
modulation_factor = DRdelta*tanh(AmplificationRapidity*dr_over_dg.*ROC+DRgamma)+DRbeta;

DynamicRisk = SR.*modulation_factor;

end
