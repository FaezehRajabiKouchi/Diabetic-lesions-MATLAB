function [Mask,s] = Regionprops(Mask,IG,mr)
while(1)
    s = regionprops(Mask,'centroid','Area','BoundingBox');
        
    [~,idM] = max([s.Area]);
    
    [n,m] = size(Mask);
    S = n*m;
    BC = s(idM).BoundingBox;
    SS = BC(3)*BC(4);
    nm = numel(find(Mask(:)==1));
    
    if (SS>S/16 || nm>S/7)
        mr = mr + 0.05;
        Mask = IG>mr*max(IG(:));
    else
        break;
    end
end

se = strel('disk', 1);
Mask = imopen(Mask, se);
se = strel('disk', 2);
Mask = imclose(imdilate(Mask,se), se);

s = regionprops(Mask,'centroid','Area','BoundingBox','ConvexArea','Extent',...
        'PixelIdxList','PixelList','SubarrayIdx');
end