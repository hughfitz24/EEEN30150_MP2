function Y = rungeKutta(f, y0, x0, xf, h)
% rungeKutta.m
% Solve ODE using 4th-order Runge-Kutta method
%   Inputs:
%     F         - Function handle @(x,y) that returns dy/dx at point
%                 (x,y). Represents the system of ODEs.
%     y0        - Initial value(s) of y at x0 (scalar or vector)
%     x0        - Initial value of x
%     xf        - Final value of x
%     h         - Step size
%
%   Output:
%     Y         - Solution vector/matrix

    % Ensure y0 is a column vector
    y0 = y0(:);
    % Get number of varibles in the system
    numVars = length(y0);
    
    % Calculate number of steps
    n = round((xf - x0) / h) + 1;
    
    % Prepare output array
    Y = zeros(numVars, n);
    Y(:,1) = y0;
    x = x0;
  
    
    % Perform RK4 integration
    for i = 2:n
        % Current state
        yi = Y(:, i-1);
        
        % RK4 stages, reshape used to ensure row vectors
        k1 = f(x, yi);
        k2 = f(x + h/2, yi + h/2 * k1);
        k3 = f(x + h/2, yi + h/2 * k2);
        k4 = f(x + h, yi + h * k3);
        
        % Update solution
        Y(:, i) = yi + h/6 * (k1 + 2*k2 + 2*k3 + k4);
        
        % Update x
        x = x + h;
    end
end