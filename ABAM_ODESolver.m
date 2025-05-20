function [T, Y] = ABAM_ODESolver(f, y0, x0, xf, h)
% ABAM: full 4th-order predictor-corrector
%   f  - @(t,y)
%   y0 - initial row vector
% Outputs:
%   T (N×1), Y (N×m)

    % build time vector
    T = (x0:h:xf)';
    N = numel(T);

    % ensure row vector
    y0 = reshape(y0,1,[]);
    m  = size(y0,2);

    % preallocate
    Y = zeros(N, m);
    Y(1,:) = y0;

    % 1) Bootstrap first 4 points via RK4
    Y_boot = rungeKutta(f, y0, x0, x0 + 3*h, h);  % returns 4 rows
    Y(1:4,:) = Y_boot;

    % 2) Main loop from n=4 to N-1 (so that n-3 >= 1 and n+1 <= N)
    for n = 4:(N-1)
        % times for AB predictor: t_{n-3}..t_n
        t_hist_AB = T(n-3 : n).';           % 1×4
        y_hist_AB = Y(n-3 : n, :);          % 4×m

        % predictor step
        y_pred = adamsBashforth(f, t_hist_AB, y_hist_AB, h);

        % times for AM corrector: t_{n-2}..t_{n+1}
        t_hist_AM = T(n-2 : n+1).';         % 1×4
        y_hist_AM = Y(n-2 : n, :);          % 3×m

        % corrector step
        y_corr = adamsMoulton(f, t_hist_AM, y_hist_AM, h, y_pred);

        % store
        Y(n+1, :) = y_corr;
    end
end
