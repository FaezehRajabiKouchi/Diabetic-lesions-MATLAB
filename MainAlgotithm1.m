clc
clear
close all

%% Read Image
k = 0;
for num = 1:89


    IM = imread(['D:\Impelimention\Rajabi\images\ddb1_fundusimages\image',num2str(num),'.png']);
    
    % Resize image
    im = resizeretina(IM, 576  , 750);
    [n,m,~] = size(im);
    im1 = im;
%       figure,imshow(im)
    
    %% Pre-Procces
    % Display the superpixel boundaries overlaid on the original image.
    [L,N] = superpixels(im,3000);
    % figure
    % % BW = boundarymask(L);
    % imshow(imoverlay(im,BW,'cyan'),'InitialMagnification',67)
    
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
%     figure,imshow(I)
    IG = ((double(I(:,:,2))+ double(I(:,:,3)) )/(2*255));
    
    IG = adapthisteq(IG);
%     figure,imshow(IG)
  
    %% Segmentation
    
    mr = 0.54;
    Mask = IG>mr*max(IG(:));
    se = strel('disk', 2);
    Mask = imclose(Mask, se);
    
    [Mask,s] = Regionprops(Mask,IG,mr); 
    JJ = zeros(n,m);
    reg_maxdist = 0.05;
    XYC = reshape(round([s.Centroid]),2,[]);
    for i = 1:numel(s)
        J = regiongrowing(Mask,XYC(2,i),XYC(1,i),reg_maxdist);
        JJ = JJ + J;
    end
    JJ = logical(JJ);
    s = regionprops(JJ,'centroid','Area','BoundingBox','ConvexArea','Extent',...
        'PixelIdxList','PixelList','SubarrayIdx');
    
    [J,s] = clearDisk(JJ,s);
    
    figure,subplot(221),imshow(im)
    subplot(222),imshow(I)
    subplot(223),imshow(JJ)
    subplot(224),imshow(Mask)
    
    J = double(J);JJ(:,:,1) = J;JJ(:,:,2) = J;JJ(:,:,3) = J;
    IM = im.*uint8(JJ);
    XYC = reshape(round([s.Centroid]),2,[]);
    for i = 1:numel(s)
        s(i).I = imcrop(im,[XYC(1,i)-29,XYC(2,i)-25,59,49]);
        s(i).J = imcrop(IM,[XYC(1,i)-29,XYC(2,i)-25,59,49]);
        figure(10),subplot(2,2,1),
        imshow( im);hold on,plot(XYC(1,i),XYC(2,i),'og');
        subplot(2,2,4), imshow(s(i).I);
        subplot(2,2,2), imshow(J);
        subplot(2,2,3), imshow(s(i).J);
        im1 = im1 + 255*uint8(JJ);
        s(i).name = ['image',num2str(num)];
        Cammand = input('What is Diabet?(Diabet = 0)(Normal = 1)(else 2)');
        if (Cammand == 0 )
            s(i).Label = -1;
        elseif (Cammand == 1)
            s(i).Label = 1;
        else
            s(i).Label = 0;
        end
        
    end
   k = k + 1;
    save(['D:\Impelimention\Rajabi\C',num2str(k)],'s');
end


