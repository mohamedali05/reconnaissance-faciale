clear ; close all ; 

A = dir('dataset/eigenfaces') ; 

M = 10;
% I = imread ([A(4).folder, '/' , A(4).name]) ; 
%  imshow(I) ; 

 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 

  %I = imread(strcat(num2str(n),'.jpg')); %read image
  im = im2double(rgb2gray(im)); % convert image to gray scale and then to double precision
  [r,c] = size(im); % get number of rows and columns in image
  I1(:,n) = im(:); % convert image to vector and store as column in matrix 
 end

 I= I1' ; 

moyenne = mean(I,1); 
Im = I-(repmat(moyenne',1,M))' ;

[coeff,score,latent,~,explained,mu] = pca(Im);
%calculate eigenfaces
eigFaces = coeff ;

Xcentered = score*coeff' ;
Xcentered = Xcentered +(repmat(moyenne',1,M))' ;


% % put eigenface in array and display
ef = [];
for n = 1: 9
  temp = reshape(eigFaces(:,n),r,c);
  temp = histeq(temp,255);
  ef = [ef temp];

end

ef1 = [];
for n = 1: 10
  temp1 = reshape(Xcentered(n,:),r,c);
  temp1 = histeq(temp1,255);
  ef1= [ef1 temp1];

end
% 
figure;
imshow(ef,'Initialmagnification','fit');
title('Eigenfaces');
 
figure;
imshow(ef1,'Initialmagnification','fit');
title('reconstructed faces');

Erreur = norm (Im(1 , :) - Xcentered(1 , :)) ; 
Erreur2 = immse (Im(1, : ) , Xcentered(1 , : )) ; 

  


