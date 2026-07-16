function result = correlation(img, kernel)
    [H, W, L] = size(img);
    [kH, kW] = size(kernel);
    pad = floor([kH, kW]/2);
    padded = padarray(double(img), pad, 'replicate');
    result = zeros(H, W, L);
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+kH-1, j:j+kW-1, c);
                result(i,j,c) = sum(sum(window .* kernel));
            end
        end
    end
    
    % Normalize and convert to uint8
    result = uint8(mat2gray(result) * 255);
end