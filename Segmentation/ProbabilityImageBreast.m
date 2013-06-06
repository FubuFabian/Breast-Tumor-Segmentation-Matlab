function probIm = ProbabilityImageBreast(im)

imGray =  mat2gray(im);
imEq = histeq(imGray);

imDiff = SRAD3D(imEq,25,1);
imDiff = mat2gray(imDiff);

textureIm = VarianceTexture(imGray);
textureIm = mat2gray(textureIm);


[ren col] = size(imGray);

probIm = zeros(ren,col);

intensityProb = load('Data/Probabilities/tumorIntensityMax.mat');
intensityProb = intensityProb.tumorIntensityProb;
intensityProbIm = zeros(ren,col); 

textureProb = load('Data/Probabilities/tumorTextureMean.mat');
textureProb = textureProb.tumorTextureProb;
textureProbIm = zeros(ren,col); 

for i=1:ren
    for j=1:col
     
        intensity = imDiff(i,j);
        intensityIdx = round(intensity*256);
        
        if intensityIdx == 0
            intensityIdx = 1;
        end
        
        intensityPixProb = intensityProb(intensityIdx);
        intensityProbIm(i,j) = intensityPixProb;

        texture = textureIm(i,j);
        textureIdx = round(texture*256);
        
        if textureIdx == 0
            textureIdx = 1;
        end
        
        textureProbPix = textureProb(textureIdx);
        textureProbIm(i,j) = textureProbPix;
        
        probIm(i,j) = textureProbPix*intensityPixProb;
        
    end
end

intensityProbIm = mat2gray(intensityProbIm);
textureProbIm = mat2gray(textureProbIm);
probIm = mat2gray(probIm);

figure,
subplot(1,4,1), imshow(imGray), title('Original image')
subplot(1,4,2), imshow(imEq), title('Equalized image')
subplot(1,4,3), imshow(imDiff), title('Filtered Image')
subplot(1,4,4), imshow(intensityProbIm), title('Intensity Probability')
suptitle('Intensity Probability Process')

figure,
subplot(1,4,1), imshow(imGray), title('Original image')
subplot(1,3,2), imshow(textureIm), title('Texture Image')
subplot(1,3,3), imshow(textureProbIm), title('Texture Probability')
suptitle('Texture Probability Process')

figure, imshow(probIm), title('Probability Image')


    

       
        