function Y = rungeKutta(f, y0, x0, xf, h)
    %   This function uses the Runge-Kutta method to solve the system of equations
    %   defined in the function f. It takes the following inputs:
    %   - f: function handle for the system of equations
    %   - y0: initial conditions (vector)
    %   - x0: initial x
    %   - xf: final x
    %   - h: time step size
    %   The function returns the solution Y at each time step.
    
    %% Implementation
    %   Initialize time and number of steps
    
    x = x0:h:xf;
    w1 = 1/6;
    w2 = 2/6;
    w3 = 2/6;
    w4 = 1/6;
    a1 = 1/2;
    a2 = 1/2;
    a3 = 1;
    b1 = 1/2;
    b2 = 1/2;
    b3 = 1;
    nSteps = length(x);
    
    %   Initialize solution matrix
    Y = zeros(length(y0));
    %   Set initial conditions
    Y(1, :) = y0;
    %   Run the Runge-Kutta method
    for i = 1:nSteps-1
        k1 = h(f(x(i), Y(i)));
    end
end