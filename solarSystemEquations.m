function dydx = solarSystemEquations(init_pos_vec, init_vel_vec)
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

% Error check on inputs
if ~isequal(size(init_pos_vec), [36, 1]) || ~isreal(init_pos_vec)
 error('Initial position vector arguments must real and contained within a 36x1 column vector') 
end
if ~isequal(size(init_vel_vec), [36, 1]) || ~isreal(init_vel_vec)
 error('Initial velocity vector arguments must real and contained within a 36x1 column vector') 
end


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

vec = [init_pos_vec; init_vel_vec]; % Combine input arguments to one vector

dydx = Equations*vec;