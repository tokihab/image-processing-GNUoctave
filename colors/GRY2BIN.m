function binary = GRY2BIN(I_gray, index)
    % Convert grayscale to binary using vectorized operations
    
    I_gray = double(I_gray);
    
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
    
    % Apply threshold using vectorized operations
    binary = uint8(I_gray > threshold) * 255;
end
