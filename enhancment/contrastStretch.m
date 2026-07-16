function stretchedImage = contrastStretch(grayImage)
    min_val = double(min(grayImage(:)));
    max_val = double(max(grayImage(:)));
    
    % Handle division by zero for flat images
    if max_val == min_val
        stretchedImage = grayImage;  % Return original if no contrast
    else
        stretchedImage = (double(grayImage) - min_val) * (255 / (max_val - min_val));
    end
    
    stretchedImage = uint8(stretchedImage);
end
