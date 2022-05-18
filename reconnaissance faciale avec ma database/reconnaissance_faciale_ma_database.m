clear ; close all ; clc ; 
load constante/myfile.mat; 
A = dir('TestDatabase') ; 

eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');

prompt = {'Enter test image name (a number between 1 to 10):'};
dlg_title = 'Input of PCA-Based Face Recognition System';
num_lines= 1;
def = {'1'} ; 

TestImage  = inputdlg(prompt,dlg_title,num_lines,def);
TestImage = strcat(TestDatabasePath,'\',char(TestImage),'.jpg');
imtest = imread(TestImage);

imtest=imresize(imtest,[200,200]);
imtest = im2double(rgb2gray(imtest));
imtest1(:,1)=imtest(:);
weight= coeff'*(imtest1-mu');
 
meilleuredistance= immse ( weight, score(1 , :)') ; 
personneressemblant=1;
for i=2:size(score,1)
    distance=immse ( weight, score(i, :)');
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