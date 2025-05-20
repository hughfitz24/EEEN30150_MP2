# EEEN30150 MP2

This repository contains the Matlab code used to complete the Minor Project 2 of the Modelling and Simulation EEEN30150 module.

## Simulation Process

The Matlab solution process employed makes use of the Adams-Bashforth-Moulton algorithm for the solution of a system of ODES. 
This solution process is implemented in the `ABAM_ODESolver.m` m-file, which follows the solution process detailed in the lecture notes.
The Runge-Kutta algorithm is used to solve for the initial 4 steps, with all further steps being found using the Adams-Bashforth predictive method, and finalised using Adams-Moulton as the corrective method. 

## Function m-Files

The m-files written to implement the algorithms detailed above are as follows:

1. `adamsMoulton.m` 
2. `adamsBashforth.m`
3. `rungeKutta.m`

The Adams-Bashforth and Adams-Moulton methods are both implemented as single step evaluations of the algorithms i.e. calling the relevant functions will evaluate 1 step of the algorithm.
The iterative solution is then implemented in the ABAM_ODESolver method, which contains the iterative logic.




david cwonin




