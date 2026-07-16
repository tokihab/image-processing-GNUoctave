function edges = sobelMsk(img, direction)
    [H, W, L] = size(img);
    edges = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Sobel kernels
    if strcmp(direction, 'horizontal')
        kernel = [-1 0 1; -2 0 2; -1 0 1];
    else % Vertical
        kernel = [-1 -2 -1; 0 0 0; 1 2 1];
    end
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                conv_val = sum(sum(window .* kernel));
                edges(i,j,c) = abs(conv_val);
            end
        end
    end
    
    % Normalize and convert to uint8
    edges = uint8((edges / max(edges(:))) * 255);
end