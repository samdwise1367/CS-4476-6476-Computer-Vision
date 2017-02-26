% Starter code prepared by James Hays for CS 4476, Georgia Tech
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [features, bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params, hard_mining)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')

% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.

% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression. Err
% on the side of having a low confidence threshold (even less than zero) to
% achieve high enough recall.

test_scenes = dir( fullfile( test_scn_path, '*.jpg' ));

bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);
temp_size = feature_params.template_size;
cell_size = feature_params.hog_cell_size;
threshold = 0.6; %1.1
scale_factor = 0.9;

for i = 1 : length(test_scenes)
      
    fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( test_scn_path, test_scenes(i).name ));
    image_size = size(img);
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    
    cur_bboxes = zeros(0, 4);
    cur_confidences = zeros(0, 1);
    cur_image_ids = cell(0, 1);
    features = [];
    scale = 1;
    
    while (size(img, 1)  > temp_size || size(img, 2) > temp_size)
        hog = vl_hog(img, cell_size);
        for y = 1 : (size(hog, 1) - temp_size/cell_size)
            for x = 1 : (size(hog, 2) - temp_size/cell_size)
                cur_feat = hog(y : (y + temp_size/cell_size - 1), x : (x + temp_size/cell_size - 1), :);
                cur_feat = reshape(cur_feat, 1, (temp_size/cell_size)^2 * 31, 1);
                conf = cur_feat * w + b;
                if (conf > threshold)
                    x_min = (x - 1) * cell_size;
                    y_min = (y - 1) * cell_size;
                    x_max = x_min + temp_size;
                    y_max = y_min + temp_size;
                    box = round([x_min, y_min, x_max, y_max] * scale);
                    cur_bboxes      = [cur_bboxes;      box];
                    cur_confidences = [cur_confidences; conf];
                    cur_image_ids   = [cur_image_ids;   test_scenes(i).name];
                    features = [features; cur_feat];
                end
            end
        end
        img = imresize(img, scale_factor);
        scale = scale / scale_factor;
    end
    %non_max_supr_bbox can actually get somewhat slow with thousands of
    %initial detections. You could pre-filter the detections by confidence,
    %e.g. a detection with confidence -1.1 will probably never be
    %meaningful. You probably _don't_ want to threshold at 0.0, though. You
    %can get higher recall with a lower threshold. You don't need to modify
    %anything in non_max_supr_bbox, but you can.
    if ~hard_mining
        [is_maximum] = non_max_supr_bbox(cur_bboxes, cur_confidences, image_size);

        cur_confidences = cur_confidences(is_maximum,:);
        cur_bboxes      = cur_bboxes(     is_maximum,:);
        cur_image_ids   = cur_image_ids(  is_maximum,:);
    end
        bboxes      = [bboxes;      cur_bboxes];
        confidences = [confidences; cur_confidences];
        image_ids   = [image_ids;   cur_image_ids];
   
end



