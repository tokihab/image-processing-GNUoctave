function reconstructed = inverseFourier(freq_domain)
    [H, W, L] = size(freq_domain);
    reconstructed = zeros(H, W, L, 'uint8');
    
    for c = 1:L
        % Shift back and compute inverse FFT
        f_unshifted = ifftshift(freq_domain(:,:,c));
        img = real(ifft2(f_unshifted));
        
        % Normalize and convert to uint8
        reconstructed(:,:,c) = uint8(mat2gray(img) * 255);
    end
end