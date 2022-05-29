clear ; close all ; clc ; 
load constante/myfile.mat; 
eigFaces = coeff ;
%personne recherché
TestDatabasePath = uigetdir('D:\Program Files\MATLAB\R2006a\work', 'Select test database path');
A = dir(TestDatabasePath) ;
tailleImageL=200;
tailleImageH=200;
reussi=0;
reussi_normal=0;
reussi_lunette=0;
reussi_lunette_profil=0;
reussi_masque=0;
reussi_profil=0;
test=0;
match_general=[];
match_normal=[];
match_lunette=[];
match_lunette_profil=[];
match_masque=[];
match_profil=[];
nbpersonne_normal=0;
nbpersonne_profil=0;
nbpersonne_masque=0;
nbpersonne_lunette=0; 
nbpersonne_lunette_profil=0;
for nbTestImage=3:(size(A,1)) 
    TestImage = strcat(A(nbTestImage).folder,'\',A(nbTestImage).name);
    imtest = imread(TestImage);
    %imtest=Normalisation(imtest);
    %imshow(imtest);
    imtest1=preTraitementTest(imtest,tailleImageL,tailleImageH); %pro_traitement
    weight= coeff'*(imtest1-mu');
    
    meilleureDistance= immse ( weight, score(1 , :)') ; 
    personneRessemblant=1;
    for i=2:size(score,1)
        distance=immse ( weight, score(i, :)'); % weight : pi et score : proj des images
        if distance<meilleureDistance 
            meilleureDistance=distance;
            personneRessemblant=i;
        end
    end
    if meilleureDistance>seuil
        personneRessemblant=NaN;
    end
    name=regexp(erase(A(nbTestImage).name,'.jpg'),'\.','split');
    name_sec=regexp(erase(A(nbTestImage).name,'.jpg'),'\d','split');
    if  name_sec(1)==nomPhoto(personneRessemblant)
        reussi=reussi+1;
        %erase(A(nbTestImage).name,'.jpg')
    end
    if name(2)=="normal"
       match_normal=[match_normal,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
       nbpersonne_normal=nbpersonne_normal+1;
       if name_sec(1)==nomPhoto(personneRessemblant)
           reussi_normal=reussi_normal+1;
       end 
    end
    if name(2)=="lunette"
       match_lunette=[match_lunette,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
       nbpersonne_lunette=nbpersonne_lunette+1;
       if name_sec(1)==nomPhoto(personneRessemblant)
           reussi_lunette=reussi_lunette+1;
       end 
    end
    if name(2)=="lunette_profil"
       match_lunette_profil=[ match_lunette_profil,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
       nbpersonne_lunette_profil=nbpersonne_lunette_profil+1;
       if name_sec(1)==nomPhoto(personneRessemblant)
           reussi_lunette_profil=reussi_lunette_profil+1;
           end 
    end
    if name(2)=="masque"
       match_masque=[match_masque,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
       nbpersonne_masque=nbpersonne_masque+1;
       if name_sec(1)==nomPhoto(personneRessemblant)
           reussi_masque=reussi_masque+1;
       end 
    end
    if name(2)=="profil"
       match_profil=[match_profil,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
       nbpersonne_profil=nbpersonne_profil+1;
       if name_sec(1)==nomPhoto(personneRessemblant)
           reussi_profil=reussi_profil+1;
       end 
    end
    test=test+1;
    match_general=[match_general,[erase(A(nbTestImage).name,'.jpg');nomPhoto(personneRessemblant)]];
    end
pourcentage_reussite_normal=100*reussi_normal/nbpersonne_normal;
pourcentage_reussite_lunette=100*reussi_lunette/nbpersonne_lunette;
pourcentage_reussite_lunette_profil=100*reussi_lunette_profil/nbpersonne_lunette_profil;
pourcentage_reussite_masque=100*reussi_masque/nbpersonne_masque;
pourcentage_reussite_profil=100*reussi_profil/nbpersonne_profil;
pourcentage_reussite=100*reussi/test;
pourcentage_reussite
pourcentage_reussite_normal
pourcentage_reussite_lunette
pourcentage_reussite_lunette_profil
pourcentage_reussite_masque
pourcentage_reussite_profil
%affichage
% figure;
% subplot(211)
% imshow(reshape(I1(:,personneressemblant),r,c));
% title('personne ressemblante');
% subplot(212)
% imshow(reshape(imtest1,r,c));
% title('personne recherché');