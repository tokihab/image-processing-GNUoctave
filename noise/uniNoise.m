function Nimg = uniNoise(img, a, b)

    img = double(img);
    [H, W, ~] = size(img);
    
    % Total pixels to modify (vectorized)
    total_pixels = round((1 / (b - a)) * W * H);
    
    % Generate all random indices upfront (avoids nested loops)
    rand_rows = ceil(rand(total_pixels, 1) * H);
    rand_cols = ceil(rand(total_pixels, 1) * W);
    
    % Generate random intensity values between 1 and 255 for each pixel
    rand_intensities = randi(255, total_pixels, 1);
    
    % Apply noise in one step using linear indexing
    linear_indices = sub2ind([H, W], rand_rows, rand_cols);
    img(linear_indices) = img(linear_indices) + rand_intensities;
    
    % Normalize and convert to uint8
    mn = min(img(:));
    mx = max(img(:));
    Nimg = uint8(((img - mn) / (mx - mn)) * 255);
    
end