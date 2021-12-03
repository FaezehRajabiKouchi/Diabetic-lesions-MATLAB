clc
clear
close all

%% Read Image
num = 3;
IM = imread(['D:\Impelimention\Rajabi\images\ddb1_fundusimages\image',...
     num2str(num),'.png']);
[n,m,k] = size(IM);
% Resize image
im = resizeretina(IM, 576  , 750);
figure,imshow(im)

%% Pre-Procces
% Display the superpixel boundaries overlaid on the original image.
[L,N] = superpixels(im,3000);
figure
BW = boundarymask(L);
imshow(imoverlay(im,BW,'cyan'),'InitialMagnification',67)

outputImage = zeros(size(im),'like',im);
idx = label2idx(L);
numRows = size(im,1);
numCols = size(im,2);
for labelVal = 1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(im(redIdx));
    outputImage(greenIdx) = mean(im(greenIdx));
    outputImage(blueIdx) = mean(im(blueIdx));
end

figure
imshow(outputImage,'InitialMagnification',67)
% IG = rgb2gray(im2double(outputImage));
IG = im2double(outputImage(:,:,2));
Tr = 0.32;
figure,imshow(IG),Mask = IG>Tr;
M = im2double(Mask);
IG = IG.*M;
figure,imshow(Mask)
%% Segmentation 
s = regionprops(Mask,'centroid');
XYC = reshape(round([s.Centroid]),2,[]);
reg_maxdist = 0.05;
for i = 1:numel(s)
    J = regiongrowing( M,XYC(2,i),XYC(1,i),reg_maxdist);
    figure(6),subplot(1,3,1), imshow( IG);hold on,plot(XYC(1,i),XYC(2,i),'og')

J = double(J);
subplot(1,3,2), imshow(J);

subplot(1,3,3), imshow(IG+J);
end
%% Feature Extraction  







%% Classification by SVM or MLP

