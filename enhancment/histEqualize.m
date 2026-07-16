function equalizedImage = histEqualize(grayImage)
    % Compute histogram
    hist = HIST(grayImage);
    
    % Compute CDF
    cdf = cumsum(hist) / numel(grayImage);
    
    % Map intensities
    equalizedImage = uint8(255 * cdf(grayImage + 1)); 
end