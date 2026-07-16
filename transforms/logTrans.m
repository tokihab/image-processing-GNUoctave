function logImage = logTrans(grayImage)
    c = 255 / log(1 + double(max(grayImage(:))));
    logImage = c * log(1 + double(grayImage));
    logImage = uint8(logImage);
end