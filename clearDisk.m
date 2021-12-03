function [JJ,s] = clearDisk(JJ,s)

for i = 1:numel(s)
    A  = s(i).PixelList;
    sA = std(A);
    s(i).StdPixel = sA;
end

[~,id] = max([s.Area]);
if (s(id).Area/s(id).ConvexArea)>0.55
    x = s(id).SubarrayIdx{1,1};
    y = s(id).SubarrayIdx{1,2};
    s(id) = [];
else 
    
    [~,id] = sort([s.Area]);
    id = id(end-1);
    x = s(id).SubarrayIdx{1,1};
    y = s(id).SubarrayIdx{1,2};
    s(id) = [];
end
if exist('x','var')
    
    
    for i = 1:numel(x) 
        JJ(x(i),y) = 0;
    end
    
end
JJ = logical(JJ);
end