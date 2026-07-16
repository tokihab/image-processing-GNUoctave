function filtered = midpointFltr(img)
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    padded = padarray(double(img), [1 1], 'replicate');
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = padded(i:i+2, j:j+2, c);
                filtered(i,j,c) = (max(window(:)) + min(window(:))) / 2;
            end
        end
    end
end