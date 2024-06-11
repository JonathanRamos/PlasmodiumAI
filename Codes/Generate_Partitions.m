clc
clear all
% 
% DatasetName = '\..\Datasets\BBBC\';
% pathName = strcat(pwd, DatasetName);

casos = readtable("AuxiliaryFiles\BalancedBBBC.csv");
casos2 = readtable("AuxiliaryFiles\BalancedFIOCRUZ.csv");


Exam = casos.Exame;
Class(size(Exam,1)+size(casos2),1) = false; 
Image = casos.ImagePathName;
tam1=size(Exam,1);
for i=1:tam1
    i
   if (strcmp(char(casos.ObjectsCategory(i)), 'red blood cell'))
       Class(i) = false;
       exam = strcat(pwd, "\..\Datasets\ROIS\BBBC\Uninfected\", num2str(casos.Exame(i)), ...
           '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
       imread(exam);
   else
       Class(i) = true;
       exam = strcat(pwd, "\..\Datasets\ROIS\BBBC\Infected\", num2str(casos.Exame(i)),...
           '-', num2str(casos.Case(i)),'-', num2str(i), '.bmp');
       imread(exam);
   end
   Image{i} = exam;
end
ExamBackup = Exam;
clear Exam
Exam = casos2.Image;
size(Exam,1)
for i=1:size(Exam,1)
    i+1328
    if (casos2.Class(i) == 0)
       Class(i) = false;
       exam = strcat(pwd, "\..\Datasets\ROIS\FIOCRUZ\Uninfected\", num2str(casos2.Image(i)), ...
           '-', num2str(casos2.Case(i)),'-', num2str(i), '.bmp');
       imread(exam);
    else
       Class(i) = true;
       exam = strcat(pwd, "\..\Datasets\ROIS\FIOCRUZ\Infected\", num2str(casos2.Image(i)),...
           '-', num2str(casos2.Case(i)),'-', num2str(i), '.bmp');
       imread(exam);
    end
   Exam(i) = i+1328;
    Image{i+tam1} = exam;
end
    
Exam = [ExamBackup;Exam];   

cvp{100} = 0;

unicos = unique(Exam);

tamanho(size(unicos)) = false;


for k=1:100
    k
    clear Train Test tb filename
    Train(size(Exam,1),1) = false;
    Test(size(Exam,1),1) = false;
    
    if (k == 1)
        cvp{k} = cvpartition(tamanho,'Holdout', 0.2);
    else
        cont = 0;
        while 1
            cvp{k} = repartition(cvp{k-1});
            for kk=1:k-1
                stats = isequal(cvp{kk}.test, cvp{k}.test);
            end
            if (~stats)
                break;
            end
            cont = cont + 1;
        end
    end
    
    
    cvpTrain = cvp{k}.training;
    cvpTest = cvp{k}.test;
    
%     [sum(cvpTrain) sum(cvpTest)]
    
    for j = 1:size(unicos)
        for kk = 1:size(Exam,1)
            if (Exam(kk) == unicos(j) && cvpTrain(j) == 1)
                Train(kk) = true;
            elseif (Exam(kk) == unicos(j) && cvpTest(j) == 1)
                Test(kk) = true;
            end
        end
       
    end
    
    
    tb = table(Image, Class, Train, Test);
    filename = strcat(pwd, '\..\Partitions\', num2str(k,'%2d'), '.csv');
    writetable(tb,filename);
end

