function dydx = solarSystemEquations(~, state)
% dydx = solarSystemEquations(init_pos_vec, init_vel_vec)
% Calculates velocity and acceleration values for 12 bodies of interest in
% the Solar System
%
% Inputs
% init_pos_vec (36x1 column vector) equals the initial X Y Z position coordinates
% of each of the 12 bodies in the Solar System animation
% init_vel_vec (36x1 column vector) equals the initial X Y Z velocity coordinates 
% of each of the 12 bodies in the Solar System animation
%
% Outputs
% dydx (72x1 column vector) equals the time derivative velocity and
% acceleration values for each of the 12 bodies

% Version 1: created 20/05/2025. Author: David Cronin

init_pos_vec = state(1:36);
init_vel_vec = state(37:72);

num = Numerator;                      % Compute numerators and denominators 
denom = Denominator(init_pos_vec); % for equations

Equations = zeros(72, 72); % Initialise equation matrix

% Fill Main Diagonal (rows 37:72) 
for i = 1:12
    others = [1:i-1, i+1:12];
    sum_val = sum(num(others) ./ denom(others, i));
    
    row_idx = 37 + (i-1)*3; % Index rows and columns
    col_idx = 1 + (i-1)*3;

    % Multiply value by identity matrix 
    Equations(row_idx:row_idx+2, col_idx:col_idx+2) = -sum_val .* eye(3);
end

% Fill Off-Diagonal Interactions (excluding the main diagonal)
for colBody = 1:12
    col_idx = 1 + (colBody-1)*3;
    
    for rowBody = 1:12
        if rowBody == colBody
            continue  % Skip diagonal
        end
        
        row_idx = 37 + (rowBody-1)*3;
        
        Equations(row_idx:row_idx+2, col_idx:col_idx+2) = ...
            (num(colBody) / denom(colBody, rowBody)) * eye(3);
    end
end

% Fill Identity Submatrix (Top-Right 36x36 diagonal)
for i = 1:36
    Equations(i, 36 + i) = 1;
end

vec = [init_pos_vec; init_vel_vec];
dydx = Equations*vec;

function num = Numerator 
masses = [1.9984E30;    % Sun
          3.301E23;     % Mercury
          4.8673E24;    % Venus
          5.9722E24;    % Earth
          7.346E22;     % Luna
          6.4169E23;    % Mars
          1.89813E27;   % Jupiter
          1.482E23;     % Ganymede
          5.6832E26;    % Saturn
          1.346E23;     % Titan
          8.6611E25;    % Uranus
          1.02409E26];  % Neptune

G = 6.6743E-11; % m^3 kg^-1 s^-2
AU = 149597870100; % m
day = 86400; % s

G_scaled = G*day^2*AU^-3; % AU^3 kg^-1 day^-2

num = G_scaled.*masses;

function denom = Denominator(init_pos_vec)
% denom = Denominator(init_pos_vec)
% Calculates ||r_j - r_i||^3 for all bodies relative to all other bodies
%
% Inputs
% init_pos_vec (36x1 column vector) equals the initial X Y Z position coordinates 
% of each of the 12 bodies in the Solar System animation
%
% Outputs
% denom (12x12 square matrix) equals a matrix storing the cubed Euclidean distance 
% between each of the bodies 

% Version 1: created 20/05/2025. Author: David Cronin

init_pos_mat = reshape(init_pos_vec, 3, 12)'; % Reshape vector into 12x3 matrix

bodies = size(init_pos_mat, 1); % Calculate number of bodies in system

rel_dist = zeros(bodies); % Initialise matrix

for i = 1:bodies
    for j = i+1:bodies
        rel_coord = init_pos_mat(i,:) - init_pos_mat(j,:); % Relative coordinates
        rel_dist(i, j) = norm(rel_coord); % Euclidean distance
    end
end

rel_dist_symmetrical = rel_dist + rel_dist'; % Form symmetrical 12x12 matrix
rel_dist_symmetrical(logical(eye(bodies))) = Inf; 
denom = rel_dist_symmetrical.^3;
