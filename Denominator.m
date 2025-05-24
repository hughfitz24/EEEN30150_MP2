function denom = Denominator(positions)
% denom = Denominator(init_pos_vec)
% Calculates ||r_j - r_i||^3 for all bodies relative to all other bodies
%
% Inputs
% positions (3x12 matrix) equals the initial X Y Z position coordinates of each 
% of the 12 bodies in the Solar System animation
%
% Outputs
% denom (12x12 square matrix) equals a matrix storing the cubed Euclidean distance 
% between each of the bodies 
% Version 1: created 20/05/2025. Author: David Cronin

bodies = size(positions, 2); % Calculate number of bodies in system
 rel_dist = zeros(bodies, bodies); % Initialize 12x12 matrix
for i = 1:bodies
    for j = i+1:bodies
        rel_coord = positions(:,i) - positions(:,j); % Relative coordinates
        rel_dist(i, j) = norm(rel_coord); % Euclidean distance
    end
end
rel_dist_symmetrical = rel_dist + rel_dist'; % Form symmetrical 12x12 matrix

denom = rel_dist_symmetrical.^3; % AU^3