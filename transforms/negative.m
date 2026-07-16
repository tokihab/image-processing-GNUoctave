function neg = negative(img)
    [H, W, L] = size(img);
    neg = zeros(H, W, L, 'uint8');
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                neg(i,j,c) = 255 - img(i,j,c);
            end
        end
    end
end