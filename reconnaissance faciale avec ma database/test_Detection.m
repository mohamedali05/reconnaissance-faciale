clc
clear all
close all
A = dir('Nouveau dossier') ; 
M = size(A,1)-2;
n=34;

Image=im2double(rgb2gray(imread ([A(2+n).folder, '/' , A(2+n).name]))) ; 
Image=imadjust(Image);
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();
% Run the face detector.
bboxFace = step(faceDetector, Image);
bboxFaceTrie=[];
if ~isempty(bboxFace)
    
    for i=1:size(bboxFace,1)
        if bboxFace(i,3)>0.1*size(Image,1) && bboxFace(i,4)>0.1*size(Image,2)
            %bboxPoints = bbox2points(bboxFace(1, :));
            bboxFaceTrie=[bboxFaceTrie ;bboxFace(i, :)];
        end
    end
    ImageAvecCarre = insertShape(Image, 'Rectangle', bboxFaceTrie);
    figure; imshow(ImageAvecCarre); title('Detected face');
    
    %Augmente le rectangle de la bbox
    bboxFaceTrie(1,2)=bboxFaceTrie(1,2)-bboxFaceTrie(1,4)*3/16;
    bboxFaceTrie(1,4)=bboxFaceTrie(1,4)*19/16;
    
    bboxFaceTrie(1,1)=bboxFaceTrie(1,1)-bboxFaceTrie(1,3)*1/16;
    bboxFaceTrie(1,3)=bboxFaceTrie(1,3)*18/16;
    
    %Image rogné du visage 
    I=im2double(imcrop(Image,bboxFaceTrie(1,:)));
    figure
    imshow(I);
%     m=2;
%     B=1/m^2.*ones(m,m);
%     I1=filter2(B,I);
    %I1=imadjust(I);
    I1=I;
    eyeDetector = vision.CascadeObjectDetector('EyePairBig');
    bboxEye = step(eyeDetector,I1);
    %Trie les yeux qu'ila detecté
    if ~isempty(bboxEye)
        bboxSetEyeTrie=[];
        for i=1:size(bboxEye,1)
            if bboxEye(i,3)>bboxFaceTrie(1,3)/10 && bboxEye(i,4)>bboxFaceTrie(1,4)/12
                bboxSetEyeTrie = [bboxSetEyeTrie ; bboxEye(i, :)];
            end
        end
        PairYeux = imcrop(I, 'Rectangle', bboxSetEyeTrie);
        figure; imshow(PairYeux); title('Detected eyes');
        %Gauche
        eyeDetector = vision.CascadeObjectDetector('lefteye');
        bboxLeftEye = step(eyeDetector,PairYeux);
        bboxLeftEyeTrie=[];
        %Droit
        eyeDetector = vision.CascadeObjectDetector('righteye');
        bboxRightEye = step(eyeDetector,PairYeux);
        bboxRightEyeTrie=[];
        xLeftEye=[];
        xRightEye=[];
        
        if ~isempty(bboxLeftEye)
            for i=1:size(bboxLeftEye,1)
                if bboxLeftEye(i,3)>bboxSetEyeTrie(1,3)/6 && bboxLeftEye(i,4)>bboxSetEyeTrie(1,4)/4 && bboxLeftEye(i,1)<bboxSetEyeTrie(1,1)/2
                    bboxLeftEyeTrie = [bboxLeftEyeTrie ; bboxLeftEye(i, :)];
                    xLeftEye=bboxSetEyeTrie(1,1)+bboxLeftEye(i,1)+bboxLeftEye(i,3)/2;
                    yLeftEye=bboxSetEyeTrie(1,2)+bboxLeftEye(i,2)+bboxLeftEye(i,4)/2;
                end
            end
        end  
        if ~isempty(bboxRightEye)
            for i=1:size(bboxRightEye,1)
                if bboxRightEye(i,3)>bboxSetEyeTrie(1,3)/8 && bboxRightEye(i,4)>bboxSetEyeTrie(1,4)/6 && bboxRightEye(i,1)>bboxSetEyeTrie(1,1)/2
                    bboxRightEyeTrie = [bboxRightEyeTrie ; bboxRightEye(i, :)];
                    xRightEye=bboxSetEyeTrie(1,1)+bboxRightEye(i,1)+bboxRightEye(i,3)/2;
                    yRightEye=bboxSetEyeTrie(1,2)+bboxRightEye(i,2)+bboxRightEye(i,4)/2;
                end
            end
        end
        
        if ~isempty(xRightEye) && ~isempty(xLeftEye)
