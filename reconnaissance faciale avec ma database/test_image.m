clear ; close all ; 

A = dir('trainingSet') ; 

M = size(A,1)-2;
%I = imread ([A(4).folder, '/' , A(4).name]) ; 
 %imshow(I) ; 
nomPhoto=[];
tailleImageL=200;
tailleImageH=200;
I1=[];
n=2;
im = imread ([A(2+n).folder, '/' , A(2+n).name]) ;
figure;imshow(rgb2gray(im));
figure;imshow(imadjust(rgb2gray(im)));
figure;imhist(rgb2gray(im));
figure;imhist(imadjust(rgb2gray(im)));