function Ifinal=proTraitement(I,tailleImageL,tailleImageH)
    if ndims(I)==3
        I=im2double(rgb2gray(I)); 
    else
        I=im2double(I);
    end
    I=imresize(I,[tailleImageL,tailleImageH]);
    m=8;
    B=1/m^2.*ones(m,m);
    I1=I;
    
    %Filtrage par gaussienne(selon test sert à rien)
    %I1=imgaussfilt(I1,2);
    I1=filter2(B,I1);
    %Changement luminosité
%     if mean(I1(:))<85/255
%         I1=I1+mean(I1(:));
%     elseif mean(I1(:))>170/255
%         I1=I1-mean(I1(:))/4;
%     end
    %améliorer contraste
    %I1=imadjust(I1);
    
    

    Ifinal=I1(:);

 
end