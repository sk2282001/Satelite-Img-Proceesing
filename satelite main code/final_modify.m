clc;
clear all;
close all;
[FileName,PathName] = uigetfile(...
                            {'*.jpg;*.tif;*.png;*.gif','All Image Files';...
                            '*.*','All Files'},...
                            'Select Images');
 I = strcat(PathName,FileName);
 im = imread(I);
 im=imresize(im,[300 300]);
 imgl=im;
 
 
 figure;
 subplot(2,2,1); imshow(im);
 [m,n,dim]=size(im);
 if dim==3
     im=rgb2gray(im);
 else
     im=im;
 end
 subplot(2,2,2); imshow(im);
 im=im2double(im);
 level=.4;level1=.6;
 img = imnoise(im,'speckle',level);
 imwrite(img,'speckle_image.jpg');
 d = edge(im,'canny',level1);                    
subplot(2,2,3); imshow(d);      
ds = bwareaopen(d,40);                     
subplot(2,2,4); imshow(ds);
iout = d;
bin_val = ds;
bw = im2bw(im,0.43);
se = strel('disk',5);
BW_erod = imopen(bw,se);
se = strel('disk',5);
BW_dil = imdilate(BW_erod,se);
L2=bwlabel(BW_erod,8);

[golay,L,N,A] = bwboundaries(L2);
figure; imshow(L2);title('boundary Detected');
hold on
for k=1:length(golay),

if(~sum(A(k,:)))
boundary = golay{k};
plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);
end

end
hold off
BW2 = bwmorph(L2,'remove');
figure;
imshow(BW2);
title('boundary scaling');
BW3 = bwmorph(BW2,'skel',Inf);
figure;
imshow(BW3);
title('thin extraxt');
golay = bwboundaries(BW3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=m;N=n;
sig_orig=im;
sigma = 25;             
noise_typ = 0;    
W = 4;                                         
if noise_typ==0,
h = 2.08*sigma;           
else
h = 2.48*sigma;           
end;
boun_size = 7;               
V = 2;                   
if noise_typ == 0,                          
    im_data = sig_orig + sigma*randn(M,N); 
else    
    [img_noise,PS]=psdnoise(M,N,13.2,1);
    im_data = sig_orig + sigma*img_noise;  
end;
 
im_data = bound_extension(im_data,W,W,'mirror');
N=N+2*W;
M=M+2*W;
Bs=(2*W+1)^2;
%%%%%%%%%% for bi-square
 weighting_function = @(r) (r<h).*(1-(r/h).^2).^8; 
if noise_typ == 1,        
    data_pre_process=real(ifft2(fft2(im_data(W+1:end-W,W+1:end-W))./max(1e-4,abs(PS)).^0.5));
    data_pre_process = bound_extension(data_pre_process,W,W,'mirror');

else
    data_pre_process=im_data; 
end;
    sig_est = zeros(size(im_data,1),size(im_data,2),(2*V+1)^2);

factor_value = zeros(size(im_data));
factor_value_seq = zeros(size(im_data));      
figure;
imshow(data_pre_process);
golay = sgolayfilt(img,3,41,[],2);
Medi = medfilt2(img,[3 3]);
coeff_set = ndwt2(im,8,'haar');
coeff_set1 = ndwt2(golay,8,'haar');
coeff_set2 = ndwt2(Medi,8,'haar');
[threshtemp,noiseratio] = subf(img,coeff_set,coeff_set1,coeff_set2,2);
thresh = threshtemp(noiseratio==max(max(noiseratio)));
thresh = max(max(thresh));
[thresh,MSE,PSNR,img1] = subfunction(img,coeff_set,coeff_set1,coeff_set2,2,thresh);
figure;
subplot(1,2,1);imshow(img);title('Sparse Speckled Image');
subplot(1,2,2);imshow(img1);title('Hyper De-Speckled Image');
xlabel(['PSNR = ',num2str(PSNR),' dB','  ','MSE = ',num2str(MSE)]);
nBins=5;
winSize=7;
nClass=6;
outImg = subfun(imgl, nBins, winSize, nClass);

%Displaying Output
figure;imshow(outImg);title('Color MAP');
colormap('default');
figure;
subplot(1,3,1);imshow(im);title('Sparse Speckled Image');
subplot(1,3,2);imshow(golay);title('Filtered Image');
subplot(1,3,3);imshow(Medi);title('Adaptive Filetered Image');
[ind,maap]=sim_ind(img1,img);
fprintf('SSIM ind=%f %',ind*100);
fprintf('\n\n');
Io=img1;If=im;
ss=ind*.5/.85;
[a,b] = size(Io);
o=0;
p=0;
for i = 1:a
for j = 1:b
if(((i+1)<=a) && ((j+1)<=b))
r= abs(Io(i,j) - Io(i+1,j));
t= abs(Io(i,j) - Io(i,j+1));
l=abs(If(i,j) - If(i+1,j));
u=abs(If(i,j) - If(i,j+1));
o = o+ r + t;
p= p +l+ u;
end
end
end
epi_ind =(o./p );
fprintf('EPI ind=%f %',epi_ind);
fprintf('\n\n');
fprintf('SSI ind=%f %',ss);
fprintf('\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[baseName, folder] = uigetfile({'*.csv';'*.*';},'Seleect Training Data Set');
fullFileName = fullfile(folder, baseName);
file_ind = fopen(fullFileName); %training areas total no of classes are 5

C = textscan(file_ind,'%f%f%f%s','delimiter',',');  % Import data
fclose(file_ind);
physchars = [C{1} C{2} C{3}]; % inputs to neural network


image=imgl;
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

fprintf('Percentage of Gray(Lable1, Crops): %f\n',l1);
fprintf('Percentage of Blue(Lable2, Water): %f\n',l2);
fprintf('Percentage of Red(Lable3, Crop_other): %f\n',l3);
fprintf('Percentage of Green(Lable4, Trees): %f\n',l4);
fprintf('Percentage of Yellow(Lable5, Plants): %f\n',l5);
