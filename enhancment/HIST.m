function histarr = HIST(IMG)
    histarr=zeros(256,1);
    [H, W, ~]=size(IMG); 
    
    for i=1:H
        for j=1:W
            histarr(IMG(i,j)+1)=histarr(IMG(i,j)+1)+1;
        end
    end
    
    bar(histarr);
    
end
function histarr = HIST(IMG)
    if ndims(IMG) == 3 && size(IMG, 3) == 3
        IMG = RGB2GRY(IMG, 1);
    end

    gray = uint8(IMG);
    histarr = accumarray(double(gray(:)) + 1, 1, [256, 1]);
    bar(histarr);
end
