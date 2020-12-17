function gRMSE = gRMSE(data,dataHat)
%gRMSE function that computes the glucose root mean squared erro (gRMSE) between 
%two glucose traces (ignores nan values).
%
%Inputs:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl);
%   - dataHat: a timetable with column `Time` and `glucose` containing the inferred 
%   glucose data (in mg/dl) to compare with `data`.
%Output:
%   - gRMSE: the computed glucose root mean squared error (mg/dl).
%
%Preconditions:
%   - data and dataHat must be a timetable having an homogeneous time grid;
%   - data and dataHat must contain a column named `Time` and another named `glucose`;
%   - data and dataHat must start from the same timestamp;
%   - data and dataHat must end with the same timestamp;
%   - data and dataHat must have the same length.
%
% ------------------------------------------------------------------------
% 
% REFERENCE:
%  - Del Favero et al., "A glucose-specific metric to assess predictors and 
%   identify models", IEEE Transactions on Biomedical Engineering, 2012, 
%   vol. 59, pp. 1281-1290. DOI: 10.1109/TBME.2012.2185234.
%
% ------------------------------------------------------------------------
%
% Copyright (C) 2020 Simone Del Favero
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Check preconditions 
    if(~istimetable(data))
        error('gRMSE: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('gRMSE: data must have a homogeneous time grid.')
    end
    if(~istimetable(data))
        error('gRMSE: dataHat must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0)
        error('gRMSE: dataHat must have a homogeneous time grid.')
    end
    if(data.Time(1) ~= dataHat.Time(1))
        error('gRMSE: data and dataHat must start from the same timestamp.')
    end
    if(data.Time(end) ~= dataHat.Time(end))
        error('gRMSE: data and dataHat must end with the same timestamp.')
    end
    if(height(data) ~= height(dataHat))
        error('gRMSE: data and dataHat must have the same length.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('gRMSE: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('gRMSE: data must have a column named `glucose`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'Time')))
        error('gRMSE: dataHat must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(dataHat),'glucose')))
        error('gRMSE: dataHat must have a column named `glucose`.')
    end
    
    %Get indices having no nans in both timetables
    idx = find(~isnan(dataHat.glucose) & ~isnan(data.glucose));
    
    data = data.glucose(idx);
    dataHat = dataHat.glucose(idx);
    
    %Parameters
    alphaL=1.5;%1.5
    alphaH=1;%1
    dL1=10;
    dL2=30;
    dH1=20;
    dH2=100;
   
    %Compute the cost
    errorGridInspiredCost=1+alphaL.* c2Sigmoid(data,dataHat,dL1,'<=').*...
                                          c2Sigmoid(data,80,dL2,'<=')+...
                                alphaH.*c2Sigmoid(data,dataHat,dH1,'>=').*...
                                        c2Sigmoid(data,250,dH2,'>=');

    %Compute the quadratic cost function
    quadraticCost=(data-dataHat).^2;

    %Compute the gMSE
    gMSE = nanmean(quadraticCost.*errorGridInspiredCost);
    
    %Compute the gRMSE
    gRMSE = sqrt(gMSE);
    
end

function y=c2Sigmoid(xVector,a,d,type)
    %Auxiliary function 
    
    if max(size(a))==1
        a=a+0.*xVector;
    end

    for idxC=1:size(xVector,2)
        
        for idxR=1:size(xVector,1)

            x=xVector(idxR,idxC); 
            
            switch type
                case '>=' 
                    xi=2/d*(x-a(idxR,idxC)-d/2);  
                case '<='
                    xi=-2/d*(x-a(idxR,idxC)+d/2);  
            end
            
            if xi<=-1  
                y(idxR,idxC)=0;
            elseif  xi>=1
                y(idxR,idxC)=1;
            elseif (xi<=0)    
                y(idxR,idxC)=1/2*(-xi^4-2*xi^3+2*xi+1);
            else 
            	y(idxR,idxC)=1/2*(xi^4-2*xi^3+2*xi+1);
            end
            
        end
        
    end
    
end
