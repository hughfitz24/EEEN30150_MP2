function dydx = solarSystemEquations(~, initial_vectors)
% dydx = solarSystemEquations(init_pos_vec, init_vel_vec)
% Calculates velocity and acceleration values for 12 bodies of interest in
% the Solar System
%
% Inputs
% initial_vectors (72x1 column vector) equals the initial position and
% velocity vectors in the X Y Z directions for the 12 bodies in the solar system
%
% Outputs
% dydx (72x1 column vector) equals the time derivative velocity and acceleration 
% values in the X Y Z directions for each of the 12 bodies

% Version 1: created 20/05/2025. Author: David Cronin

% Error check on input
if ~isequal(size(initial_vectors), [72, 1]) || ~isreal(initial_vectors)
 error('Initial state vector arguments must real and contained within a 72x1 column vector') 
end
pos_vec = initial_vectors(1:36); % separating position and velocity vectors
vel_vec = initial_vectors(37:72);
positions = reshape(pos_vec, [3, 12]); % reshaping position vectors
num = Numerator;                % Compute numerators and denominators 
denom = Denominator(positions); % for equations
acc_vec = zeros(3, 12); % initialise matrix
for i = 1:12
    ri = positions(:, i);
    acc_1 = zeros(3, 1); % (G*m_j) / ||r_j - r_i||^3 * r_j
    acc_2 = 0;           % (G*m_j) / ||r_j - r_i||^3 * r_i
    for j = 1:12
        if i == j
            continue
        end
        rj = positions(:, j);
        coeff = num(j) / denom(j, i); % (G*m_j) / ||r_j - r_i||^3
        acc_1 = acc_1 + coeff * rj;
        acc_2 = acc_2 + coeff;
    end
    acc_vec(:, i) = acc_1 - acc_2 * ri; 
end
dydx = [vel_vec; acc_vec(:)];
end