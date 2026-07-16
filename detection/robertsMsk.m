function edges = robertsMsk(img)
    [H, W, L] = size(img);
    edges = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Roberts cross operator (2x2 kernel)
    kernel = [1 0; 0 -1]; % Adjust for other diagonal if needed
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+1, j:j+1, c);
                conv_val = sum(sum(window .* kernel));
                edges(i,j,c) = abs(conv_val);
            end
        end
    end
    
    % Normalize and convert to uint8
    edges = uint8((edges / max(edges(:))) * 255);
end