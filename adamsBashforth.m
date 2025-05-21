function y_pred = adamsBashforth(y_hist, h, f_hist)
    % adamsBashforth.m
    % Solve ODE using 4-Step Adams-Bashforth method
    %   Inputs:
    %     y_hist    - Previous 4 values of the independent variable y
    %     h         - Step size
    %     f_hist    - Previous 4 solutions of the system
    %   Output:
    %     y_pred    - Solution vector/matrix. Acts as predicted values for
    %                 the Adams-Moulton corrective method.

    % Implementation of Adams-Bashforth method, using scaling factors for 4-Step Adams Bashforth and
    % previous solutions passed as input
    y_pred = y_hist(:,4) + h * (55/24*f_hist(:,4) - 59/24*f_hist(:,3) ...
                                + 37/24*f_hist(:,2) - 9/24*f_hist(:,1));
end
