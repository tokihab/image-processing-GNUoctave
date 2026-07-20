function equalizedImage = histEqualize(grayImage)
    % Compute histogram
    hist = HIST(grayImage);
    
    % Compute CDF
    cdf = cumsum(hist) / numel(grayImage);
    
    % Map intensities
    equalizedImage = uint8(255 * cdf(grayImage + 1)); 
end
function equalizedImage = histEqualize(grayImage)
    if ndims(grayImage) == 3 && size(grayImage, 3) == 3
        grayImage = RGB2GRY(grayImage, 1);
    end

    gray = uint8(grayImage);
    histarr = accumarray(double(gray(:)) + 1, 1, [256, 1]);
    cdf = cumsum(histarr);
    cdf = cdf / cdf(end);

    equalizedImage = uint8(255 * reshape(cdf(double(gray) + 1), size(gray)));
end