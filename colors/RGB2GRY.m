function gray = RGB2GRY(I_rgb, index)
    [H, W, ~] = size(I_rgb);
    gray = zeros(H, W);
    gray = double(gray);

    for i = 1:H
        for j = 1:W
            if index == 1
                gray(i,j) = (I_rgb(i,j,1) + I_rgb(i,j,2) + I_rgb(i,j,3)) / 3;
            elseif index == 2
                gray(i,j) = I_rgb(i,j,1);
            elseif index == 3
                gray(i,j) = I_rgb(i,j,2);
            elseif index == 4
                gray(i,j) = I_rgb(i,j,3);
            elseif index == 5
                gray(i,j) = I_rgb(i,j,1)*0.2 + I_rgb(i,j,2)*0.3 + I_rgb(i,j,3)*0.5;
            end
        end
    end

    gray = uint8(gray);
    
end