function binary = RGB2BIN(I_rgb, index)
    [H, W, ~] = size(I_rgb);
    binary = zeros(H, W);
    
    % Convert RGB to grayscale using the specified method
    for i = 1:H
        for j = 1:W
            if index == 1
                gray_val = (I_rgb(i,j,1) + I_rgb(i,j,2) + I_rgb(i,j,3)) / 3;
            elseif index == 2
                gray_val = I_rgb(i,j,1); % Red channel
            elseif index == 3
                gray_val = I_rgb(i,j,2); % Green channel
            elseif index == 4
                gray_val = I_rgb(i,j,3); % Blue channel
            elseif index == 5
                gray_val = I_rgb(i,j,1)*0.2 + I_rgb(i,j,2)*0.3 + I_rgb(i,j,3)*0.5;
            else
                error('Invalid index for RGB2Binary');
            end
            
            % Apply fixed threshold (128)
            if gray_val > 128
                binary(i,j) = 255;
            else
                binary(i,j) = 0;
            end
        end
    end
    
    binary = uint8(binary);
    if ndims(I_rgb) < 3 || size(I_rgb, 3) == 1
        gray = double(I_rgb);
    else
        rgb = double(I_rgb);
        R = rgb(:, :, 1);
        G = rgb(:, :, 2);
        B = rgb(:, :, 3);
        switch index
            case 1
                gray = (R + G + B) / 3;
            case 2
                gray = R;
            case 3
                gray = G;
            case 4
                gray = B;
            case 5
                gray = R * 0.2 + G * 0.3 + B * 0.5;
            otherwise
                error('Invalid index for RGB2Binary');
        end
    end
    binary = uint8(gray > 128) * 255;
end