function mag_spectrum = fourierTransform(img)
    [H, W, L] = size(img);
    mag_spectrum = zeros(H, W, L);
    
    for c = 1:L
        % Compute FFT and shift to center
        f = fft2(double(img(:,:,c)));
        f_shifted = fftshift(f);
        
        % Compute log-magnitude spectrum
        mag = log(1 + abs(f_shifted));
        mag_spectrum(:,:,c) = mag;
    end
    
    % Normalize for display
    mag_spectrum = uint8(mat2gray(mag_spectrum) * 255);
end