
A = dir('trainingSet') ;
tailleImageL=200;
tailleImageH=200;
I11=[];
I22=[];
Ior=[];
for n=1:size(A,1)-2
    I = imread ([A(2+n).folder, '/' , A(2+n).name]) ;
    I=im2double(rgb2gray(I)); 
    I=imresize(I,[tailleImageL,tailleImageL]);
    B=1/9.*ones(3,3);
    std(I);
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
    %Filtrage par gaussienne
    I1=filter2(B,imadjust(I1));
    I2=filter2(B,imadjust(I2));
    I11=[I11 I1];
    I22=[I22 I2];
    Ior=[Ior I];
end
% I11=[I1 imadjust(I1)];
% I22=[I2 imadjust(I2)];
% I1=[filter2(B,imadjust(I1)) I11];
figure;
subplot(311)
imshow(I11);
title('I1');
subplot(312)
imshow(I22);
title('I2');
subplot(313)
imshow(Ior);
title('I');
