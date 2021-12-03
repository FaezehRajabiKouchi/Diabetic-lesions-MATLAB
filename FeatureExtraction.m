clc
clear
close all


%% Load Data
load AllDataRegion

%% Label
Label = [ss.Label]';
%% Region Characteristic

Area = [ss.Area]; %Returns a scalar that specifies the actual number of pixels in the region. 
Extend = [ss.Extent]; %Returns a scalar that specifies the ratio of pixels in the region to pixels in the total bounding box. Computed as the Area divided by the area of the bounding box.
Solidity = [ss.Solidity]; %Returns a scalar specifying the proportion of the pixels in the convex hull that are also in the region. Computed as Area/ConvexArea.
ConvexArea = [ss.ConvexArea];%eturns a scalar that specifies the number of pixels in 'ConvexImage'.
StdPixel = [ss.StdPixel];

Feature1 = [Area;Extend;Solidity;ConvexArea;StdPixel];



%% Colour Feature
for i = 1:numel(ss)
    
    I  = im2double(ss(i).I);
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    SDR = std(R(:));
    MeanR = mean(R(:));
    SDG = std(G(:));
    MeanG = mean(G(:));
    SDB = std(B(:));
    MeanB = mean(B(:));
    J = im2double(ss(i).J);
    [n,m] = size(R);
    l =0 ;
    for kk = 1:n
        for j = 1:m
            if J(kk,j,1)>.1
                l = l +1;
                JJ(l,:) = I(kk,j,:);
            end
        end
    end
    MRGB = mean(JJ);
    SDRGB = std(JJ);
    H = hist(G(:),15);
    Feature2(i,:)  = [SDR,MeanR,SDG,MeanG,SDB,MeanB,MRGB,SDRGB,H];
end

Feature = [Feature2 Feature1'];
%% Classification

A = [Feature Label];
Z = EvalSVM(A);
Z3 = EvalMLP(A);
%% FDA
N = 10;
Y = Fisher(Feature,Label,N);
A = [Y Label];
Z1 = EvalSVM(A);

%% MLP 

Z2 = EvalMLP(A);
%% Disp Result
disp( '                  Specificity   Sensitivity   Accuracy')
disp(['SVM Whit ',num2str(size(Feature,2)),' Feature: ',num2str(Z')]);
disp(['SVM Whit ',num2str(N),' Feature: ',num2str(Z1')]);
disp(['MLP Whit ',num2str(size(Feature,2)),' Feature: ',num2str(Z3)]);
disp(['MLP Whit ',num2str(N),' Feature: ',num2str(Z2)]);



