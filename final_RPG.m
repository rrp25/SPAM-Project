RGB = imread('braille.png');
[rows, columns, numberOfColorChannels] = size(RGB);

% Take the red channel.
grayImage = RGB(:, :, 1);
% % Erase the first 110 columns to get rid of the holes.
% verticalProfile = mean(grayImage, 2);
% for col = 1 : 1
% 	grayImage(:, col) = verticalProfile;
% end

% Run a texture filter on it.
stdImage = stdfilt(grayImage);
% Threshold the image.
binaryImage = stdImage > 5;
% Get rid of small blobs.
binaryImage = bwareafilt(binaryImage, [70, inf]); % Keep only if 70 pixels or larger.

% Find the bounding box.
[blobRows, blobColumns] = find(binaryImage);
row1 = min(blobRows);
row2 = max(blobRows);
col1 = min(blobColumns);
col2 = max(blobColumns);

% Crop it.
croppedImage = RGB(row1:row2, col1:col2, :);
% Convert to gray and use for display (Gray Cropped Image = GCI)
GCI = rgb2gray(croppedImage);


len = length(GCI);
interval = len/6;
I2 = imcrop(GCI,[0 0 interval 204]);
x = 10;
I7 = imcrop(GCI,[interval 1.51 interval 2*interval]);
I8 = imcrop(GCI,[2*interval 1.51 interval 3*interval]);
I9 = imcrop(GCI,[3*interval 1.51 interval 4*interval]);
I10 = imcrop(GCI,[4*interval 1.51 interval 5*interval]);
I11 = imcrop(GCI,[5*interval 1.51 interval 6*interval]);

h = ones(5,5) / 25;
I3 = imfilter(I2,h);
I4 = imadjust(I3);
I5 = imcomplement(I4);
se = strel('disk',1);
I6 = imdilate(I5,se);



subplot(4,4,1)
imshow(RGB)
axis on;
hp = impixelinfo(); % Show x,y and RGB as you mouse around.
title('Original Color Image')

subplot(4,4,2)
imshow(GCI)
axis on;
hp = impixelinfo(); % Show x,y and RGB as you mouse around.
title('Gray Cropped Image')
subplot(4,4,3)
imshow(I2)
title('Cropped Image')
subplot(4,4,4)
imshow(I3)
title('filtered Image')
subplot(4,4,5)
imshow(I4)
title('contrast Image')
subplot(4,4,6)
imshow(I5)
title('complement Image')
subplot(4,4,7)
imshow(I7)
subplot(4,4,8)
imshow(I8)
subplot(4,4,9)
imshow(I9)
subplot(4,4,10)
imshow(I10)
subplot(4,4,11)
imshow(I11)