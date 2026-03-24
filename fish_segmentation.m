
%% Read the Image file, convert to grayscale, visualize as binary image %%
flatFish = imread("flatfish.jpg");
fishGray = im2gray(flatFish);
fishSTD = stdfilt(fishGray);
fishSTD = rescale(fishSTD);
fishSTD = medfilt2(fishSTD,[7 7]);
fishBW = imbinarize(fishSTD);
imshowpair(flatFish,fishBW,"montage")

%% Convert background to foreground %%
fishBW = imcomplement(fishBW);
imshow(fishBW)

%% Remove holes and noisy pixels around the border to isolate the fish %%
fishBW = imfill(fishBW,"holes");
imshow(fishBW)
fishBW = bwareafilt(fishBW,1);
imshow(fishBW)

%% Remove protuding pixels around the edges of the fish through morphological functions %%
SE = strel("disk", 5)
fishBW = imopen(fishBW,SE);
imshow(fishBW)

%% Smooth the edges of the fish %%
SE = strel("disk", 20);
fishBW = imclose(fishBW,SE);
imshow(fishBW)
