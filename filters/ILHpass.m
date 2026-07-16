function ideal = ILHpass(I, D0, index)
    
    [H, W, L]=size(I);
    filter=zeros(H, W, L);
    for j=1:H
        for k=1:W
            dis=sqrt((j-(H/2)).^2+(k-(W/2).^2));
            if(dis<=D0)
                filter(j,k)=1;
            end
        end
        if(index==0)
            filter=filter;
        else
            filter=1-filter;
        end
        
        % Frequency domain processing
        fi = fft2(I);
        fi_shifted = fftshift(fi);

        % Apply filter
        filtered_shifted = fi_shifted .* filter;

        % Inverse processing
        filtered = ifftshift(filtered_shifted);
        NI = ifft2(filtered);

        % Return properly scaled image
        ideal = mat2gray(real(NI));
        
    end
end