clear ; close all ; clc ;
load constante/myfile.mat;



eigFaces = coeff ;

%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');
A = dir(TestDatabasePath) ;
tailleImageL=200;
tailleImageH=200;
reussi_general=0;
reussi_normal=0;
reussi_lunette=0;
reussi_lunette_profil=0;
reussi_masque=0;
reussi_profil=0;
reussi_masque_profil=0;
test_normal=0;
test_general=0;
test_lunette=0;
test_lunette_profil=0;
test_masque=0;
test_profil=0;
test_masque_profil=0;
match_general=[];
match_normal=[];
match_lunette=[];
match_lunette_profil=[];
match_masque=[];
match_profil=[];
match_masque_profil=[];
for nbTestImage=3;size(A,1)
    TestImage = strcat(A(nbTestImage).folder,'\',A(nbTestImage).name);
    imtest = imread(TestImage);
%     if ndims(imtest)==3
%        imtest = im2double(rgb2gray(imtest));
%     else
%        imtest = im2double(imtest);
%     end
%     imtest=imresize(imtest,[tailleImageL,tailleImageH]);
%     imtest=imadjust(imtest);
%     imtest1(:,1)=imtest(;
    imtest1=proTraitement(imtest,tailleImageL,tailleImageH);
    weight= coeff'*(imtest1-mu');

    meilleuredistance= immse ( weight, score(1,:)') ;
    personneressemblant=1;
    for i=2:size(score,1)
        distance=immse ( weight, score(i,:)'); % weight : pi et score : proj des images
        if distance<meilleuredistance
            meilleuredistance=distance;
            personneressemblant=i;
        end
    end
    name=regexp(erase(A(nbTestImage).name,'.jpg'),'\.','split');
    name1=regexp(cell2string(name(2)),'\d','split');
    if name(1)==nomPhoto(personneressemblant)
        reussi_general=reussi_general+1;
        %erase(A(nbTestImage).name,'.jpg')
        if name1(1)=="normal"
           reussi_normal=reussi_normal+1;
        end
        if name1(1)=="lunette"
           reussi_lunette=reussi_lunette+1;
        end
        if name1(1)=="lunette_profil"
           reussi_lunette_profil=reussi_lunette_profil+1;
        end
        if name1(1)=="masque"
           reussi_masque=reussi_masque+1;
        end
        if name1(1)=="profil"
           reussi_profil=reussi_profil+1;
        end
        if name1(1)=="masque_profil"
           reussi_masque_profill=reussi_masque_profil+1;
        end 
    end
    if name1(1)=="normal"
            test_normal=test_normal+1;
           match_normal=[match_normal,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end
        if name1(1)=="lunette"
            test_lunette=test_lunette+1;
           match_lunette=[match_lunette,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end
        if name1(1)=="lunette_profil"
            test_lunette_profil=test_lunette_profil+1;
           match_lunette_profil=[ match_lunette_profil,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end
        if name1(1)=="masque"
            test_masque=test_masque+1;
           match_masque=[match_masque,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end
        if name1(1)=="profil"
            test_profil=test_profil+1;
           match_profil=[match_profil,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end
        if name1(1)=="masque_profil"
            test_masque_profil=test_masque_profi+1;
           match_masque_profil=[match_masque_profil,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
        end 
    test_general=test_general+1;
    match_general=[match_general,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneressemblant)]];
end

pourcentage_reussite_normal=100*reussi_normal/test_normal;
pourcentage_reussite_lunette=100*reussi_lunette/test_lunette;
pourcentage_reussite_lunette_profil=100*reussi_lunette_profil/test_lunette_profil;
pourcentage_reussite_masque=100*reussi_masque/test_masque;
pourcentage_reussite_profil=100*reussi_profil/test_profil;
pourcentage_reussite_masque_profil=100*reussi_masque_profil/test_masque_profil;
pourcentage_reussite=100*reussi_general/test_general;

pourcentage_reussite;
pourcentage_reussite_normal;
pourcentage_reussite_lunette;
pourcentage_reussite_lunette_profil;
pourcentage_reussite_masque;
pourcentage_reussite_profil;
pourcentage_reussite_masque_profil;


%affichage

% figure;
% subplot(211)
% imshow(reshape(I1(:,personneressemblant),r,c));
% title('personne ressemblante');
% subplot(212)
% imshow(reshape(imtest1,r,c));
% title('personne recherché');