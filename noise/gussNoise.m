function Nimg = gussNoise(img, v, m)
    % Add Gaussian noise to an image
    % img: input image (grayscale or RGB)
    % v: variance of the Gaussian distribution
    % m: mean of the Gaussian distribution

    [H, W, L] = size(img);
    Nimg = double(img);
    
    % Generate Gaussian noise with specified mean and variance
    noise = m + v * randn(H, W);
    
    % Add noise to image
    Nimg = Nimg + noise;
    
    % Handle RGB images - add same noise to all channels
    if L > 1
        noise3d = repmat(noise, [1, 1, L]);
        Nimg = double(img) + noise3d;
    end
    
    % Clip and normalize to [0, 255]
    mn = min(Nimg(:));
    mx = max(Nimg(:));
    if mx > mn
        Nimg = (Nimg - mn) / (mx - mn) * 255;
    else
        % Handle flat image case
        Nimg = zeros(size(Nimg));
    end
    
    Nimg = uint8(Nimg);
end
