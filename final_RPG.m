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
[dotRows, dotColumns] = find(binaryImage);

% If there are not enough pixels before or after the cropped image, stop
% function to prevent inaccurate translation
if min(dotColumns)-31 < 0
    fprintf('The image does not have enough space before the first character for the bounding box')
    return
elseif max(dotColumns)+31 > length(RGB) 
    fprintf('The image does not have enough space after the last character for the bounding box')
    return
else
row1 = min(dotRows);
row2 = max(dotRows);
col1 = min(dotColumns)-31; % see note below
col2 = max(dotColumns)+31; % see note below
end

%% NOTE
% We used imdistline to determine the distance between two characters.
% This value was used for determining bounding box width on initial crop.
% Distance = 62 pixels -> half distance for either side = 31 pixels

% figure
% imshow(GCI)
% axis on;
% hp = impixelinfo(); % Show x,y and RGB as you mouse around.
% h = imdistline;
% fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
% setDragConstraintFcn(h,fcn); 
% title('Cropped Image with Distance Line')
%%

% Crop it.
croppedImage = RGB(row1:row2, col1:col2, :);
% Convert to gray and use for display (Gray Cropped Image = GCI)
GCI = croppedImage;

% Calculate image length and then estimate number of characters based on 
% known width (approx. 180 pixels). Use this to determine interval length
len = length(GCI);
characters = round(len/180);
interval = len/characters;


% Create figure to plot original image and show cropped image next to it
figure
hold on

subplot(4,4,1)
imshow(RGB)
axis on;
title('Original Color Image')

subplot(4,4,2)
imshow(GCI)
axis on;
title('Gray Cropped Image')

% Run loop to crop each character to equal size and then plot it on same figure

for k = 1:characters
    
    cropped_char1 = imcrop(GCI,[0 0 interval size(GCI,[1])]);
    subplot(4,4,3);
    imshow(cropped_char1);
    cropped_char2 = imcrop(GCI,[(k)*interval 1.51 interval (k+1)*interval]);
    subplot(4,4,k+3);
	imshow(cropped_char2);
    
end
