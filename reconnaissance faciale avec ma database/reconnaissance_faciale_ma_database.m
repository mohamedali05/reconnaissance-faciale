clear ; close all ; clc ; 
load constante/myfile.mat; 
 

eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');
A = dir(TestDatabasePath) ;
prompt = {'Enter the number of the image you want to test:'};
dlg_title = 'Input of PCA-Based Face Recognition System';
num_lines= 1;
def = {'1'} ; 

TestImage  = inputdlg(prompt,dlg_title,num_lines,def);
n=str2double(char(TestImage));
TestImage = strcat(A(n).folder,'\',A(2+n).name);
imtest = imread(TestImage);
imtest1=preTraitementTest(imtest,tailleImageH,tailleImageL);

weight= coeff'*(imtest1-mu');
 
meilleureDistance= immse ( weight, score(1 , :)') ; 
personneRessemblant=1;
for i=2:size(score,1)
    distance=immse ( weight, score(i, :)');
    if distance<meilleureDistance
        meilleureDistance=distance;
        personneRessemblant=i;
    end
end
if meilleureDistance>seuil
    personneRessemblant=NaN;
end
%affichage
if personneRessemblant~=NaN
    figure;
    subplot(211)
    imshow(reshape(I1(:,personneRessemblant),tailleImageH,tailleImageL));
    title('personne ressemblante : '+nomPhoto(personneRessemblant));
    subplot(212)
    imshow(reshape(imtest1,tailleImageH,tailleImageL));
    title('personne recherché');
else
    'pas reussi'
end