function sharpened = pointSharpening(img)
    [H, W, L] = size(img);
    sharpened = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Laplacian kernel
    kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                conv_val = sum(sum(window .* kernel));
                sharpened(i,j,c) = padded(i+1,j+1,c) + conv_val; % Add edge to original
            end
        end
    end
    
    % Normalize and convert to uint8
    sharpened = uint8(mat2gray(sharpened) * 255);
end