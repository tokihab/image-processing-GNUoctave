function stretchedImage = contrastStretch(grayImage)
    min_val = double(min(grayImage(:)));
    max_val = double(max(grayImage(:)));
    stretchedImage = (double(grayImage) - min_val) * (255 / (max_val - min_val));
    stretchedImage = uint8(stretchedImage);
end