function binary = GRY2BIN(I_gray, index)
    [H, W] = size(I_gray);
    binary = zeros(H, W);
    I_gray = double(I_gray); % Convert to double for calculations
    
    % Determine threshold based on index
    if index == 1
        threshold = 128;
    elseif index == 2
        threshold = mean(I_gray(:));
    elseif index == 3
        threshold = median(I_gray(:));
    else
        error('Invalid index for Gray2Binary');
    end
    
    % Apply threshold
    for i = 1:H
        for j = 1:W
            if I_gray(i,j) > threshold
                binary(i,j) = 255;
            else
                binary(i,j) = 0;
            end
        end
    end
    
    binary = uint8(binary);
end