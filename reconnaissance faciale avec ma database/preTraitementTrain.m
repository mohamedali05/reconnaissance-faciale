function [Ifinal, nomPhoto]=preTraitementTrain(I,name,tailleImageL,tailleImageH)
    if ndims(I)==3
        I=im2double(rgb2gray(I)); 
    else
        I=im2double(I);
    end
    
    
    I=imresize(I,[tailleImageL,tailleImageH]);
    I1=I;
    I2=I;
    
    m=8;
    B=1/m^2.*ones(m,m);
    
    %Filtrage par gaussienne(selon test sert à rien)
    %I=filter2(B,I);
    %I=imgaussfilt(I,2);
    %améliorer contraste
    %I=imadjust(I);

    %Changement luminosité
    if mean(I(:))<85/255
        I1=I1+mean(I1(:));
        I2=I2+2*mean(I2(:));
    elseif mean(I(:))<170/255
        I1=I1+mean(I1(:))/2;
        I2=I2-mean(I2(:))/2;
    else
        I1=I1-mean(I1(:))/2;
        I2=I2-mean(I2(:))/4;
    end
%     figure;imshow(I1);
%     figure;imshow(I2);
%     figure;imshow(I);
%     II1=mean(I1(:))*255
%     II2=mean(I2(:))*255
%       I=imadjust(I);
%       I1=imadjust(I1);
%       I2=imadjust(I2);
      I=filter2(B,I);
      I1=filter2(B,I1);
      I2=filter2(B,I2);
    Ifinal=[I(:) I1(:) I2(:)];
    nomPhoto=[];
    for i=1:3
        nomPhoto=[nomPhoto name];
    end
end