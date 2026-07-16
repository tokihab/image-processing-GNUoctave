function gray = RGB2GRY(I_rgb, index)
    % Convert RGB to grayscale using vectorized operations
    
    [H, W, ~] = size(I_rgb);
    
    % Extract channels
    R = double(I_rgb(:,:,1));
    G = double(I_rgb(:,:,2));
    B = double(I_rgb(:,:,3));
    
    switch index
        case 1
            % Average
            gray = (R + G + B) / 3;
        case 2
            % Red channel
            gray = R;
        case 3
            % Green channel
            gray = G;
        case 4
            % Blue channel
            gray = B;
        case 5
            % Weighted average
            gray = R*0.2 + G*0.3 + B*0.5;
        otherwise
            error('Invalid index for RGB2GRY');
    end
    
    gray = uint8(gray);
end
