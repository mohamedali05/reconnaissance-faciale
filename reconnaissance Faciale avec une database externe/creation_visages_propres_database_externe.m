clear ; close all ; 

A = dir('trainset') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 
tailleImageL=243;
tailleImageH=320;
nomPhoto=[];
I1=[];
 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 
  %I = imread(strcat(num2str(n),'.jpg')); %read image
   % get number of rows and columns in image
  [I2,nom]=preTraitement(im,erase(convertCharsToStrings(A(2+n).name),'.gif'),false);
  I1=[I1 I2];
  nomPhoto=[nomPhoto nom];
  c=tailleImageL;
  r=tailleImageH;
 end
 I= im2double(I1');

%moyenne de entre point dans chaque image
%moyenne = mean(I,1); 
%Placer origine au point de la moyenne pour chaque point
%Im = I-(repmat(moyenne',1,M))' ;

[coeff,score,latent,~,explained,mu] = pca(I, 'Centered', true) ;
%Donne les vecteurs propres, la projection de chaque image sur cette
%ces vecteurs propres,explained: pourcentage de variance de chaque vecteur
%propre 
%calculate eigenfaces
eigFaces = coeff ;
save ('constante/myfile.mat',  'coeff' , 'score' , 'mu', 'I1','I', 'r', 'c', 'nomPhoto' ); 

Xcentered = score*coeff' ;



% put eigenface in array and display
ef = [];
for n = 1: 14
  temp = reshape(eigFaces(:,n),r,c);
  temp = histeq(temp,255);
  ef = [ef temp];
end

ef1 = [];
for n = 1: size(Xcentered,1)
  temp1 = reshape(Xcentered(n,:),r,c);
  temp1 = histeq(temp1,255);
  ef1= [ef1 temp1];

end

figure;
imshow(ef,'Initialmagnification','fit');
title('Eigenfaces');

figure ;
imshow(ef1,'Initialmagnification','fit');
title('reconstructed faces');
