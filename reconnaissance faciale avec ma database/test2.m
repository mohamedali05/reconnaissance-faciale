clear ; close all ; 

A = dir('dataset/eigenfaces') ; 

M = 10;
%  imshow(I) ; 
ef = [] ; 
 for n=1:M
   im = imread ([A(2+n).folder, '/' , A(2+n).name]) ; 
    ef1= [ef1 im];
 
 end
 imshow(ef1) ;