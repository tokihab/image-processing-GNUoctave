function detected = PtsDetect(img)
    [H, W, L] = size(img);
    detected = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Laplacian kernel (point detection)
    kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                conv_val = sum(sum(window .* kernel));
                detected(i,j,c) = abs(conv_val); % Absolute value for edge strength
            end
        end
    end
    
    % Normalize and convert to uint8
    detected = uint8((detected / max(detected(:))) * 255);
end