function [X, Y, timeStats] = ABAM_ODESolver(f, y0, x0, xf, h, DEBUG)
    % ABAM_ODESolver.m
    % Solves system of ODEs using 4th-order Adams-Bashforth-Moulton method
    % Bootstraps with 4th-order Runge-Kutta
    % 
    % Inputs:
    %   f       - function handle @(x,y), returns dy/dx
    %   y0      - initial condition
    %   x0      - initial x
    %   xf      - final x
    %   h       - step size
    %   DEBUG   - boolean flag, determines if debug info is found
    % Outputs:
    %   X           - x values
    %   Y           - y values (each row corresponds to x in X)
    %   timeStats   - Run time statistics for numerical methods
    % Written by Hugh Fitzpatrick, 22341351

    % Define time stats
     timeStats = zeros(3, 1); % 3 rows (Runge Kutta Time, ABAM total time, ABAM avg time)

    X = (x0:h:xf);
    N = numel(X);

    % Ensure y0 is a column vector
    y0 = y0(:);
    m = numel(y0);

    % Preallocate
    Y = zeros(m, N);
    Y(:,1) = y0;

    % Bootstrap 4 points using Runge-Kutta
    tic;
    Y_boot = rungeKutta(f, y0, x0, x0 + 3*h, h); % 4×m
    rkTime = toc;
    if DEBUG
        timeStats(1, :) = rkTime;
    end
    Y(:,1:4) = Y_boot;

    % Precompute f values for bootstrapped points
    F = zeros(m, N);
    for i = 1:4
        F(:,i) = f(X(i), Y(:,i));
    end

    % Main loop
    total_iterations = N - 4;
    last_reported = 0;
    report_interval = 5; % Report every 5%
    tic;
    for n = 4:(N-1)
        % Predictor (Adams-Bashforth)
        f_hist = F(:, n-3:n);                   % f_{n-3} to f_n
        y_hist_AB = Y(:, n-3:n);                % y_{n-3} to y_n
        y_pred = adamsBashforth(y_hist_AB, h, f_hist);

        % Evaluate f at predicted point
        f_np1_pred = f(X(n+1), y_pred);

        % Corrector (Adams-Moulton)
        y_hist_AM = Y(:, n-2:n);                % y_{n-2} to y_n
        f_hist_AM = F(:, n-2:n);                % f_{n-2} to f_n
        y_corr = adamsMoulton(y_hist_AM, h, f_hist_AM, f_np1_pred);

        % Store corrected value
        Y(:,n+1) = y_corr;
        F(:,n+1) = f(X(n+1), y_corr);
        % Update progress every 5%
        current_iter = n - 3;
        progress = current_iter / total_iterations * 100;
        
        if progress - last_reported >= report_interval || n == N-1
            fprintf('ABAM Progress: %.1f%% complete\n', progress);
            last_reported = progress;
        end

    end
    
    fprintf('\n'); % New line when done

    ABAM_time = toc;
    if DEBUG
        timeStats(2, :) = ABAM_time;
        timeStats(3, :) = ABAM_time/(N-4);
    end
end
