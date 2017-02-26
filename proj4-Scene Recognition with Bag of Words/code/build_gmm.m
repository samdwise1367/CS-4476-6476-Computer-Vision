function stats = build_gmm(image_paths, vocab_size )

% Free params
step_size = 15;
bin_size = 8;

data = [];
for i = 1 : size(image_paths)
    img = imread(char(image_paths(i)));
    [~, SIFT_features] = vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features);
end
[means, covariances, priors] = vl_gmm(single(data), vocab_size);
stats = [means' covariances' priors];

fprintf('Building gaussian mixture model:\n');
fprintf('vocab size:%d\n', vocab_size);
fprintf('step size:%d\n', step_size);
fprintf('bin size:%d\n', bin_size);

end
