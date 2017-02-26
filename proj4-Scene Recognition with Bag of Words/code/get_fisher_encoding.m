function image_feats = get_fisher_encoding(image_paths)

load('stats.mat')
means = stats(:, 1:128);
means = means';
covariances = stats(:, 129:256);
covariances = covariances';
priors = stats(:, 257);

% Free params 
step_size = 5;
bin_size = 8;

image_feats = [];
for i = 1 : size(image_paths)
    img = imread(char(image_paths(i)));
    [~, SIFT_features] = vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    image_feats(i, :) = vl_fisher(single(SIFT_features), means, covariances, priors, 'Improved');
%   image_feats(i, :) = vl_fisher(single(SIFT_features), means, covariances, priors);
%   image_feats(i, :) = encoding'/norm(encoding', 2);
end

fprintf('Get fisher encoding of image features:\n');
fprintf('step size:%d\n', step_size);
fprintf('bin size:%d\n', bin_size);

end
