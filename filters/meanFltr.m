function filtered = meanFltr(img)
    % Apply 3x3 mean filter using convolution for speed
    % This is much faster than nested loops
    
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    
    % Define 3x3 mean kernel
    kernel = ones(3, 3) / 9;
    
    % Apply to each channel
    for c = 1:L
        % Use conv2 for fast convolution
        filtered(:,:,c) = conv2(double(img(:,:,c)), kernel, 'same');
    end
    
    filtered = uint8(filtered);
end
