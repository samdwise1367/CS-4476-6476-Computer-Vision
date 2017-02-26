% Camera Center Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% Returns the camera center matrix for a given projection matrix

% 'M' is the 3x4 projection matrix
% 'Center' is the 1x3 matrix of camera center location in world coordinates

function [ Center ] = compute_camera_center( M )

Q = M(:, 1:3);
m4 = M(:, 4);
Center = -inv(Q) * m4;
%In the visualization you will see that this camera location is clearly
%incorrect, placing it in the center of the room where it would not see all
%of the points.

end

