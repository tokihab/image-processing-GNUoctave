function adjusted = adjustBrightness(img, delta)
    [H, W, L] = size(img);
    adjusted = zeros(H, W, L, 'uint8');
    
    for c = 1:L
        for i = 1:H
            for j = 1:W
                new_val = double(img(i,j,c)) + delta;
                % Clamp to [0, 255]
                adjusted(i,j,c) = uint8(max(0, min(255, new_val)));
            end
        end
    end
end