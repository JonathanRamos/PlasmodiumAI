clc
clear all
myPath = pwd;
myFile = strcat(pwd, "\AuxiliaryFiles\test.json");
myFile2 = strcat(pwd, "\AuxiliaryFiles\training.json");

myFileName = strcat(myFile);
myFileName2 = strcat(myFile2);

fid = fopen(myFileName); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 

fid2 = fopen(myFileName2); 
raw2 = fread(fid2,inf); 
str2 = char(raw2'); 
fclose(fid2); 

dados = [jsondecode(str); jsondecode(str2)];
tamBase = 86035;

ImageCheckSum(tamBase, 1) = "";
ImagePathName(tamBase, 1) = "";
ImageShapeR(tamBase, 1)   = 0;
ImageShapeC(tamBase, 1)   = 0;
ImageShapeChannels(tamBase, 1) = 0;
ObjectsCategory(tamBase, 1) = "";
ObjectsBoundingBoxMinimumR(tamBase, 1) = 0;
ObjectsBoundingBoxMinimumC(tamBase, 1) = 0;
ObjectsBoundingBoxMaximumR(tamBase, 1) = 0;
ObjectsBoundingBoxMaximumC(tamBase, 1) = 0;
Case(tamBase, 1) = 0;
Class(tamBase, 1) = 0;
Exame(tamBase, 1) = 0;

contador = 1;
tam1 = size(dados,1);

ExamsClassCounting(size(dados,1),4) = 0;

% Teste
for i=1:size(dados,1)
    clear data2
    data2 = dados(i).objects;
    ExamsClassCounting(i,3) = size(data2,1);
    ExamsClassCounting(i,4) = i;
    
    for j=1:size(data2,1)
        Exame(contador) = i;
        Case(contador) = j;
        ImageCheckSum(contador)      = dados(i).image.checksum;
        ImagePathName(contador)      = dados(i).image.pathname;
        ImageShapeR(contador)        = dados(i).image.shape.r;
        ImageShapeC(contador)        = dados(i).image.shape.c;
        ImageShapeChannels(contador) = dados(i).image.shape.channels;
    
        ObjectsCategory(contador)           = data2(j).category;
        ObjectsBoundingBoxMinimumR(contador) = data2(j).bounding_box.minimum.r;
        ObjectsBoundingBoxMinimumC(contador) = data2(j).bounding_box.minimum.c;
        ObjectsBoundingBoxMaximumR(contador) = data2(j).bounding_box.maximum.r;
        ObjectsBoundingBoxMaximumC(contador) = data2(j).bounding_box.maximum.c;
        
        
        if (strcmp( char(data2(j).category), "red blood cell")) 
            Class(contador) = 0;
            ExamsClassCounting(i,1) = ExamsClassCounting(i,1) + 1;
        else
            Class(contador) = 1;
            ExamsClassCounting(i,2) = ExamsClassCounting(i,2) + 1;
        end
        contador = contador + 1;
    end
end



cases = sortrows(table(Exame,Case, Class,...
    ImageCheckSum,...
    ImagePathName,...
    ImageShapeR,...
    ImageShapeC,...
    ImageShapeChannels,...
    ObjectsBoundingBoxMinimumR, ...
    ObjectsBoundingBoxMinimumC,...
    ObjectsBoundingBoxMaximumR,...
    ObjectsBoundingBoxMaximumC,...
    ObjectsCategory),1);



writetable(cases,'AuxiliaryFiles\CasesBBBC.csv');
save(strcat(myPath, "\AuxiliaryFiles\ExamsClassCounting.mat"), "ExamsClassCounting");


%% BALANCE THE DATASET

clc
clear all


myPath = pwd;
myFile = "\AuxiliaryFiles\CasesBBBC.csv";

casos = readtable( strcat(myPath, myFile) );

% pathName = char( casos.ImagePathName(1) );
% nomeArquivo = strcat(myPath, '\..\Datasets\', pathName(9:end));

load(strcat(myPath, '\AuxiliaryFiles\ExamsClassCounting.mat'));

% sum(casos.Class == 1)
% sum(ExamsClassCounting(:,2))
% return

selected = casos(casos.Exame == 0, :);
cont1 = 0;
cont2 = 0;
cont = 0;
for i=1:size(ExamsClassCounting, 1)
    clear ExamCases infected uninfected selectedTemp
    ExamCases = casos(ExamsClassCounting(i, 4) == casos.Exame, :);
    %if there is at least one infected exam
    if (ExamsClassCounting(i, 2) > 0)
%         casos.Exame ==i;
        infected = ExamCases(ExamCases.Class == 1, :);
        ExamCases(ExamCases.Class == 1, :) = [];
        uninfected = ExamCases(ExamCases.Class == 0, :);
        % Randonly chooses cases
        uninfected = ExamCases(randsample(1:size(uninfected, 1), size(infected, 1)), :);
     
        selectedTemp = [infected; uninfected];
        selected = [selected; selectedTemp];
        [i, sum(selected.Class == 0), sum(selected.Class == 1), size(infected, 1), size(uninfected, 1)]
        
    end
end

sum(selected.Class == 0)
sum(selected.Class == 1)

writetable(selected, strcat( myPath, '\AuxiliaryFiles\BalancedBBBC.csv') );

%%
clc
clear all
myPath = pwd;
myFile = strcat(myPath, "\AuxiliaryFiles\BalancedBBBC.csv");
casos = readtable(myFile);
sizesBBBC(6002,6) = 0;
cont = 1;
%  pathName = char(casos.ImagePathName(9));
%     nomeArquivo = strcat(myPath, '\..\Datasets\Exams\BBBC\', pathName(9:end));
%     I = imread(nomeArquivo);
%     imshow(I, []); hold on
for i=1:size(casos, 1)
    
    pos = uint8( casos.Exame(i) );
    [i]
     
    clear pathName nomeArquivo I  rect filenameSave rgbCropped
    pathName = char(casos.ImagePathName(i));
    nomeArquivo = strcat(myPath, '\..\Datasets\Exams\BBBC\', pathName(9:end));
    I = imread(nomeArquivo);
%     imshow(I, []); hold on
%     return

    rect = [ casos.ObjectsBoundingBoxMinimumC(i), casos.ObjectsBoundingBoxMinimumR(i)... 
       casos.ObjectsBoundingBoxMaximumC(i)-casos.ObjectsBoundingBoxMinimumC(i), ...
       casos.ObjectsBoundingBoxMaximumR(i) - casos.ObjectsBoundingBoxMinimumR(i)];

        rgbCropped = imcrop(I,rect);
        sizesBBBC(cont, 1:3) = size(rgbCropped);
        
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

            RGB = insertShape(rgbCropped, "circle",[x1 x2 inc],LineWidth=5);
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
%             a = (a - (min(a(:)) + 1))*(255/(max(a(:))-min(a(:)) + 1));
            a(gray1~=1) = 0;
            rgbCropped(:,:,1) = a;
            b = rgbCropped(:,:,2);
%             b = (b - (min(b(:)) + 1))*(255/(max(b(:))-min(b(:)) + 1));
            b(gray1~=1) = 0;
            rgbCropped(:,:,2) = b;
            
            c = rgbCropped(:,:,3);
%             c = (c - (min(c(:)) + 1))*(255/(max(c(:))-min(c(:)) + 1));
            c(gray1~=1) = 0;
            rgbCropped(:,:,3) = c;
            
%             imshow(rgbCropped);
        

        sizesBBBC(cont, 4:6) = size(rgbCropped);
        cont = cont + 1;
        if (casos.Class(i) == 0)
                  filenameSave = strcat(myPath, '\..\Datasets\ROIs\BBBC\Uninfected\', num2str(casos.Exame(i)), '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
%                  imwrite(rgbCropped, filenameSave);
%           rectangle('Position', rect,...
%           'EdgeColor','b', 'LineWidth', 2); hold on
          
        else
                filenameSave = strcat(myPath, '\..\Datasets\ROIs\BBBC\Infected\', num2str(casos.Exame(i)), '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
%                  imwrite(rgbCropped, filenameSave);
%             rectangle('Position', rect,...
%           'EdgeColor','r', 'LineWidth', 2); hold on
        end
end

%% Get images sizes
clc
clear all
myPath = pwd;
myFile = strcat(myPath, "\AuxiliaryFiles\BalancedBBBC.csv");
myFile2 = strcat(myPath, "\AuxiliaryFiles\BalancedFIOCRUZ.csv");
casos = readtable(myFile);
casos2 = readtable(myFile2);

unicos = unique(casos.ImagePathName);

unicos2 = unique(casos2.Image);

resolutions(size(unicos, 1), 3) = 0;
resolutions2(size(unicos2, 1), 3) = 0;

for i =1:size(unicos, 1)
    i
    clear pathName nomeArquivo I
    pathName = char(unicos(i));
    nomeArquivo = strcat(myPath, '\..\Datasets\Exams\BBBC\', pathName(9:end));
    I = imread(nomeArquivo);
    resolutions(i, :) = size(I);
end
resolutionsBBBC = [mean(resolutions); std(resolutions)]

for i =1:size(unicos2, 1)
    i
    clear pathName nomeArquivo I
    pathName = num2str(unicos2(i), "%.2d");
    nomeArquivo = strcat(myPath, '\..\Datasets\Exams\FIOCRUZ\', pathName, ".jpg");
    I = imread(nomeArquivo);
    resolutions2(i, :) = size(I);
end

resolutionsFIOCRUZ = [mean(resolutions2); std(resolutions2)]

resolutionsALL = [mean([resolutions; resolutions2]); std([resolutions; resolutions2])]

%% 

clc
clear all
myPath = pwd;
myFile = strcat(myPath, "\AuxiliaryFiles\sizesBBBC.mat");
myFile2 = strcat(myPath, "\AuxiliaryFiles\sizesFIOCRUZ.mat");
load(myFile);
load(myFile2);

statsBBBC1 = [mean(sizesBBBC(:,1:3)), std(sizesBBBC(:,1:3))];
statsBBBC2 = [mean(sizesBBBC(:,4:6)), std(sizesBBBC(:,4:6))];

statsFIOCRUZ1 = [mean(sizesFIOCRUZ(:,1:3)), std(sizesFIOCRUZ(:,1:3))];
statsFIOCRUZ2 = [mean(sizesFIOCRUZ(:,4:6)), std(sizesFIOCRUZ(:,4:6))];

sizesAll = [sizesBBBC; sizesFIOCRUZ];

stats1 = [mean(sizesAll(:,1:3)), std(sizesAll(:,1:3))];
stats2 = [mean(sizesAll(:,4:6)), std(sizesAll(:,4:6))];


