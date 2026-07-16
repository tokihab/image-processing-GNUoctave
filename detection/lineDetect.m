function detected = lineDetect(img, direction)
    [H, W, L] = size(img);
    detected = zeros(H, W, L);
    padded = padarray(double(img), [1 1], 'replicate');
    
    % Define kernels for line detection
    switch direction
        case 'H' % Horizontal
            kernel = [-1 -1 -1; 2 2 2; -1 -1 -1];
        case 'V' % Vertical
            kernel = [-1 2 -1; -1 2 -1; -1 2 -1];
        case 'DL' % Diagonal Left
            kernel = [-1 -1 2; -1 2 -1; 2 -1 -1];
        case 'DR' % Diagonal Right
            kernel = [2 -1 -1; -1 2 -1; -1 -1 2];
        otherwise
            error('Invalid direction');
    end
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                conv_val = sum(sum(window .* kernel));
                detected(i,j,c) = abs(conv_val);
            end
        end
    end
    
    % Normalize and convert to uint8
    detected = uint8((detected / max(detected(:))) * 255);
end