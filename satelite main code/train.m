clc;
clear all;
close all;
a = imread('F:\2018\foreview\satellite\classification\train\water.png');
[rows colum mapp] = size(a);
k=1;
for i=1:rows %no. of columns
 disp(i);
            for j=1:colum %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('F:\2018\foreview\satellite\classification\train\water.csv',r);

a = imread('F:\2018\foreview\satellite\classification\train\crop_other.png');
[rows colum mapp] = size(a);
k=1;
for i=1:rows %no. of columns
 disp(i);
            for j=1:colum %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('F:\2018\foreview\satellite\classification\train\crop_other.csv',r);


a = imread('F:\2018\foreview\satellite\classification\train\tree.png');
[rows colum mapp] = size(a);
k=1;
for i=1:rows %no. of columns
 disp(i);
            for j=1:colum %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('F:\2018\foreview\satellite\classification\train\tree.csv',r);
a = imread('F:\2018\foreview\satellite\classification\train\plants.png');
[rows colum mapp] = size(a);
k=1;
for i=1:rows %no. of columns
 disp(i);
            for j=1:colum %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('F:\2018\foreview\satellite\classification\train\plants.csv',r);
a = imread('F:\2018\foreview\satellite\classification\train\crops.png');
[rows colum mapp] = size(a);
k=1;
for i=1:rows %no. of columns
 disp(i);
            for j=1:colum %no. of rows
          
            
            r(k,1)=a(i,j,1);
            r(k,2)=a(i,j,2);
            r(k,3)=a(i,j,3);
              k=k+1; 
            end;
        end;
csvwrite('F:\2018\foreview\satellite\classification\train\crops.csv',r);



