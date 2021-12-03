function retinaRGB = resizeretina ( retinaRGB, x, y )
% Resize an RGB image of retina
    a = size(retinaRGB, 1);
    b = size(retinaRGB, 2);
    retinaRGB = imresize(retinaRGB, sqrt(x * y / (a * b)));
    
end
