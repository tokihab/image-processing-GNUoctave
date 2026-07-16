function filtered = weightFltr(img)
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Define 3x3 weight kernel (Gaussian-like)
    kernel = [1 2 1; 2 4 2; 1 2 1] / 16;
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                filtered(i,j,c) = sum(sum(window .* kernel));
            end
        end
    end
end