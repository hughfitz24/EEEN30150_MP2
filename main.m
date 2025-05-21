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
%           passes the data on to a verification function, which uses measured 
%           data from JPL Horizons to verify the
%           accuracy of the model. 

% Mode 3. Debug Mode:
%           Runs the ODE solver on the systema and animates, but  
%           also prints messages regarding execution time, number of
%           iterations etc for all numerical methods and animation steps.

% Written by Hugh Fitzpatrick, 22341351

modes = {
   1, 'Simulation Mode';
   2, 'Verification Mode';
   3, 'Debug Mode'
};

disp("------------- EEEN30150: Modelling and Simulation -------------")
disp("Minor Project 2: Simulation of 12 Bodies of Solar System")
disp("Team 2")
disp("------Execution Modes ------")
disp('Mode 1. Simulation Mode:')
disp('          Runs the ODE solver on the system for the')
disp('          requested time period; defaults at 2 Neptunian years.')
disp('          Plots the system using the animation files, generating videos of the entire')
disp('          system, as well as zoomed in views on planets with orbiting moons.')
disp(' ')
disp('Mode 2. Verification Mode:')
disp('          Runs the ODE solver on the system, does not animate but instead')
disp('          passes the data on to a verification function, which uses measured')
disp('          data from JPL Horizons to verify the')
disp('          accuracy of the model.')
disp(' ')
disp('Mode 3. Debug Mode:')
disp('          Runs the ODE solver on the system, does not animate or verify but')
disp('          instead prints messages regarding execution time, number of')
disp('          iterations etc for all numerical methods and animation steps.')
disp("------Select Mode ------")
mode = input("Please enter the requested mode: ");

valid_modes = [modes{:,1}];
if ismember(mode, valid_modes)
    modeName = modes{mode, 2}; 
    fprintf('You have selected Mode %d: %s\n', mode, modeName);
else
    error('Invalid mode selected. Please enter 1, 2, or 3.');
end

% Constants definition
neptunianYear = 60190; % 1 Neptunian Year in the time unit used in simulation (1 day)
numNeptunianYears = 2; % Number of Neptunian Years to Simulate
stepSize = 0.5; % Step Size, justified in report 

%% ----------------------------------
%% Step 1: System Setup
%% ----------------------------------
% Read initial condition data from .txt files, set up system of equations
% for iteration with the ODE solver.

initial_positions = readmatrix('initial_positions.txt');
initial_velocities = readmatrix('initial_velocities.txt');

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

fprintf("Simulating %d Neptunian Years of the solar system, beginning on the 5th of May 2025, simulating %d Earth days.", numNeptunianYears, xf);
tic;
[X, Y] = ABAM_ODESolver(f, y0, x0, xf, h);
ODESolveTime = toc;
fprintf('Simulation completed for %d Earth days.', xf);

%% ----------------------------------
%% Step 3: Mode Specific Functionality
%% ----------------------------------

switch mode
    case 1
        % Animation goes here
    case 2
        % Verification logic goes here
    case 3
        % Debug info comes here


    otherwise
        % Should never enter this mode. 
        error("Invalid mode selected")
end
