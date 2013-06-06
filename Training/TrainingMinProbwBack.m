function [tumorIntensityProb tumorTextureProb backgroundIntensityProb backgroundTextureProb] = TrainingMinProbwBack()

%%%%% Loading training images %%%%%%%%

[fileImages, pathImages, wtv] = uigetfile('*.bmp','Load Images','MultiSelect', 'on');

if ischar(fileImages)
    nImages = 1;
else
    [wtv nImages] = size(fileImages);
end

intensityTumor = 0;
textureTumor = 0;

nPoints = 0;

tumors = load('C:\Users\Public\Documents\Segmentation\RegionGrowing\Data\Tumores Segmentados\31tumors.mat');
tumors = tumors.ans;

backgrounds = load('C:\Users\Public\Documents\Segmentation\RegionGrowing\Data\Tumores Segmentados\backgrounds.mat');
backgrounds = backgrounds.backgrounds;


tumorIntensityProb = ones(256,1);
tumorTextureProb = ones(256,1);

backgroundIntensityProb = ones(256,1);
backgroundTextureProb = ones(256,1);
%%%%% Segmenting and processing Images %%%%%%%%%%%%%

for i=1:nImages
    
    if ischar(fileImages)
        img_name = strcat(pathImages,fileImages);
    else
        img_name = strcat(pathImages,fileImages{i});
    end
    
    im = imread(img_name);
    imGray = mat2gray(im);
    
    imEq = histeq(imGray);
    imEq = mat2gray(imEq);
    
    imDiff = SRAD3D(imEq,25,1);
    imDiff = mat2gray(imDiff);
    
    textureIm = VarianceTexture(imGray);
    textureIm = mat2gray(textureIm);
    
    tumor = tumors{i};
    
    tumorSize = size(tumor);

    intensityTumor = imDiff(tumor);
    intensityProbTumor = imhist(intensityTumor)/tumorSize(1);
    
    
    tumorIntensityProb = min(tumorIntensityProb,intensityProbTumor);
    
    textureTumor = textureIm(tumor);
    textureProbTumor = imhist(textureTumor)/tumorSize(1);
    
    tumorTextureProb = min(tumorTextureProb,textureProbTumor);
    
    background = backgrounds{i};
    
    backgroundSize = size(background);
    
    intensityBackground = imDiff(background);
    intensityProbBackground = imhist(intensityBackground)/backgroundSize(1);
    
    backgroundIntensityProb = min(backgroundIntensityProb,intensityProbBackground);
    
    textureBackground = textureIm(background);
    textureProbBackground = imhist(textureBackground)/backgroundSize(1);
    
    backgroundTextureProb = min(backgroundTextureProb,textureProbBackground);
    

end

figure,

subplot(1,2,1), xlabel('Gray level'), ylabel('Probability'), title('Intensity Probability'), legend('Tumor','Background');
hold on
    plot(tumorIntensityProb,'-b')
    plot(backgroundIntensityProb,'-r')
hold off
legend('Tumor','Background');
    
subplot(1,2,2),
xlabel('Gray level'), ylabel('Probability'),  title('Texture Probability') 
hold on
plot(tumorTextureProb,'-b'),
plot(backgroundTextureProb,'-r')
hold off
legend('Tumor','Background');





