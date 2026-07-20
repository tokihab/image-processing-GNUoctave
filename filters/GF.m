function filtered = GF(I, D0, index)
    [H, W, L] = size(I);
    [X, Y] = meshgrid(1:W, 1:H);
    D = sqrt((X - W / 2) .^ 2 + (Y - H / 2) .^ 2);
    filter = exp(-(D .^ 2) ./ (2 * D0 ^ 2));

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