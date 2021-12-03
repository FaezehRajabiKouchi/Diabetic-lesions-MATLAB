clc
clear
close all


%%
ss = [];
for i = 1:87
    S = load(['D:\Impelimention\Rajabi\diabetic-retinopathy-master\Image processing\Data\D',num2str(i),'.mat']);
    s = S.s;
    M = numel(s);
    figure,subplot(1,2,1),imshow(s(i).I)
    subplot(1,2,2),imshow(s(i).J)
    if size(s,2)>0
    id = find([s.Label] ==0);
    s(id) = [];
    ss = [ss; s];
    end
end


