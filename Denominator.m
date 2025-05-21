function denom = Denominator(init_pos_vec)
% denom = Denominator(init_pos_vec)
% Calculates ||r_j - r_i||^3 for all bodies relative to all other bodies
%
% Inputs
% init_pos_vec (36x1 column vector) equals the initial X Y Z velocity coordinates 
% of each of the 12 bodies in the Solar System animation
%
% Outputs
% denom (12x12 square matrix) equals a matrix storing the cubed Euclidean distance 
% between each of the bodies 

% Version 1: created 20/05/2025. Author: David Cronin

% Error check on inputs
if ~isequal(size(init_pos_vec), [36, 1]) || ~isreal(B) || any(~isfinite(B))
 error('Initial position vector arguments must real and contained within a 36x1 column vector') 
end

init_pos_mat = reshape(init_pos_vec, 3, 12)'; % 

bodies = size(init_pos_mat, 1);

rel_dist = zeros(bodies);

for i = 1:bodies
    for j = i+1:bodies
        rel_coord = init_pos_vec(i,:) - init_pos_vec(j,:);
        rel_dist(i, j) = norm(rel_coord);
    end
end

rel_dist_symmetrical = rel_dist + rel_dist';
denom = rel_dist_symmetrical.^3;