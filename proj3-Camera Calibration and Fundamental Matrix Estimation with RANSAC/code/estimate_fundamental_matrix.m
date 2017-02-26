% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

% Separate out the u values from the matrix Points_a
u = Points_a(:,1);
% Separate out the v values from the matrix Points_a
v = Points_a(:,2);
% Separate out the u' values from the matrix Points_b
u1 = Points_b(:,1);
% Separate out the v' values from the matrix Points_b
v1 = Points_b(:,2);
% Create a Matrix of ones (o) with the same length as that of the u vector
o = ones(size(u));
% Create a Matrix of ones (o) with the same length as that of the u' vector
o1 = ones(size(u1));

A = [u.*u1 v.*u1 u1 u.*v1 v.*v1 v1 u v o];

[~, ~, V] = svd(A);

F = reshape(V(:,9), 3, 3)';

[U, D, V] = svd(F);
F_matrix = U * diag([D(1,1) D(2,2) 0]) * V';



end