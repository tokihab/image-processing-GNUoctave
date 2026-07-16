function Nimg = sltNpepr(img,ps,pp)
    
    [H, W, L]=size(img);
    saltNo=round(ps*W*H);
    peprNo=round(pp*W*H);
    
    for i=1:saltNo
        
        row=ceil(rand(1,1)*H);
        col=ceil(rand(1,1)*W);
        img(row,col)=255;
        
    end
    
    Nimg=img;
    Nimg=uint8(Nimg);
    
end
