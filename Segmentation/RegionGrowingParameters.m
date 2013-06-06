function [seed maxDist] = RegionGrowingParameters(im)

imGray = mat2gray(im);

figure, imMask = roipoly(imGray); title('Select Region of Interest')
[roiY roiX] = find(imMask);

himage = imshow(imGray); title('Select Seed Point')
p = ginput(1);
    
seed(1) = round(axes2pix(size(imGray, 2), get(himage, 'XData'), p(2)));
seed(2) = round(axes2pix(size(imGray, 1), get(himage, 'YData'), p(1)));


corners = [[min(roiX) min(roiY)]; [max(roiX) min(roiY)]; [min(roiX) max(roiY)]; [max(roiX) max(roiY)]];
maxDists = sqrt((seed(2) - corners(:,1)).^2 + (seed(1) - corners(:,2)).^2);
maxDist = max(maxDists)