function [ImFinal ,normalise]=Normalisation(I)
    normalise=false;
    if ndims(I)==3
        Image=im2double(rgb2gray(I));
    else
        Image=im2double(I);
    end 
    
    ImageavecContraste=imadjust(Image);
    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();
    % Run the face detector.
    bboxFace = step(faceDetector, Image);
    bboxFaceTrie=[];
    if ~isempty(bboxFace)

        for i=1:size(bboxFace,1)
            if bboxFace(i,3)>0.1*size(ImageavecContraste,1) && bboxFace(i,4)>0.1*size(ImageavecContraste,2)
                %bboxPoints = bbox2points(bboxFace(1, :));
                bboxFaceTrie=[bboxFaceTrie ;bboxFace(i, :)];
            end
        end
    end
    if ~isempty(bboxFaceTrie)
        %Augmente le rectangle de la bbox
        bboxFaceTrie(1,2)=bboxFaceTrie(1,2)-bboxFaceTrie(1,4)*3/16;
        bboxFaceTrie(1,4)=bboxFaceTrie(1,4)*19/16;

        bboxFaceTrie(1,1)=bboxFaceTrie(1,1)-bboxFaceTrie(1,3)*1/16;
        bboxFaceTrie(1,3)=bboxFaceTrie(1,3)*18/16;

        %Image rogné du visage 
        I=im2double(imcrop(ImageavecContraste,bboxFaceTrie(1,:)));

        I1=I;
        eyeDetector = vision.CascadeObjectDetector('EyePairBig');
        bboxSetEye = step(eyeDetector,I1);
        bboxSetEyeTrie=[];
        %Trie les yeux qu'ila detecté
        if ~isempty(bboxSetEye)
            bboxSetEyeTrie=[];
            for i=1:size(bboxSetEye,1)
                if bboxSetEye(i,3)>bboxFaceTrie(1,3)/10 && bboxSetEye(i,4)>bboxFaceTrie(1,4)/12
                    bboxSetEyeTrie = [bboxSetEyeTrie ; bboxSetEye(i, :)];
                end
            end
        end
        if ~isempty(bboxSetEyeTrie)
            PairYeux = imcrop(I, 'Rectangle', bboxSetEyeTrie(1,:));
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

                angle=atan((yRightEye-yLeftEye)/(xRightEye-xLeftEye));
                if angle >5*pi/180
                    ImageavecContraste=imrotate(ImageavecContraste,-angle);
                end

                bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(1)-bboxFaceTrie(1,3)*60/200;
                bboxFaceTrie(1,3)=xRightEye*200/140;
                bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(1)-bboxFaceTrie(1,4)*80/200;
                normalise=true;
            elseif ~isempty(xRightEye)
                for i=1:size(xRightEye,1)
                    if xRightEye(1)~=bboxFace(1,3)*60/200
                        bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xRightEye(i)-bboxFaceTrie(1,3)*140/200;
                    end
                    if  yRightEye(1)~=bboxFace(1,4)*50/200
                        bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(i)-bboxFaceTrie(1,4)*80/200;
                    end
                end
                normalise=true;
            elseif ~isempty(xLeftEye)
                for i=1:size(xLeftEye,1)
                    if xLeftEye(1)~=bboxFaceTrie(1,3)*60/200
                        bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(i)-bboxFaceTrie(1,3)*60/200;
                    end
                    if  yLeftEye(1)~=bboxFaceTrie(1,4)*70/200
                        bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yLeftEye(i)-bboxFaceTrie(1,4)*80/200;
                    end
                end
                normalise=true;
            end


   
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

                angle=atan((yRightEye-yLeftEye)/(xRightEye-xLeftEye));

                if angle >5*pi/180
                    Image=imrotate(Image,-angle);
                end

                bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(1)-bboxFaceTrie(1,3)*60/200;
                bboxFaceTrie(1,3)=xRightEye*200/140;
                bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(1)-bboxFaceTrie(1,4)*80/200;
                normalise=true;
            elseif ~isempty(xRightEye)
                for i=1:size(xRightEye,1)
                    if xRightEye(1)~=bboxFace(1,3)*60/200
                        bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xRightEye(i)-bboxFaceTrie(1,3)*140/200;
                    end
                    if  yRightEye(1)~=bboxFace(1,4)*50/200
                        bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yRightEye(i)-bboxFaceTrie(1,4)*80/200;
                    end
                end
                normalise=true;
            elseif ~isempty(xLeftEye)
                for i=1:size(xLeftEye,1)
                    if xLeftEye(1)~=bboxFaceTrie(1,3)*60/200
                        bboxFaceTrie(1,1)=bboxFaceTrie(1,1)+xLeftEye(i)-bboxFaceTrie(1,3)*60/200;
                    end
                    if  yLeftEye(1)~=bboxFaceTrie(1,4)*70/200
                        bboxFaceTrie(1,2)=bboxFaceTrie(1,2)+yLeftEye(i)-bboxFaceTrie(1,4)*80/200;
                    end
                end
                normalise=true;
            end
        end
        ImFinal = imcrop(Image,bboxFaceTrie(1,:));
   
    else
        ImFinal=Image;
    end
    
end