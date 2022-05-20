n=3;
A = dir('trainingSet') ;
B=1/25.*ones(5,5);
im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 
I1=filter2(B,im2double(rgb2gray(im)));
subplot(211)
imshow(I1);
subplot(212)
imshow(rgb2gray(im));