clc
clear
close all
k = 0;
b = 89;
for num = k+1:b
%     num = 1;
    k = k + 1;
    IM = imread(['D:\Impelimention\Rajabi\images\ddb1_fundusimages\image',...
        num2str(num),'.png']);
    [n,m,~] = size(IM);
    % Resize image
    im = resizeretina(IM, 576  , 750);
    % figure,imshow(im)
    
    %% Pre-Procces
    % Display the superpixel boundaries overlaid on the original image.
    [L,N] = superpixels(im,3000);
   
    I = zeros(size(im),'like',im);
    idx = label2idx(L);
    numRows = size(im,1);
    numCols = size(im,2);
    for labelVal = 1:N
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+numRows*numCols;
        blueIdx = idx{labelVal}+2*numRows*numCols;
        I(redIdx) = 1*max(im(redIdx));
        I(greenIdx) = 2*max(im(greenIdx));
        I(blueIdx) = 2*max(im(blueIdx));
    end
    
    IG = ((double(I(:,:,2))+ double(I(:,:,3)) )/(2*255));
    
    IG = adapthisteq(IG);

    
    
    %% Segmentation
    
    mr = 0.55;
    Mask = IG>mr*max(IG(:));
    se = strel('disk', 2);
    Mask = imclose(Mask, se);
    [Mask,s] = Regionprops(Mask,IG,mr); 
    
    
    for i = 1:numel(s)
        A  = s(i).PixelList;
        sA = std(A);
        if numel(sA)==1
            sA = A;
        end
        Am = max(sA(1)/sA(2),sA(2)/sA(1));
        s(i).StdPixel = Am;
    end
    MN = Mask;
    [~,id] = max([s.Area]);
    if s(id).StdPixel<1.4
        x = s(id).SubarrayIdx{1,1};
        y = s(id).SubarrayIdx{1,2};
        s(id) = [];
      
    end
    if exist('x','var') 
        
        
    for i = 1:numel(x)
        
        Mask(x(i),y) = 0;
    end
    clear x
    end
    figure,subplot(221),imshow(im)
    subplot(222),imshow(I)
    subplot(223),imshow(MN)
    subplot(224),imshow(Mask)
end