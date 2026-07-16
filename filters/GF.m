function filtered = GF(I, D0, index)
    [H, W, L] = size(I);
    filter = zeros(H, W, L);
    
    % Create Gaussian filter
    for j = 1:H
        for k = 1:W
            D = sqrt((j - H/2)^2 + (k - W/2)^2); % Distance from center
            gaussian = exp(-(D^2) / (2 * D0^2)); % Gaussian LPF formula
            filter(j, k, :) = gaussian;
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