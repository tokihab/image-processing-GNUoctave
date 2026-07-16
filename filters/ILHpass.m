function ideal = ILHpass(I, D0, index)
    
    [H, W, L] = size(I);
    
    % Create ideal low-pass or high-pass filter
    filter = zeros(H, W);
    for j = 1:H
        for k = 1:W
            dis = sqrt((j - (H/2)).^2 + (k - (W/2)).^2);
            if dis <= D0
                filter(j,k) = 1;
            end
        end
    end
    
    % Invert for high-pass if index == 1
    if index == 1
        filter = 1 - filter;
    end
    
    % Process each channel separately for RGB images
    if L == 1
        % Grayscale image
        fi = fft2(double(I));
        fi_shifted = fftshift(fi);
        filtered_shifted = fi_shifted .* filter;
        filtered = ifftshift(filtered_shifted);
        NI = ifft2(filtered);
        ideal = mat2gray(real(NI));
    else
        % RGB image - process each channel
        ideal = zeros(H, W, L);
        for c = 1:L
            fi = fft2(double(I(:,:,c)));
            fi_shifted = fftshift(fi);
            filtered_shifted = fi_shifted .* filter;
            filtered = ifftshift(filtered_shifted);
            NI = ifft2(filtered);
            ideal(:,:,c) = mat2gray(real(NI));
        end
    end
end
