clc
clear all
close all
A = dir('Nouveau dossier') ; 
M = size(A,1)-2;
n=25;

Image=rgb2gray(imread ([A(2+n).folder, '/' , A(2+n).name])) ; 
Image=imadjust(Image);
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
% Run the face detector.
bboxFace = step(faceDetector, Image);

if ~isempty(bboxFace)
    
    for i=1:size(bboxFace,1)
        if bboxFace(i,3)>200 && bboxFace(i,4)>200
            bboxPoints = bbox2points(bboxFace(1, :));
        end
    end
    videoFrame2 = insertShape(Image, 'Rectangle', bboxFace);
    figure; imshow(videoFrame2); title('Detected face');
    %Augmente le rectangle de la bbox
%     bboxFace(1,2)=bboxFace(1,2)-bboxFace(1,4)*1/8;
%     bboxFace(1,4)=bboxFace(1,4)*9/8;
%     
%     bboxFace(1,1)=bboxFace(1,1)-bboxFace(1,3)*1/8;
%     bboxFace(1,3)=bboxFace(1,3)*9/8;
    I=rgb2gray(imcrop(videoFrame2,bboxFace(1,:)));
    figure
    imshow(I);
    I=imadjust(I);
    eyeDetector = vision.CascadeObjectDetector('lefteye');
    bboxEye = step(eyeDetector,I);
    bboxPointsEye=[];
    for i=1:size(bboxEye,1)
        if bboxEye(i,3)>bboxFace(1,3)/6 && bboxEye(i,4)>bboxFace(1,4)/8
            bboxPointsEye = [bboxPointsEye ; bboxEye(i, :)];
        end
    end
    xEye=[];
    yEye=[];
    for i=1:size(bboxPointsEye,1)
        videoFrame1 = imcrop(I, 'Rectangle', bboxPointsEye(i,:));
        figure; imshow(videoFrame1); title('Detected eyes');
        xEye=[xEye bboxPointsEye(i,1)+bboxPointsEye(i,3)/2];
        yEye=[yEye bboxPointsEye(i,2)+bboxPointsEye(i,4)/2];
    end
    for i=1:size(xEye,1)
        if xEye(1)<bboxFace(1,3)/2
            if xEye(1)~=bboxFace(1,3)*60/200
                bboxFace(1,1)=bboxFace(1,1)+xEye(1)-bboxFace(1,3)*60/200;
            end
            if  yEye(1)~=bboxFace(1,4)*50/200
                bboxFace(1,2)=bboxFace(1,2)+yEye(1)-bboxFace(1,4)*70/200;
            end
        end
        if xEye(1)>bboxFace(1,3)/2
            if xEye(1)~=bboxFace(1,3)*60/200
                bboxFace(1,1)=bboxFace(1,1)+xEye(1)-bboxFace(1,3)*140/200;
            end
            if  yEye(1)~=bboxFace(1,4)*50/200
                bboxFace(1,2)=bboxFace(1,2)+yEye(1)-bboxFace(1,4)*70/200;
            end
        end
    end
    videoFrame3 = rgb2gray(imcrop(videoFrame2,bboxFace(1,:)));
    figure; imshow(videoFrame3); title('Detected face');
    %x=bbox*60/200;
    %espace inter yeux 80 sinon 60
%     mouthDetector = vision.CascadeObjectDetector('mouth');
%     bboxMouth = step(mouthDetector,I);
%     bboxPointsMouth=[];
%     
%     for i=1:size(bboxMouth,1)
%         if bboxMouth(i,3)>bbox(1,3)/6 && bboxMouth(i,4)>bbox(1,4)/10 
%             bboxPointsMouth = bboxMouth(i, :);
%         end
%     end
%     for i=1:size(bboxPointsMouth,1)
%         videoFrame1 = imcrop(I, 'Rectangle', bboxPointsMouth(i,:));
%         figure; imshow(videoFrame1); title('Detected mouth');
%     end
    
end