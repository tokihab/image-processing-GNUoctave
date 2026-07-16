function Nimg = gussNoise(img, v, m)

    img=double(img);
    [H, W, ~] = size(img);
    
    for i=1:225
        
        ppxNo = round(((exp(-((i-m)^2/(2*v*v))))/(sqrt(2*3.14))));
        
        for x=1:ppxNo
            
            row=ceil(rand(1,1)*H);
            col=ceil(rand(1,1)*W);
            img(row,col)=img(row,col)+i;
            
        end
        
    end
    
    for k=1:1
        
        mn=min(min(img(:,:,k)));
        mx=max(max(img(:,:,k)));
        Nimg(:,:,k)=((img(:,:,k)-mn)/(mx-mn)*255);
        
    end
    
    Nimg = uint8(Nimg);
    
end