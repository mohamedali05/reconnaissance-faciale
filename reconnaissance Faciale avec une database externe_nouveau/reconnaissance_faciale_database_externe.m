clear ; close all ; clc ; 
load constante/myfile.mat; 
A = dir('trainset') ; 

eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');

prompt = {'Enter the name of the image you want to test'};
dlg_title = 'Input of PCA-Based Face Recognition System';
num_lines= 1;
def = {'1'} ; 

TestImage  = inputdlg(prompt,dlg_title,num_lines,def);
TestImage = strcat(TestDatabasePath,'\',char(TestImage),'.gif');
imtest = double(imread(TestImage));

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
imshow(reshape(uint8(imtest1),r,c));
title('personne recherché');