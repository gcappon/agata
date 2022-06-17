function poincareGlucose = poincareGlucose(data)
%poincareGlucose fits an ellipse corresponding to the Poincare' plot of the
%(x,y) = (glucose(t-1),glucose(t)) graph. To do so, it uses the least square method. 
%If an ellipse was not detected (but a parabola or hyperbola), then an 
%empty structure is returned.
%
%Input:
%   - data: a timetable with column `Time` and `glucose` containing the 
%   glucose data to analyze (in mg/dl).
%
%Output:
%   - poincareGlucose: a structure with fields containing the parameter of the fitted
%   Poincare' ellipse, i.e.:
%        - `a`: sub axis (radius) of the X axis of the non-tilt ellipse;
%        - `b`: sub axis (radius) of the Y axis of the non-tilt ellipse;
%        - `phi`: sub axis (radius) of the X axis of the non-tilt ellipse;
%        - `X0`: center at the X axis of the non-tilt ellipse;
%        - `Y0`: center at the Y axis of the non-tilt ellipse;
%        - `X0_in`: center at the X axis of the tilted ellipse;
%        - `Y0_in`: center at the Y axis of the tilted ellipse;
%        - `long_axis`: size of the long axis of the ellipse;
%        - `short_axis`: size of the short axis of the ellipse;
%        - `status`: status of detection of an ellipse;     
%
%Preconditions:
%   - `data` must be a timetable.
%   - `data` must contain a column named `Time` and another named `glucose`.
%
% ---------------------------------------------------------------------
%
% Reference:
%   - Clarke et al., "Statistical Tools to Analyze Continuous Glucose
%   Monitor Data", Diabetes Technol Ther, 2009,
%   vol. 11, pp. S45-S54. DOI: 10.1089=dia.2008.0138.
%   - Based on fit_ellipse function by Ohad Gal. 
%   https://it.mathworks.com/matlabcentral/fileexchange/3215-fit_ellipse
%
% ---------------------------------------------------------------------
%
% Copyright (C) 2021 Ohad Gal
%
% This file is part of AGATA.
%
% ---------------------------------------------------------------------

    %Check preconditions 
    if(~istimetable(data))
        error('poincareGlucose: data must be a timetable.');
    end
    if(var(seconds(diff(data.Time))) > 0 || isnan(var(seconds(diff(data.Time)))))
        error('poincareGlucose: data must have a homogeneous time grid.')
    end
    if(~any(strcmp(fieldnames(data),'Time')))
        error('poincareGlucose: data must have a column named `Time`.')
    end
    if(~any(strcmp(fieldnames(data),'glucose')))
        error('poincareGlucose: data must have a column named `glucose`.')
    end
    
    % initialize
    orientation_tolerance = 1e-3;

    % empty warning stack
    warning( '' );
    
    % prepare vectors, must be column vectors
    data = data(~isnan(data.glucose),:);
    x = data.glucose(1:end-1);
    y = data.glucose(2:end);
    
    % remove bias of the ellipse - to make matrix inversion more accurate. (will be added later on).
    mean_x = mean(x);
    mean_y = mean(y);
    x = x-mean_x;
    y = y-mean_y;
    
    % the estimation for the conic equation of the ellipse
    X = [x.^2, x.*y, y.^2, x, y ];
    a = sum(X)/(X'*X);
    
    % check for warnings
    if ~isempty( lastwarn )
        disp( 'stopped because of a warning regarding matrix inversion' );
        poincareGlucose = [];
        return
    end
    
    % extract parameters from the conic equation
    [a,b,c,d,e] = deal( a(1),a(2),a(3),a(4),a(5) );
    
    % remove the orientation from the ellipse
    if ( min(abs(b/a),abs(b/c)) > orientation_tolerance )
    
        orientation_rad = 1/2 * atan( b/(c-a) );
        cos_phi = cos( orientation_rad );
        sin_phi = sin( orientation_rad );
        [a,b,c,d,e] = deal(...
            a*cos_phi^2 - b*cos_phi*sin_phi + c*sin_phi^2,...
            0,...
            a*sin_phi^2 + b*cos_phi*sin_phi + c*cos_phi^2,...
            d*cos_phi - e*sin_phi,...
            d*sin_phi + e*cos_phi );
        [mean_x,mean_y] = deal( ...
            cos_phi*mean_x - sin_phi*mean_y,...
            sin_phi*mean_x + cos_phi*mean_y );
    else
        orientation_rad = 0;
        cos_phi = cos( orientation_rad );
        sin_phi = sin( orientation_rad );
    end
    
    % check if conic equation represents an ellipse
    test = a*c;
    switch (1)
    case (test>0),  status = '';
    case (test==0), status = 'Parabola found';  warning( 'fit_ellipse: Did not locate an ellipse' );
    case (test<0),  status = 'Hyperbola found'; warning( 'fit_ellipse: Did not locate an ellipse' );
    end
    
    % if we found an ellipse return it's data
    if (test>0)

        % make sure coefficients are positive as required
        if (a<0), [a,c,d,e] = deal( -a,-c,-d,-e ); end

        % final ellipse parameters
        X0          = mean_x - d/2/a;
        Y0          = mean_y - e/2/c;
        F           = 1 + (d^2)/(4*a) + (e^2)/(4*c);
        [a,b]       = deal( sqrt( F/a ),sqrt( F/c ) );    
        long_axis   = 2*max(a,b);
        short_axis  = 2*min(a,b);
        % rotate the axes backwards to find the center point of the original TILTED ellipse
        R           = [ cos_phi sin_phi; -sin_phi cos_phi ];
        P_in        = R * [X0;Y0];
        X0_in       = P_in(1);
        Y0_in       = P_in(2);

        % pack ellipse into a structure
        poincareGlucose = struct( ...
            'a',a,...
            'b',b,...
            'phi',orientation_rad,...
            'X0',X0,...
            'Y0',Y0,...
            'X0_in',X0_in,...
            'Y0_in',Y0_in,...
            'long_axis',long_axis,...
            'short_axis',short_axis,...
            'status','' );
    else
        % report an empty structure
        poincareGlucose = struct( ...
            'a',[],...
            'b',[],...
            'phi',[],...
            'X0',[],...
            'Y0',[],...
            'X0_in',[],...
            'Y0_in',[],...
            'long_axis',[],...
            'short_axis',[],...
            'status',status );
    end

end
