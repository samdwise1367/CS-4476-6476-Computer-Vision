function M = calculate_projection_matrix( Points_2D, Points_3D )

% set up a system of equations using the corresponding 2D and 3D points:

%                                                     [M11       [ u1
%                                                      M12         v1
%                                                      M13         .
%                                                      M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1          M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*X1 -v1*Y1 -v1*Z1          M22         .
%  .  .  .  . .  .  .  .    .     .      .          *  M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn          M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Xn -vn*Yn -vn*Zn ]        M31         .
%                                                      M32         un
%                                                      M33         vn ]

% Then you can solve this usingo SVD.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs.

X = Points_3D(:,1);
Y = Points_3D(:,2);
Z = Points_3D(:,3);

u = Points_2D(:,1);
v = Points_2D(:,2);

o = ones(size(u));
z = zeros(size(u));

A1  = [ X Y Z o z z z z -u.*X -u.*Y -u.*Z -u ];
A2 = [ z z z z X Y Z o -v.*X -v.*Y -v.*Z -v ];
A=[A1; A2];

% Compute SVD on Ax = 0
[~, ~, V] = svd(A);

x = V(:,end);
M = reshape(x,4,3)';

end