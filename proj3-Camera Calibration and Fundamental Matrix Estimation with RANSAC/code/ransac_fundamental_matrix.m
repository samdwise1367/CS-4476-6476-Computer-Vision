% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)

match_size = size(matches_a);
sample_size = 8;
numOfIter = 1000;
best_InlierNum = 0;
for i = 1 : numOfIter
    % Randomly select 8 points
    rand_sample = randsample(match_size(1), sample_size);
    % Estimate the fundamental matrix 
    F = estimate_fundamental_matrix(matches_a(rand_sample, :),  matches_b(rand_sample, :));
    x1 = matches_a;
    x2 = matches_b;
    x2tFx1 = zeros(1,length(x1));
	for n = 1:length(x1)
	    x2tFx1(n) = [x2(n,:) 1] * F * [x1(n,:) 1]';
    end
    o = ones(match_size(1), 1);
	Fx1 = F * [x1 o]';
	Ftx2 = F * [x2 o]';
    
    % Compute the Sampson distance between all sample points with the fitting epipolar line 
    % A better error measurement the Sampson distance that is a first-order approximation
    % to the geometric error. 
  
	d =  x2tFx1.^2 ./ ...
	    (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
	t = 0.01;
    % Compute the inliers with distances smaller than the threshold
	inlierIdx = find(abs(d) < t);     % Indices of inlying points
    inlierNum = length(inlierIdx);
    
    % Update the number of inliers and fitting model if better model is found     
    if (inlierNum > best_InlierNum) 
        best_InlierNum = inlierNum;
        best_InlierIdx = inlierIdx;
        best_F = F;
    end
	
end
inliers_a = matches_a(best_InlierIdx, :);
inliers_b = matches_b(best_InlierIdx, :);
Best_Fmatrix = best_F;
disp(best_InlierNum);

end

