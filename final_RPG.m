RGB = imread('alphabet2.JPG');
[rows, columns, numberOfColorChannels] = size(RGB);

% Take the red channel.
grayImage = RGB(:, :, 1);

% Run a texture filter on it.
stdImage = stdfilt(grayImage);
% Threshold the image.
binaryImage = stdImage > 5;
% Get rid of small blobs.
binaryImage = bwareafilt(binaryImage, [70, inf]); % Keep only if 70 pixels or larger.

% Find the bounding box.
[blobRows, blobColumns] = find(binaryImage);

% If there are not enough pixels before or after the cropped image, stop
% function to prevent inaccurate translation
if min(blobColumns)-31 < 0
    fprintf('The image does not have enough space before the first character for the bounding box')
    return
elseif max(blobColumns)+31 > length(RGB) 
    fprintf('The image does not have enough space after the last character for the bounding box')
    return
else
row1 = min(blobRows);
row2 = max(blobRows);
col1 = min(blobColumns)-31; % see note below
col2 = max(blobColumns)+31;   
end

% Crop it.
croppedImage = RGB(row1:row2, col1:col2, :);
% Convert to gray and use for display (Gray Cropped Image = GCI)
GCI = croppedImage;


len = length(GCI);
characters = round(len/180);
interval = len/characters;

figure
hold on
for k = 1:characters
    
    cropped_char1 = imcrop(GCI,[0 0 interval size(GCI,[1])]);
    subplot(4,4,3);
    imshow(cropped_char1);
    cropped_char2 = imcrop(GCI,[(k)*interval 1.51 interval (k+1)*interval]);
    subplot(4,4,k+3);
	imshow(cropped_char2);
    
end


% using imdistline to determine the distance between two characters
% this value used for determining bounding box width on initial crop
% distance = 64 pixels

% figure
% imshow(GCI)
% axis on;
% hp = impixelinfo(); % Show x,y and RGB as you mouse around.
% h = imdistline;
% fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
% setDragConstraintFcn(h,fcn); 
% title('Gray Cropped Image')
% hold off


subplot(4,4,1)
imshow(RGB)
axis on;
hp = impixelinfo(); % Show x,y and RGB as you mouse around.
title('Original Color Image')

subplot(4,4,2)
imshow(GCI)
axis on;
title('Gray Cropped Image')