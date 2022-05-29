clear ; close all ; clc ; 
load constante/myfile.mat; 
A = dir('TestDatabase') ; 

eigFaces = coeff ;

%personne recherché
if exist('cam') ==0
    cam = webcam;
end

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
visageNormalise=false;
% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
step(videoPlayer, videoFrame);
while visageNormalise==false
    im=snapshot(cam);
    [imtest visageNormalise]=Normalisation(im);
    step(videoPlayer, im);
end
taille=size(imtest);
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
    title(['personne ressemblante : ',' ',nomPhoto(personneRessemblant),100*(seuil-meilleureDistance)/seuil ]);
    subplot(212)
    imshow(reshape(imtest1,tailleImageH,tailleImageL));
    title('personne recherché');
else
    'pas reussi'
end