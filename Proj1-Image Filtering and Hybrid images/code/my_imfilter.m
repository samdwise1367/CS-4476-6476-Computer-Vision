function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter().

% The function works for filters of any width and height combination.
filter_size = size(filter);
image_size = size(image);

% The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds.
% Handling this issue by mirroring the image content over the boundaries.
top_border = floor(filter_size(1)/2);
side_border = floor(filter_size(2)/2);
resized = padarray(image, [top_border, side_border], 'symmetric');

% Extract the output image and the resized(padded) input image 
% into the individual red, green, and blue color channels.
% Note the output image is initialized as the input image.
filtered_red = image(:, :, 1);
filtered_green = image(:, :, 2);
filtered_blue = image(:, :, 3);

resized_red = resized(:, :, 1);
resized_green = resized(:, :, 2);
resized_blue = resized(:, :, 3);

% Iterate through the output image
% and replace each pixel with the weighted sum of its neighbors.
for m = 1 : image_size(1)
    for n = 1 : image_size(2)
        
        sum_red = 0;
        sum_green = 0;
        sum_blue = 0;
    
	% Calculate the convolution of the filter
	% and resized input image by piecewise multiplication.
        for p = 1 : filter_size(1)
            for q = 1 : filter_size(2)
                sum_red = sum_red + filter(p,q) * resized_red(m + p - 1, n + q - 1);
                sum_green = sum_green + filter(p,q) * resized_green(m + p - 1, n + q - 1);
                sum_blue = sum_blue + filter(p,q) * resized_blue(m + p - 1, n + q - 1);
            end
        end

	% Apply the result to each color channels of the output image
        filtered_red(m, n) = sum_red;
        filtered_green(m, n) = sum_green;
        filtered_blue(m, n) = sum_blue;
        
    end
end

% Combine separate color channels into one RGB output image.
output = cat(3, filtered_red, filtered_green, filtered_blue);

end