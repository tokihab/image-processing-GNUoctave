function adjusted = adjustBrightness(img, delta)
    adjusted = uint8(min(max(double(img) + delta, 0), 255));
end