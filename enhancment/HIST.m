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
