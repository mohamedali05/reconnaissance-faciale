clear ; close all ; clc ; 
load constante/myfile.mat; 



eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');
A = dir(TestDatabasePath) ;
reussi=0;
test=0;
match=[];
for nbTestImage=3:(size(A,1))
    TestImage = strcat(A(nbTestImage).folder,'\',A(nbTestImage).name);
    imtest = im2double(imread(TestImage)) ;

    imtest1(:,1)=imtest(:);
    weight= coeff'*(imtest1-moyenne');

    meilleuredistance= immse ( weight, score(1 , :)') ; 
    personneressemblant=1;
    for i=2:size(score,1)
        distance=immse ( weight, score(i, :)');
        if distance<meilleuredistance
            meilleuredistance=distance;
            personneressemblant=i;
        end
    end
    name=regexp(erase(A(nbTestImage).name,'.gif'),'\.','split');
    if name(1)==nomPhoto(personneressemblant)
        reussi=reussi+1;
        %erase(A(nbTestImage).name,'.jpg')
    end
    test=test+1;
    match=[match [erase(A(nbTestImage).name,'.gif');nomPhoto(personneressemblant)]];
end

pourcentage_reussite=100*reussi/test;
pourcentage_reussite


%affichage

% figure;
% subplot(211)
% imshow(reshape(I1(:,personneressemblant),r,c));
% title('personne ressemblante');
% subplot(212)
% imshow(reshape(imtest1,r,c));
% title('personne recherché');