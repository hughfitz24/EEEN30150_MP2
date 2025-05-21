function denom = Denominator(init_pos_vec)
% denom = Denominator(init_pos_vec)
% Calculates ||r_j - r_i||^3 for all bodies relative to all other bodies
%
% Inputs
% init_pos_vec (36x1 column vector) equals the initial X Y Z position coordinates 
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
