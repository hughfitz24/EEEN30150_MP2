function y_corr = adamsMoulton(y_hist, h, f_hist, f_np1_pred)
    % adamsMoulton.m
    % Solve ODE using 4-Step Adams-Moulton corrector method
    %   Inputs:
    %     y_hist    - Previous 4 values of the independent variable y
    %     h         - Step size
    %     f_hist    - Previous 4 solutions of the system
    %   Output:
    %     y_pred    - Solution vector/matrix of corrected valued
    % Written by Hugh Fitzpatrick, 22341351

    % Implementation of the Adams-Moulton method as a corrector, using the
    % previous 3 solutions to the system of ODEs to correct the predicted
    % value.

    y_corr = y_hist(:,3) + h * (9/24*f_np1_pred + 19/24*f_hist(:,3) ...
                                - 5/24*f_hist(:,2) + 1/24*f_hist(:,1));
end
