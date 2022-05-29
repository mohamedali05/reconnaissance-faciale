clear ; close all ; 

A = dir('trainset') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 

nomPhoto=[];
 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 
   im = im2double(im);
  %I = imread(strcat(num2str(n),'.jpg')); %read image
  [r,c] = size(im); % get number of rows and columns in image
  I1(:,n) = im(:); % convert image to vector and store as column in matrix 
  nomPhoto=[nomPhoto erase(convertCharsToStrings(A(2+n).name),'.gif')];
 end
 I= I1';


%moyenne de entre point dans chaque image
moyenne = mean(I,1); 
%Placer origine au point de la moyenne pour chaque point
Im = I-(repmat(moyenne',1,M))' ;

[coeff,score,latent,~,explained,mu] = pca(I, 'Centered', true) ;
%Donne les vecteurs propres, la projection de chaque image sur cette
%ces vecteurs propres,explained: pourcentage de variance de chaque vecteur
%propre 
%calculate eigenfaces
eigFaces = coeff ;
save ('constante/myfile.mat',  'coeff' , 'score' , 'mu', 'I1','I', 'r', 'c', 'Im', 'nomPhoto' ,'moyenne'); 

Xcentered = score*coeff' ; 



% put eigenface in array and display
ef = [];
for n = 1: length (eigFaces(1, : ) )
  temp = reshape(eigFaces(:,n),r,c);
  temp = histeq(temp,255);
  ef = [ef temp];
end

ef1 = [];
for n = 1: size(Xcentered,1)
  temp1 =reshape(Xcentered(n,:),r,c);
  temp1 = histeq(temp1,255);
  ef1= [ef1 temp1];

end

figure;
imshow(ef,'Initialmagnification','fit');
title('Eigenfaces');

figure ;
imshow(ef1,'Initialmagnification','fit');
title('reconstructed faces');
