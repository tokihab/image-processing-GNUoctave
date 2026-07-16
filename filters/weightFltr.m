function filtered = weightFltr(img)
    % Apply 3x3 weighted filter using convolution for speed
    
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    
    % Define 3x3 weight kernel (Gaussian-like)
    kernel = [1 2 1; 2 4 2; 1 2 1] / 16;
    
    % Apply to each channel using conv2
    for c = 1:L
        filtered(:,:,c) = conv2(double(img(:,:,c)), kernel, 'same');
    end
    
    filtered = uint8(filtered);
end
