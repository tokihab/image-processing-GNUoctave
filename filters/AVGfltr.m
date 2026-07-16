function filteredImage = AVGfltr(grayImage)
    [rows, cols] = size(grayImage);
    filteredImage = zeros(rows, cols, 'uint8');
    
    % Manually pad the image (replicate borders)
    paddedImage = padarray(grayImage, [1 1], 'replicate');
    
    % Apply 3x3 kernel
    kernel = ones(3,3)/9;
    for i = 1:rows
        for j = 1:cols
            patch = double(paddedImage(i:i+2, j:j+2));
            filteredImage(i,j) = sum(patch(:) .* kernel(:));
        end
    end
end