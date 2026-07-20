function filtered = BWF(I, D0, n, index)
    [H, W, L] = size(I);
    [X, Y] = meshgrid(1:W, 1:H);
    D = sqrt((X - W / 2) .^ 2 + (Y - H / 2) .^ 2);
    filter = 1 ./ (1 + (D ./ D0) .^ (2 * n));

    if index ~= 0
        filter = 1 - filter;
    end

    filtered = zeros(H, W, L);
    for c = 1:L
        fi = fftshift(fft2(double(I(:, :, c))));
        filtered(:, :, c) = mat2gray(real(ifft2(ifftshift(fi .* filter))));
    end

    if L == 1
        filtered = filtered(:, :, 1);
    end
end