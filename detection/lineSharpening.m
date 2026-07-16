function sharpened = lineSharpening(img, direction)
    [H, W, L] = size(img);
    sharpened = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Use line detection kernel (same as lineDetection)
    switch direction
        case 'H'
            kernel = [-1 -1 -1; 2 2 2; -1 -1 -1];
        case 'V'
            kernel = [-1 2 -1; -1 2 -1; -1 2 -1];
        case 'DL'
            kernel = [-1 -1 2; -1 2 -1; 2 -1 -1];
        case 'DR'
            kernel = [2 -1 -1; -1 2 -1; -1 -1 2];
    end
    
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