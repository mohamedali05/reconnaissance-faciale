clear ; close all ; 

A = dir('trainingSet') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 
nomPhoto=[];
tailleImageL=300;
tailleImageH=300;
I1=[];
 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ;
%    im=Normalisation(im);
%    figure;imshow(im);
   % get number of rows and columns in image
  %I1(:,n) = im(:); % convert image to vector and store as column in matrix
  [I2,nom]=preTraitementTrain(im,erase(convertCharsToStrings(A(2+n).name),'.jpg'),tailleImageL,tailleImageH);
  
  I1=[I1 I2];
  nomPhoto=[nomPhoto nom];
 end
%I1=partition(0,7 0,3);
 I= I1'; 
%moyenne de entre point dans chaque image
moyenne = mean(I,1); 
%Placer origine au point de la moyenne pour chaque point
% T=(repmat(moyenne,length (I(: , 1)),1));
% Im = I- T;


[coeff,score,latent,~,explained,mu] = pca(I,'Centered',true);
%Donne les vecteurs propres, la projection de chaque image sur cette
%ces vecteurs propres,explained: pourcentage de variance de chaque vecteur
%propre 
%calculate eigenfaces
optimalNumber=0;
total=0;
while total<100 && optimalNumber<size(explained,1)
    optimalNumber=optimalNumber+1;
    total=total+explained(optimalNumber);
end
score(:,optimalNumber+1:size(score,2))=[];
coeff(:,optimalNumber+1:size(coeff,2))=[];
distanceMax=0;
for i=1:size(score,1)
    for j=i:size(score,1)
        distance=immse ( score(j,:), score(i, :));
        if distance>distanceMax
            distanceMax=distance;
        end
    end
end
seuil=distanceMax/2;
eigFaces = coeff ;
save ('constante/myfile.mat',  'coeff' , 'score' , 'mu', 'I1','I', 'tailleImageH','tailleImageL','nomPhoto' , 'moyenne','seuil'); 

Xcentered = score*coeff' ; 



% put eigenface in array and display
ef = [];
for n = 1: length (eigFaces(1, : ) )
  temp = reshape(eigFaces(:,n),tailleImageH,tailleImageL);
  temp = histeq(temp,255);
  ef = [ef temp];
end

ef1 = [];
for n = 1: size(Xcentered,1)
  temp1 =reshape(Xcentered(n,:),tailleImageL,tailleImageH);
  temp1 = histeq(temp1,255);
  ef1= [ef1 temp1];

end

figure;
imshow(ef,'Initialmagnification','fit');
title('Eigenfaces');

figure ;
imshow(ef1,'Initialmagnification','fit');
title('reconstructed faces');



