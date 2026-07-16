function filtered = BWF(I, D0, n, index)
    [H, W, L] = size(I);
    filter = zeros(H, W, L);
    
    % Create Butterworth filter
    for j = 1:H
        for k = 1:W
            D = sqrt((j - H/2)^2 + (k - W/2)^2); % Distance from center
            butterworth = 1 / (1 + (D / D0)^(2 * n)); % Butterworth LPF formula
            filter(j, k, :) = butterworth;
        end
    end
    
    % Invert filter for high-pass
    if index ~= 0
        filter = 1 - filter;
    end
    
    % Frequency domain processing
    fi = fft2(I);
    fi_shifted = fftshift(fi);
    filtered_shifted = fi_shifted .* filter;
    filtered = ifftshift(filtered_shifted);
    filtered = ifft2(filtered);
    filtered = mat2gray(real(filtered));
end