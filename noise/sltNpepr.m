function Nimg = sltNpepr(img, ps, pp)
    
    [H, W, L] = size(img);
    Nimg = img;  % Start with original image
    
    % Add salt noise (white pixels)
    saltNo = round(ps * W * H);
    for i = 1:saltNo
        row = ceil(rand(1,1) * H);
        col = ceil(rand(1,1) * W);
        % Apply to all channels if RGB
        if L == 1
            Nimg(row, col) = 255;
        else
            Nimg(row, col, :) = 255;
        end
    end
    
    % Add pepper noise (black pixels)
    peprNo = round(pp * W * H);
    for i = 1:peprNo
        row = ceil(rand(1,1) * H);
        col = ceil(rand(1,1) * W);
        % Apply to all channels if RGB
        if L == 1
            Nimg(row, col) = 0;
        else
            Nimg(row, col, :) = 0;
        end
    end
    
    Nimg = uint8(Nimg);
end
