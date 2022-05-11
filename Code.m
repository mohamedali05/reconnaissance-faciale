clear ; close all ; 

A = dir('database') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 

 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name, '/' ,'1.jpg']) ; 
   im1=im;
   im=imresize(im,[200,200]);
  %I = imread(strcat(num2str(n),'.jpg')); %read image
  im = im2double(rgb2gray(im)); % convert image to gray scale and then to double precision
  [r,c] = size(im); % get number of rows and columns in image
  I1(:,n) = im(:); % convert image to vector and store as column in matrix 
 end
%I1=partition(0,7 0,3);
 I= I1'; 
%moyenne de entre point dans chaque image
moyenne = mean(I,1); 
%Placer origine au point de la moyenne pour chaque point
%Im = I-(repmat(moyenne',1,M))' ;
Im=I-repmat(moyenne,M,1);

[coeff,score,latent,~,explained,mu] = pca(Im,'Centered',true);
%Donne les vecteurs propres, la projection de chaque image sur cette
%ces vecteurs propres,explained: pourcentage de variance de chaque vecteur
%propre 
%calculate eigenfaces
eigFaces = coeff ;

%test
%personne recherché
n=6;
numeroPhoto=2;
imtest = imread ([A(2+n).folder, '/' , A(2+n).name, '/' ,num2str(numeroPhoto),'.jpg']) ;
imtest=imresize(imtest,[200,200]);
imtest = im2double(rgb2gray(imtest));
imtest1(:,1)=imtest(:);
weight=coeff'*(imtest1-mu);

meilleuredistance=sum((weight-score(1,:)').^2);
personneressemblant=1;
for i=2:size(score,1)
    distance=sum((weight-score(i,:)').^2);
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


% Xcentered = score*coeff' ;
% Xcentered = Xcentered +(repmat(moyenne',1,M))' ;
% 
% 
% % put eigenface in array and display
% ef = [];
% for n = 1: size(eigFaces,2)
%   temp = reshape(eigFaces(:,n),r,c);
%   temp = histeq(temp,255);
%   ef = [ef temp];
% 
% end
% 
% ef1 = [];
% for n = 1: size(Xcentered,1)
%   temp1 = reshape(Xcentered(n,:),r,c);
%   temp1 = histeq(temp1,255);
%   ef1= [ef1 temp1];
% 
% end
% 
% figure;
% imshow(ef,'Initialmagnification','fit');
% title('Eigenfaces');
%  
% figure;
% imshow(ef1,'Initialmagnification','fit');
% title('reconstructed faces');
% 
% Erreur = norm (Im(1 , :) - Xcentered(1 , :)) ; 
% Erreur2 = immse (Im(1, : ) , Xcentered(1 , : )) ; 

  


