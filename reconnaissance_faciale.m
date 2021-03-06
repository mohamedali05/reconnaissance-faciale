clear ; close all ; clc ; 
load I1.mat ; load Im.mat ; load mu.mat; load score.mat ; load coeff.mat ; load r.mat ; load c.mat ; 
A = dir('database') ; 

eigFaces = coeff ;

%personne recherché
n= 3 ;
numeroPhoto= 2;
imtest = imread ([A(2+n).folder, '/' , A(2+n).name, '/' ,num2str(numeroPhoto),'.jpg']) ;
imtest=imresize(imtest,[200,200]);
imtest = im2double(rgb2gray(imtest));
imtest1(:,1)=imtest(:);
weight= coeff'*(imtest1-mu');
 
meilleuredistance= immse ( weight, score(1 , :)') ; 
personneressemblant=1;
for i=2:size(score,1)
    distance=immse ( weight, score(i, :)');
    if distance<meilleuredistance
        meilleuredistance=distance;
        personneressemblant=i;
    end
end

%affichage

figure;
subplot(211)
imshow(reshape(I1(:,personneressemblant),r,c));
title('personne ressemblante');
subplot(212)
imshow(reshape(imtest1,r,c));
title('personne recherché');