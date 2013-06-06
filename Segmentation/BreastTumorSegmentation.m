function borders = BreastTumorSegmentation()

%%%%%%%%% loading and initializating image %%%%%%%%%%
[fileImages, pathImages, wtv] = uigetfile('*.bmp','Load Images','MultiSelect', 'on');

if ischar(fileImages)
    nImages = 1;
else
    [wtv nImages] = size(fileImages);
end

for i=1:nImages
    
    if ischar(fileImages)
        img_name = strcat(pathImages,fileImages);
    else
        img_name = strcat(pathImages,fileImages{i});
    end
    
    im = imread(img_name);
    imGray = mat2gray(im);
    
    figure, imshow(imGray), title('Original Image');

 %%%%%%%% Probability Image %%%%%%%%%%%%%
 
    probIm = ProbabilityImageBreast(imGray);
 
 %%%%%% RegionGrowing %%%%%%%%%%%%%%%%%%%

    [seed maxDist] = RegionGrowingParameters(probIm);
 
    [borders, rgMask] = RegionGrowingBreast(probIm,seed,0.55,maxDist,false,true,true);
    
    figure,
    subplot(1,3,1), imshow(imGray), title('Original Image')
    subplot(1,3,2), imshow(rgMask), title('Segmented Region')
    subplot(1,3,3), imshow(imGray), title('Tumor Borders') 
    hold all
    plot(borders(:,1), borders(:,2), 'LineWidth', 2)
    hold off
    suptitle('Region Growing Results')

    
end
 
