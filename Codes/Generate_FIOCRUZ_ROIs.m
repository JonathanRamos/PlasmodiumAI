clc
clear all

basePath = pwd;

myPath = strcat(basePath, "\AuxiliaryFiles\BalancedFIOCRUZ.csv");
casos = readtable(myPath);
sizesFIOCRUZ(220,6) = 0;

contador = 1;
for i=1:size(casos,1)
    i
    clear fName csv I
    formatSpec = '%.2d';
    jpgName = strcat(basePath, "\..\Datasets\Exams\FIOCRUZ\", num2str(casos.Image(i),formatSpec), ".jpg");
    I = imread(jpgName);

    rect = [casos.MinimumC(i), casos.MinimumR(i),casos.MaximumC(i), casos.MaximumR(i)];
    rgbCropped = imcrop(I,rect);
    sizesFIOCRUZ(contador, 1:3) = size(rgbCropped);
       
%     imshow(rgbCropped);
    borderInc = 2;
    Labels(size(rgbCropped,1), size(rgbCropped,2)) = uint8(0);
    Labels(:,1:borderInc) = 1;
    Labels(1:borderInc,:) = 1;
    Labels(:,end-borderInc:end) = 1;
    Labels(end-borderInc:end,:) = 1;
    x1 = round(size(rgbCropped,2)/2);
    x2 = round(size(rgbCropped,1)/2);
    percentage = 0.9;

    if (x1 > x2)
       inc = round(percentage*x2);
    else
       inc = round(percentage*x1);
    end
    Labels(x1-inc:x1+inc, x2-inc:x2+inc) = 2;

    RGB = insertShape(rgbCropped, "circle",[x1 x2 inc],LineWidth=4);
    t1 = squeeze(RGB(:,:,1)) == 255;
    t2 = squeeze(RGB(:,:,2)) == 255;
    t3 = squeeze(RGB(:,:,3)) == 0;
    t4 = t1&t2&t3;
    gray1 = imfill(t4, 'holes');
    box = regionprops(gray1,'BoundingBox');
    rect = [box.BoundingBox];
    rgbCropped = imcrop(rgbCropped,rect);
    gray1 = imcrop(gray1,rect);

    a = rgbCropped(:,:,1);
%     a = (a - (min(a(:)) + 1))*(255/(max(a(:))-min(a(:)) + 1));
    a(gray1~=1) = 0;
    rgbCropped(:,:,1) = a;
    b = rgbCropped(:,:,2);
%     b = (b - (min(b(:)) + 1))*(255/(max(b(:))-min(b(:)) + 1));
    b(gray1~=1) = 0;
    rgbCropped(:,:,2) = b;

    c = rgbCropped(:,:,3);
%     c = (c - (min(c(:)) + 1))*(255/(max(c(:))-min(c(:)) + 1));
    c(gray1~=1) = 0;
    rgbCropped(:,:,3) = c;
            
%             imshow(rgbCropped);
%             return;
        sizesFIOCRUZ(contador, 4:6) = size(rgbCropped);


        if (casos.Class(i) == 0)
                  filenameSave = strcat(basePath, '\..\Datasets\ROIs\FIOCRUZ\Uninfected\', num2str(casos.Image(i)), '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
%                  imwrite(rgbCropped, filenameSave);
%           rectangle('Position', rect,...
%           'EdgeColor','b', 'LineWidth', 2); hold on
          
        else
                filenameSave = strcat(basePath, '\..\Datasets\ROIs\FIOCRUZ\Infected\', num2str(casos.Image(i)), '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
%                  imwrite(rgbCropped, filenameSave);
%             rectangle('Position', rect,...
%           'EdgeColor','r', 'LineWidth', 2); hold on
        end
   contador = contador + 1;
end

