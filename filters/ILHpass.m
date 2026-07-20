function ideal = ILHpass(I, D0, index)
    [H, W, L] = size(I);
    [X, Y] = meshgrid(1:W, 1:H);
    dis = sqrt((X - W / 2) .^ 2 + (Y - H / 2) .^ 2);
    filter = double(dis <= D0);

    if index ~= 0
        filter = 1 - filter;
    end

    ideal = zeros(H, W, L);
    for c = 1:L
        fi = fftshift(fft2(double(I(:, :, c))));
        ideal(:, :, c) = mat2gray(real(ifft2(ifftshift(fi .* filter))));
    end

    if L == 1
        ideal = ideal(:, :, 1);
    end
end
