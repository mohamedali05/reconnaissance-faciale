function [Ifinal, nomPhoto]=preTraitement(I,name,tailleImageL,tailleImageH)
    if ndims(I)==3
        I=im2double(rgb2gray(I)); 
    else
        I=im2double(I);
    end
    if size(I,1)>800 && size(I,2)>800
        I1=imadjust(I1); 
        I2=imadjust(I2);
    end
    if size(I,1)>800 && size(I,2)>800
        I=imresize(I,[tailleImageH tailleImageL]);
    end
    
    B=1/9.*ones(3,3);
    I1=I;
    I2=I;
    %Filtrage par gaussienne(selon test sert à rien)
    %I=filter2(B,I);
    %I=imgaussfilt(I,2);
    %améliorer contraste
    %I=imadjust(I);

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
    
%     figure;imshow(I1);
%     figure;imshow(I2);
    Ifinal=[I(:) I1(:) I2(:)];
    nomPhoto=[];
    imshow(I1);
    for i=1:3
        nomPhoto=[nomPhoto name];
    end
end