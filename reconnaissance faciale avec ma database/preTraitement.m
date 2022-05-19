function [Ifinal, nomPhoto]=preTraitement(I,name,tailleImageL,tailleImageH)
    if ndims(I)==3
        I=im2double(rgb2gray(I)); 
    else
        I=im2double(I);
    end
    I=imresize(I,[tailleImageL,tailleImageH]);
    B=1/9.*ones(3,3);
    %Changement luminosité
    if mean(I(:))<85/255
        I1=I+mean(I(:));
        I2=I+2*mean(I(:));
    elseif mean(I(:))<170/255
        I1=I+mean(I(:))/2;
        I2=I-mean(I(:))/2;
    else
        I1=I-mean(I(:))/2;
        I2=I-mean(I(:))/4;
    end
    %améliorer contraste
    I1=imadjust(I1);
    I2=imadjust(I2);
    %Filtrage par gaussienne(selon test sert à rien)
%     I1=filter2(B,imadjust(I1));
%     I2=filter2(B,imadjust(I2));
    Ifinal=[I(:) I1(:) I2(:)];
    nomPhoto=[];
    for i=1:3
        nomPhoto=[nomPhoto name];
    end
end