%             for i=1:size(xLeftEye,1)
%                 if xLeftEye(1)~=bboxFaceTrie(1,3)*60/200
%                     bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(i)-bboxFaceTrie(1,3)*60/200;
%                 end
%                 if  yLeftEye(1)~=bboxFaceTrie(1,4)*70/200
%                     bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yLeftEye(i)-bboxFaceTrie(1,4)*70/200;
%                 end
%             end
%             for i=1:size(xRightEye,1)
%                 if xRightEye(1)~=bboxFace(1,3)*60/200
%                     bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xRightEye(i)-bboxFaceTrie(1,3)*140/200;
%                 end
%                 if  yRightEye(1)~=bboxFace(1,4)*50/200
%                     bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(i)-bboxFaceTrie(1,4)*80/200;
%                 end
%             end
            RightYeux = imcrop(PairYeux, 'Rectangle', bboxRightEyeTrie);
            figure; imshow(RightYeux); title('Detected eyes');
            LeftYeux = imcrop(PairYeux, 'Rectangle', bboxLeftEyeTrie);
            figure; imshow(LeftYeux); title('Detected eyes');
            
            angle=atan((yRightEye-yLeftEye)/(xRightEye-xLeftEye));
            if angle >5*pi/180
                Image=imrotate(Image,-angle);
            end

            bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(1)-bboxFaceTrie(1,3)*60/200;
            bboxFaceTrie(1,3)=xRightEye*200/140;
            bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(1)-bboxFaceTrie(1,4)*80/200;
            
        elseif ~isempty(xRightEye)
            for i=1:size(xRightEye,1)
                if xRightEye(1)~=bboxFace(1,3)*60/200
                    bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xRightEye(i)-bboxFaceTrie(1,3)*140/200;
                end
                if  yRightEye(1)~=bboxFace(1,4)*50/200
                    bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(i)-bboxFaceTrie(1,4)*80/200;
                end
            end
            RightYeux = imcrop(PairYeux, 'Rectangle', bboxRightEyeTrie);
            figure; imshow(RightYeux); title('Detected eyes');
        elseif ~isempty(xLeftEye)
            for i=1:size(xLeftEye,1)
                if xLeftEye(1)~=bboxFaceTrie(1,3)*60/200
                    bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(i)-bboxFaceTrie(1,3)*60/200;
                end
                if  yLeftEye(1)~=bboxFaceTrie(1,4)*70/200
                    bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yLeftEye(i)-bboxFaceTrie(1,4)*80/200;
                end
            end
            LeftYeux = imcrop(PairYeux, 'Rectangle', bboxLeftEyeTrie);
            figure; imshow(LeftYeux); title('Detected eyes');
        end
            
        
        ImFinal = imcrop(Image,bboxFaceTrie(1,:));
        ImFinal = insertShape(ImFinal, 'Rectangle', [bboxFaceTrie(1,3)*60/200,bboxFaceTrie(1,4)*80/200,20,20]);
        ImFinal = insertShape(ImFinal, 'Rectangle', [bboxFaceTrie(1,3)*140/200,bboxFaceTrie(1,4)*80/200,20,20]);
        figure; imshow(ImFinal); title('Detected face');
    else
        eyeDetector = vision.CascadeObjectDetector('lefteye');
        bboxLeftEye = step(eyeDetector,I1);
        bboxLeftEyeTrie=[];
        %Droit
        eyeDetector = vision.CascadeObjectDetector('righteye');
        bboxRightEye = step(eyeDetector,I1);
        bboxRightEyeTrie=[];
        xLeftEye=[];
        xRightEye=[];

        if ~isempty(bboxLeftEye)
            for i=1:size(bboxLeftEye,1)
                if bboxLeftEye(i,3)>bboxFaceTrie(1,3)/6 && bboxLeftEye(i,4)>bboxFaceTrie(1,4)/5 && bboxLeftEye(i,1)<bboxFaceTrie(1,3)/2 && bboxLeftEye(i,2)>bboxFaceTrie(1,4)/5
                    bboxLeftEyeTrie = [bboxLeftEyeTrie ; bboxLeftEye(i, :)];
                    xLeftEye=bboxLeftEye(i,1)+bboxLeftEye(i,3)/2;
                    yLeftEye=bboxLeftEye(i,2)+bboxLeftEye(i,4)/2;
                end
            end
        end
        if ~isempty(bboxRightEye)
            for i=1:size(bboxRightEye,1)
                if bboxRightEye(i,3)>bboxFaceTrie(1,3)/6 && bboxRightEye(i,4)>bboxFaceTrie(1,4)/4 && bboxRightEye(i,1)>3*bboxFaceTrie(1,3)/8 && bboxRightEye(i,2)>bboxFaceTrie(1,4)/5
                    bboxRightEyeTrie = [bboxRightEyeTrie ; bboxRightEye(i, :)];
                    xRightEye=bboxRightEye(i,1)+bboxRightEye(i,3)/2;
                    yRightEye=bboxRightEye(i,2)+bboxRightEye(i,4)/2;
                end
            end
        end
        if ~isempty(xRightEye) && ~isempty(xRightEye)
            RightYeux = imcrop(I1, 'Rectangle', bboxRightEyeTrie);
            figure; imshow(RightYeux); title('Detected eyes');
            LeftYeux = imcrop(I1, 'Rectangle', bboxLeftEyeTrie);
            figure; imshow(LeftYeux); title('Detected eyes');
            angle=atan((yRightEye-yLeftEye)/(xRightEye-xLeftEye));
            
            if angle >5*pi/180
                Image=imrotate(Image,-angle);
            end
            
            bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(1)-bboxFaceTrie(1,3)*60/200;
            bboxFaceTrie(1,3)=xRightEye*200/140;
            bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(1)-bboxFaceTrie(1,4)*80/200;
            
        elseif ~isempty(xRightEye)
            for i=1:size(xRightEye,1)
                if xRightEye(1)~=bboxFace(1,3)*60/200
                    bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xRightEye(i)-bboxFaceTrie(1,3)*140/200;
                end
                if  yRightEye(1)~=bboxFace(1,4)*50/200
                    bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(i)-bboxFaceTrie(1,4)*80/200;
                end
            end
            RightYeux = imcrop(I1, 'Rectangle', bboxRightEyeTrie);
            figure; imshow(RightYeux); title('Detected eyes');
        elseif ~isempty(xLeftEye)
            for i=1:size(xLeftEye,1)
                if xLeftEye(1)~=bboxFaceTrie(1,3)*60/200
                    bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(i)-bboxFaceTrie(1,3)*60/200;
                end
                if  yLeftEye(1)~=bboxFaceTrie(1,4)*70/200
                    bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yLeftEye(i)-bboxFaceTrie(1,4)*80/200;
                end
            end
            LeftYeux = imcrop(I1, 'Rectangle', bboxLeftEyeTrie);
            figure; imshow(LeftYeux); title('Detected eyes');
        end
    end
            ImFinal = imcrop(Image,bboxFaceTrie(1,:));
            ImFinal = insertShape(ImFinal, 'Rectangle', [bboxFaceTrie(1,3)*60/200,bboxFaceTrie(1,4)*80/200,20,20]);
            figure; imshow(ImFinal); title('Detected face');
        
