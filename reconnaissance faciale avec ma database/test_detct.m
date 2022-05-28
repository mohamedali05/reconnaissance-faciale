clc
clear all
close all
A = dir('Nouveau dossier') ; 
M = size(A,1)-2;
n=34;
I=Normalisation(imread ([A(2+n).folder, '/' , A(2+n).name]));
imshow(I);