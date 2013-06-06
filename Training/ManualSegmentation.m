function [tumors backgrounds] = ManualSegmentation()

%%%%% Loading training images %%%%%%%%

[fileImages, pathImages, wtv] = uigetfile('*.bmp','Load Images','MultiSelect', 'on');

if ischar(fileImages)
    nImages = 1;
else
    [wtv nImages] = size(fileImages);
end

tumors = cell(nImages);
backgrounds = cell(nImages);

%%%%% Segmenting%%%%%%%%%%%%%

for i=1:nImages
    
    if ischar(fileImages)
        img_name = strcat(pathImages,fileImages);
    else
        img_name = strcat(pathImages,fileImages{i});
    end
    
    im = imread(img_name);
    imGray = mat2gray(im);
    
    
    figure, imshow(imGray)
    tumorContour = imfreehand(gca,'Closed',0);
    tumorMask = createMask(tumorContour);
    
    backgroundMask = imcomplement(tumorMask);
    
    %figure, imshow(tumorMask)
    
    tumor = find(tumorMask);
    tumors{i} = tumor;
    
    background = find(backgroundMask);
    backgrounds{i} = background;
   
end