end
%     xEye=[];
%     yEye=[];
%     for i=1:size(bboxEyeTrie,1)
%         videoFrame1 = imcrop(I, 'Rectangle', bboxEyeTrie(i,:));
%         figure; imshow(videoFrame1); title('Detected eyes');
%         xEye=[xEye bboxEyeTrie(i,1)+bboxEyeTrie(i,3)/2];
%         yEye=[yEye bboxEyeTrie(i,2)+bboxEyeTrie(i,4)/2];
%     end
%     for i=1:size(xEye,1)
%         if xEye(1)<bboxFaceTrie(1,3)/2
%             if xEye(1)~=bboxFaceTrie(1,3)*60/200
%                 bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xEye(i)-bboxFaceTrie(1,3)*60/200;
%             end
%             if  yEye(1)~=bboxFaceTrie(1,4)*50/200
%                 bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yEye(i)-bboxFaceTrie(1,4)*70/200;
%             end
%         end
%         if xEye(1)>bboxFace(1,3)/2
%             if xEye(1)~=bboxFace(1,3)*60/200
%                 bboxFace(1,1)=bboxFaceTrie(1,1)+xEye(i)-bboxFaceTrie(1,3)*140/200;
%             end
%             if  yEye(1)~=bboxFace(1,4)*50/200
%                 bboxFace(1,2)=bboxFaceTrie(1,2)+yEye(i)-bboxFaceTrie(1,4)*80/200;
%             end
%         end
%     end
%     videoFrame3 = rgb2gray(imcrop(videoFrame2,bboxFaceTrie(1,:)));
%     figure; imshow(videoFrame3); title('Detected face');
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
  