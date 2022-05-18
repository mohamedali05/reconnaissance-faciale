clear ; close all ; 

A = dir('trainingSet') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 
nomPhoto=[];
tailleImageL=200;
tailleImageH=200;
 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 
   im = im2double(rgb2gray(im)); 
   im=imresize(im,[tailleImageL,tailleImageL]);
   nomPhoto=[nomPhoto erase(convertCharsToStrings(A(2+n).name),'.jpg')];
  %I = imread(strcat(num2str(n),'.jpg')); %read image
  [r,c] = size(im); % get number of rows and columns in image
  I1(:,n) = im(:); % convert image to vector and store as column in matrix 
 end
%I1=partition(0,7 0,3);
 I= I1'; 
%moyenne de entre point dans chaque image
moyenne = mean(I,1); 
%Placer origine au point de la moyenne pour chaque point
%Im = I-(repmat(moyenne',1,M))' ;
%Im=I-repmat(moyenne,M,1)  ;

[coeff,score,latent,~,explained,mu] = pca(I,'Centered',false);
%Donne les vecteurs propres, la projection de chaque image sur cette
%ces vecteurs propres,explained: pourcentage de variance de chaque vecteur
%propre 
%calculate eigenfaces
eigFaces = coeff ;
save ('constante/myfile.mat',  'coeff' , 'score' , 'mu', 'I1','I', 'r', 'c','nomPhoto' ); 



