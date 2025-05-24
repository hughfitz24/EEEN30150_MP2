%% ----------------------------------
%% main.m
%% ----------------------------------
% The main file of the simulation, applying an Adams-Bashforth
% Adams-Moulton predictor-corrector system to a system of ODEs describing
% the position and velocity of 12 bodies of the solar system. 

% The execution path of this main file can be in one of three modes:
% Mode 1. Simulation Mode: 
%           Runs the ODE solver on the system for the
%           requested time period; defaults at 2 Neptunian years. Plots the
%           system using the animation files, generating videos of the entire
%           system, as well as zoomed in views on planets with orbiting moons.

% Mode 2. Verification Mode:
%           Runs the ODE solver on the system, does not animate but instead  
%           passes the data on to a verification function, which verifiies
%           if the simulated data satisfies Kepler's Laws. 

% Mode 3. Debug Mode:
%           Runs the ODE solver on the systema and animates, but  
%           also prints messages regarding execution time, number of
%           iterations etc for all numerical methods and animation steps.

% Written by Hugh Fitzpatrick, 22341351

% Constants definition
neptunianYear = 60190; % 1 Neptunian year in Earth days
stepSize = 0.448; % Step Size, justified in report 

modes = {
   1, 'Simulation Mode';
   2, 'Verification Mode';
   3, 'Debug Mode'
};

clc;
fprintf('\n========================================================================\n');
fprintf('\n        EEEN30150: Modelling and Simulation\n');
fprintf('        Minor Project 2: Simulation of 12 Bodies of Solar System\n');
fprintf('        Team 2: Hugh Fitzpatrick, Liam Whelan, & David Cronin\n');
fprintf('\n========================================================================\n');

fprintf('\n---------------------- Execution Modes ----------------------\n');
fprintf(' Mode 1: Simulation Mode\n');
fprintf('   - Runs the ODE solver on the system for the\n');
fprintf('     requested time period (default: 2 Neptunian years).\n');
fprintf('   - Generates animated plots of the entire system,\n');
fprintf('     including zoomed-in views on planets with orbiting moons.\n\n');

fprintf(' Mode 2: Verification Mode\n');
fprintf('   - Runs the ODE solver but skips animation.\n');
fprintf('   - Passes data to a verification function using Keplers \n');
fprintf('     Laws to evaluate model accuracy.\n\n');

fprintf(' Mode 3: Debug Mode\n');
fprintf('   - Runs the ODE solver without animation or verification.\n');
fprintf('   - Prints detailed execution stats: time, iterations,\n');
fprintf('     numerical method diagnostics, and animation step info.\n');
fprintf('-------------------------------------------------------------\n\n');

mode = input('Please enter the requested mode (1–3): ');


valid_modes = [modes{:,1}];
if ismember(mode, valid_modes)
    modeName = modes{mode, 2}; 
    fprintf('You have selected Mode %d: %s\n', mode, modeName);
else
    error('Invalid mode selected. Please enter 1, 2, or 3.');
end

if mode == 3
    DEBUG = true;
else
    DEBUG = false;
end



%% ----------------------------------
%% Step 1: System Setup
%% ----------------------------------
% Read initial condition data from .txt files, set up system of equations
% for iteration with the ODE solver.

initial_positions = readmatrix('initial_positions.txt');
initial_velocities = readmatrix('initial_velocities.txt');

numNeptunianYears = input("Please enter the number of Neptunian Years to simulate (minimum of 2): ");

if numNeptunianYears < 2
    error('Number of Neptunian years to simulate must equal or exceed 2.')
end

% Define initial state
y0 = [initial_positions; initial_velocities];
x0 = 0;        % initial time in days i.e. start from the initial date, the 5th of May 2025
xf = numNeptunianYears*neptunianYear;
h = stepSize;

% Define the system from the solarSystemEquations.m file
f = @(x, y) solarSystemEquations(x, y); 

%% ----------------------------------
%% Step 2: Complete Simulation
%% ----------------------------------

fprintf("Simulating %d Neptunian Years of the solar system, beginning on Earth date 5th of May 2025, 00:00:00... \n", numNeptunianYears);
tic;
[X, Y, timeStats] = ABAM_ODESolver(f, y0, x0, xf, h, DEBUG);
ODESolveTime = toc;
fprintf('\n Simulation completed for %d Earth days.\n\n', xf);



%% ----------------------------------
%% Step 3: Mode Specific Functionality
%% ----------------------------------

switch mode
    case 1
        % Animation goes here
        disp('---------- Animation ---------')
        animationMode = input('Enter animation mode (1 = wide view, 2 = View of inner planets): ');
        if animationMode ~= 1 && mode ~= 2
            error('Invalid mode selected.')
        end
        disp('Generating animation...')
        SolarSystemAnimate(Y, animationMode);
        
    case 2
        % Verification logic goes here
        disp('---------- Verification ---------')
        verifyKeplers(X, Y);

    case 3
        % Debug info goes here
        % Ensure debug mode was entered
        if ~DEBUG
            error('DEBUG mode not entered.')
        end
        disp('---------- Runtime Statistics ---------')
        fprintf('Step Size = %d\n', stepSize)
        fprintf('Total Execution time: %.6f sec\n', ODESolveTime);
        fprintf('Num of iterations: %d \n', length(X));
        fprintf('Numerical Methods Breakdown: \n')
        fprintf('4th Order Runge Kutta Startup:\n\tTotal execution time: %.6f s \n\tAvg time per iteration: %.6f s \n', timeStats(1,:), timeStats(1,:)/4);
        fprintf('Adams-Bashforth Adams-Moulton Predictor Corrector:\n\tTotal execution time: %.6f s \n\tAvg time per iteration: %.6f s \n', timeStats(2, :), timeStats(3, :));
    otherwise
        % Should never enter this mode. 
        error("Invalid mode selected")
end
fprintf('\n========================================================================\n');