function filtered = medianFltr(img)
    % Apply 3x3 median filter
    % Uses ordfilt2 for speed (available in Octave image package)
    
    [H, W, L] = size(img);
    filtered = zeros(H, W, L, 'uint8');
    
    % Try to use ordfilt2 if available (much faster)
    try
        for c = 1:L
            filtered(:,:,c) = ordfilt2(double(img(:,:,c)), 9, ones(3, 3), 'symmetric');
        end
        filtered = uint8(filtered);
    catch
        % Fallback to manual implementation if ordfilt2 not available
        padded = padarray(double(img), [1 1], 'replicate');
        for c = 1:L
            for i = 1:H
                for j = 1:W
                    window = reshape(padded(i:i+2, j:j+2, c), 9, 1);
                    sorted = sort(window);
                    filtered(i,j,c) = sorted(5); % Middle element for 3x3
                end
            end
        end
        filtered = uint8(filtered);
    end
end
