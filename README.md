# EEEN30150 MP2

This repository contains the Matlab code used to complete the Minor Project 2 of the Modelling and Simulation EEEN30150 module.

## Simulation Process

The Matlab solution process employed makes use of the Adams-Bashforth-Moulton algorithm for the solution of a system of ODES. 
This solution process is implemented in the `ABAM_ODESolver.m` m-file, which follows the solution process detailed in the lecture notes.
The Runge-Kutta algorithm is used to solve for the initial 4 steps, with all further steps being found using the Adams-Bashforth predictive method, and finalised using Adams-Moulton as the corrective method. 

### Function m-Files

The m-files written to implement the algorithms detailed above are as follows:

1. `adamsMoulton.m` 
2. `adamsBashforth.m`
3. `rungeKutta.m`

The Adams-Bashforth and Adams-Moulton methods are both implemented as single step evaluations of the algorithms i.e. calling the relevant functions will evaluate 1 step of the algorithm.
The iterative solution is then implemented into the ABAM_ODESolver method, which contains the iterative logic and serves as the entry point for using the Adams-Bashforth Adams-Moulton PC ODE solver.

## Convergence Analysis 

A convergence analysis can be completed using the `Convergence.m` function m-file. This will compare the simulated data for any of the 12 planets with ephemeris data passed as input to the function. Testing used ephemeris data from the JPL Horizons database. This file completes an analysis of RMS error rate between the simulated and ephemeris data, as well as determining the simulation computation time. This data is then used to determine the optimal step size for the numerical simulation.

## Animation

The solarSystemAnimate.m function animates a set of position data for the 12 bodies passed as input. It can generate one of two animations:

1. A wide view of the entire solar system, showing outer bodies like Neptune and Uranus.
2. A view of the inner planets i.e. Mars, Earth, Mercury, etc.






