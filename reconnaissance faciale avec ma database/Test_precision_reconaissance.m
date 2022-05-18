clear ; close all ; clc ; 
load constante/myfile.mat; 



eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');
A = dir(TestDatabasePath) ;
tailleImageL=200;
tailleImageH=200;
reussi=0;
test=0;
match=[];
for nbTestImage=3:(size(A,1)-2)
    TestImage = strcat(A(nbTestImage).folder,'\',A(nbTestImage).name);
    imtest = imread(TestImage);

    imtest=imresize(imtest,[tailleImageL,tailleImageH]);
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
    name=regexp(erase(A(nbTestImage).name,'.jpg'),'\d','split');
    if name(1)==nomPhoto(personneressemblant)
        reussi=reussi+1;
        %erase(A(nbTestImage).name,'.jpg')
    end
    test=test+1;
    match=[match [erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
end


%affichage

% figure;
% subplot(211)
% imshow(reshape(I1(:,personneressemblant),r,c));
% title('personne ressemblante');
% subplot(212)
% imshow(reshape(imtest1,r,c));
% title('personne recherché');