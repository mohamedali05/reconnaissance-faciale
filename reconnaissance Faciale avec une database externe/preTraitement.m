function [Ifinal, nomPhoto]=preTraitement(I,name,tailleImageL,tailleImageH,detect)
    if ndims(I)==3
        I=im2double(rgb2gray(I)); 
    else
        I=im2double(I);
    end
    if detect
        % Create a cascade detector object.
        faceDetector = vision.CascadeObjectDetector();
        % Run the face detector.
        bbox = step(faceDetector, videoFrame);
    end
    
    I=imresize(I,[tailleImageL,tailleImageH]);
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
    I1=imadjust(I1);
    I2=imadjust(I2);
    
    Ifinal=[I(:) I1(:) I2(:)];
    nomPhoto=[];
    for i=1:3
        nomPhoto=[nomPhoto name];
    end
end