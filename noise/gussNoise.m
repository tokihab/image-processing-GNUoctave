function Nimg = gussNoise(img, v, m)
    [H, W, L] = size(img);
    stddev = sqrt(max(v, 0));
    noise = m + stddev * randn(H, W);

    if L > 1
        noise = repmat(noise, [1, 1, L]);
    end

    Nimg = double(img) + noise;
    Nimg = min(max(Nimg, 0), 255);
    Nimg = uint8(Nimg);
end
