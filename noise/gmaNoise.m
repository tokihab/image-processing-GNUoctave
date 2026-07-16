function Nimg = gmaNoise(img, a, b)
    img = double(img);
    [H, W, L] = size(img);
    
    for i = 1:255
        % Gamma PDF approximation (ignoring gamma function normalization)
        pdf_val = (i^(a-1)) * exp(-i / b);
        ppxNo = round(pdf_val * H * W); % b controls shape/scale
        for x = 1:ppxNo
            row = ceil(rand(1,1) * H);
            col = ceil(rand(1,1) * W);
            for c = 1:L % Handle RGB
                img(row, col, c) = img(row, col, c) + i;
            end
        end
    end
    
    % Normalize and convert to uint8
    mn = min(img(:));
    mx = max(img(:));
    Nimg = uint8(((img - mn) / (mx - mn)) * 255);
end