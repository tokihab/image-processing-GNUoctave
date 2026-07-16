function filtered = medianFltr(img)
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    padded = padarray(double(img), [1 1], 'replicate');
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                window = reshape(padded(i:i+2, j:j+2, c), 9, 1);
                sorted = sort(window);
                filtered(i,j,c) = sorted(5); % Middle element for 3x3
            end
        end
    end
end