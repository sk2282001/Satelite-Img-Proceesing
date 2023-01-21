
clear all;
close all;
clc;

[baseName, folder] = uigetfile({'*.csv';'*.*';},'Seleect Training Data Set');
fullFileName = fullfile(folder, baseName);
file_ind = fopen(fullFileName); %training areas total no of classes are 5

C = textscan(file_ind,'%f%f%f%s','delimiter',',');  % Import data
fclose(file_ind);
physchars = [C{1} C{2} C{3}]; % inputs to neural network

[baseName, folder] = uigetfile({'*.png';'*.jpeg';'*.jpg';'*.*';'*.tiff';'*.tif'},'Select Image File');
fullFileName = fullfile(folder, baseName);
image=imread(fullFileName);
[rows colums mapping]=size(image);

Crops = strncmpi(C{4}, 'crops', 1);
Water = strncmpi(C{4}, 'water', 1);
Crop_other = strncmpi(C{4}, 'crop_other', 1);
Trees = strncmpi(C{4}, 'tree', 1);
Plants = strncmpi(C{4}, 'plants', 1);

class = double([ Crops Water Crop_other Trees Plants]); 
physchars = physchars';
class = class';
rand('twister', 491218382);
net = newff(physchars,class,15);
[net,tr] = train(net,physchars,class);


a = image;
k=1;
for i=1:rows %no. of columns
 %disp(i);
            for j=1:colums %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('temp.csv',r);
fid1 = fopen('temp.csv');% entire image
C1 = textscan(fid1,'%f%f%f','delimiter',',');  % Import data
fclose(fid1);
physchars1 = [C1{1} C1{2} C1{3}]; 
physchars1 = physchars1';
testInputs = physchars1;


out_imag_resu = sim(net,testInputs);  
bdclose('all')

out_imag_resu=out_imag_resu';
  S=size(testInputs);
  length=S(2);
  
  Label_set1 = 0;
  Label_set2 = 0;
  Label_set3 = 0;
  Label_set4 = 0;
  Label_set5 = 0;
 for i=1:length
     i
    if  out_imag_resu(i,1,1)>out_imag_resu(i,2,1)&&out_imag_resu(i,1,1)>out_imag_resu(i,3,1)&&out_imag_resu(i,1,1)>out_imag_resu(i,4,1)&&out_imag_resu(i,1,1)>out_imag_resu(i,5,1)
        matrix_data(i,1)=1;
        matrix_data(i,2)=0;
        matrix_data(i,3)=0;
        matrix_data(i,4)=0;
        matrix_data(i,5)=0;

  
       
        r(i,1)=128;
        r(i,2)=128;
        r(i,3)=128;
        Label_set1 = Label_set1 + 1;
    end;
    if  out_imag_resu(i,2,1)>out_imag_resu(i,1,1)&&out_imag_resu(i,2,1)>out_imag_resu(i,3,1)&&out_imag_resu(i,2,1)>out_imag_resu(i,4,1)&&out_imag_resu(i,2,1)>out_imag_resu(i,5,1)
        

        matrix_data(i,1)=0;
        matrix_data(i,2)=1;
        matrix_data(i,3)=0;
        matrix_data(i,4)=0;
        matrix_data(i,5)=0;
        
        r(i,1)=0;
        r(i,2)=0;
        r(i,3)=255;
        Label_set2 = Label_set2 + 1;
    end;
    if  out_imag_resu(i,3,1)>out_imag_resu(i,1,1)&&out_imag_resu(i,3,1)>out_imag_resu(i,2,1)&&out_imag_resu(i,3,1)>out_imag_resu(i,4,1)&&out_imag_resu(i,3,1)>out_imag_resu(i,5,1)
        matrix_data(i,1)=0;
        matrix_data(i,2)=0;
        matrix_data(i,3)=1;
        matrix_data(i,4)=0;
        matrix_data(i,5)=0;
        
        r(i,1)=255;%Red
        r(i,2)=0;%green
        r(i,3)=0;%blue
        Label_set3 = Label_set3 + 1;;
    end;
    if  out_imag_resu(i,4,1)>out_imag_resu(i,1,1)&&out_imag_resu(i,4,1)>out_imag_resu(i,3,1)&&out_imag_resu(i,4,1)>out_imag_resu(i,2,1)&&out_imag_resu(i,4,1)>out_imag_resu(i,5,1)

        matrix_data(i,1)=0;
        matrix_data(i,2)=0;
        matrix_data(i,3)=0;
        matrix_data(i,4)=1;
        matrix_data(i,5)=0;
        
        r(i,1)=0;%Red
        r(i,2)=128;%Green
        r(i,3)=0;%Blue
        Label_set4 = Label_set4 + 1;
    end;
    if  out_imag_resu(i,5,1)>out_imag_resu(i,1,1)&&out_imag_resu(i,5,1)>out_imag_resu(i,3,1)&&out_imag_resu(i,5,1)>out_imag_resu(i,2,1)&&out_imag_resu(i,5,1)>out_imag_resu(i,4,1)

        matrix_data(i,1)=0;
        matrix_data(i,2)=0;
        matrix_data(i,3)=0;
        matrix_data(i,4)=0;
        matrix_data(i,5)=1;
        
        r(i,1)=128;%Red
        r(i,2)=128;%Green
        r(i,3)=0;%Blue
        Label_set5 = Label_set5 + 1;
    end;
    
end;    
%% Converting csv file into RGB image matrix
%394*967
% 180*388
  k=1;
        for i=1:rows %no. of columns
 disp(i);
            for j=1:colums %no. of rows
          
            
            a(i,j,1)=r(k,1);
            a(i,j,2)=r(k,2);
            a(i,j,3)=r(k,3);
              k=k+1; 
            end;
        end;
  imshow(a);


l1 = double((Label_set1/(rows*colums))*100);
l2 = (Label_set2/(rows*colums))*100;
l3 = double((Label_set3/(rows*colums))*100);
l4 = double((Label_set4/(rows*colums))*100);
l5 = double((Label_set5/(rows*colums))*100);

