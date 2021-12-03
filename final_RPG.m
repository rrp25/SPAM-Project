% Translate image of interest by loading it into line of code below with
% exact file name 

RGB = imread('mathworks.JPG');

% Take the red channel.
grayImage = RGB(:, :, 1);

% Run a texture filter on it.
stdImage = stdfilt(grayImage);
% Threshold the image.
binaryImage = stdImage > 5;
% Get rid of small marks, if any.
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
% h = imdistline;
% fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
% setDragConstraintFcn(h,fcn); 
% title('Cropped Image with Distance Line')
%%

% Crop it.
croppedImage = RGB(row1:row2, col1:col2, :);
% Convert to gray and use for display (Gray Cropped Image = GCI)
GCI = rgb2gray(croppedImage);

% Calculate image length and then estimate number of characters based on 
% known width (approx. 180 pixels). Use this to determine interval length
len = length(GCI);
characters = round(len/180);
interval = round(len/characters);


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


% Find sizes of cropped image to initialize cell array (use interval for
% column length)
[rows, columns] = size(GCI);
cc = zeros(rows,interval);

% Run loop to crop each character to equal size and then plot it on same 
% figure. Also, create variables for each cropped image to use during
% further processing.
for k = 1:characters
    
    cropped_char1 = imcrop(GCI,[0 0 interval size(GCI,[1])]);
    subplot(4,4,3);
    imshow(cropped_char1);
    cropped_char2 = imcrop(GCI,[(k)*interval 0 interval (k+1)*interval]);
    subplot(4,4,k+3);
	imshow(cropped_char2);
    
    % Create first cropped character for future reference
    cc0 = cropped_char1;
    % Create remaining cropped characters for each interval point
    cc(:,:,k) = cropped_char2;
    
end

% a = zeros(size(GCI));
% for k = 1:characters
%     a(k) = cc{k};
% end

%%

threshold = 1000;
boxcc0 = zeros(1,6);
numBlackPixelscc0 = zeros(1,6);

upperLeftcc0 = cc0(1:69,1:90,:);
upperRightcc0 = cc0(1:69,91:180,:);
middleLeftcc0 = cc0(70:139,1:90,:);
middleRightcc0 = cc0(70:139,91:180,:);
bottomLeftcc0 = cc0(140:209,1:90,:);
bottomRightcc0 = cc0(140:209,91:180,:);

numBlackPixelscc0(1) = sum(upperLeftcc0 == 0,'all');
numBlackPixelscc0(3) = sum(upperRightcc0 == 0,'all');
numBlackPixelscc0(5) = sum(middleLeftcc0 == 0,'all');
numBlackPixelscc0(2) = sum(middleRightcc0 == 0,'all');
numBlackPixelscc0(4) = sum(bottomLeftcc0 == 0,'all');
numBlackPixelscc0(6) = sum(bottomRightcc0 == 0,'all');


for i = 1:6
    if numBlackPixelscc0(i) > threshold
        boxcc0(i) = 1;
    end
end


% figure
% subplot(3,2,1);
% imshow(upperLeftcc0);
% subplot(3,2,2);
% imshow(upperRightcc0);
% subplot(3,2,3);
% imshow(middleLeftcc0);
% subplot(3,2,4);
% imshow(middleRightcc0);
% subplot(3,2,5);
% imshow(bottomLeftcc0);
% subplot(3,2,6);
% imshow(bottomRightcc0);

if boxcc0 == [1 0 0 0 0 0] 
    outputcc0 = "A";
    
elseif boxcc0 == [1 1 0 0 0 0]
    outputcc0 = "B";
    
elseif boxcc0 == [1 0 0 1 0 0]
    outputcc0 = "C";

elseif boxcc0 == [1 0 0 1 1 0]
    outputcc0 = "D";

elseif boxcc0 == [1 0 0 0 1 0]
    outputcc0 = "E";
    
elseif boxcc0 == [1 1 0 1 0 0]
    outputcc0 = "F";

elseif boxcc0 == [1 1 0 1 1 0]
    outputcc0 = "G";

elseif boxcc0 == [1 1 0 0 1 0]
    outputcc0 = "H";

elseif boxcc0 == [0 1 0 1 0 0]
    outputcc0 = "I";

elseif boxcc0 == [0 1 0 1 1 0]
    outputcc0 = "J";

elseif boxcc0 == [1 0 1 0 0 0]
    outputcc0 = "K";

elseif boxcc0 == [1 1 1 0 0 0]
    outputcc0 = "L";

elseif boxcc0 == [1 0 1 1 0 0]
    outputcc0 = "M";

elseif boxcc0 == [1 0 1 1 1 0]
    outputcc0 = "N";
    
elseif boxcc0 == [1 0 1 0 1 0]
    outputcc0 = "O";

elseif boxcc0 == [1 1 1 1 0 0]
    outputcc0 = "P";

elseif boxcc0 == [1 1 1 1 1 0]
    outputcc0 = "Q";

elseif boxcc0 == [1 1 1 0 1 0]
    outputcc0 = "R";

elseif boxcc0 == [0 1 1 1 0 0]
    outputcc0 = "S";

elseif boxcc0 == [0 1 1 1 1 0]
    outputcc0 = "T";

elseif boxcc0 == [1 0 1 0 0 1]
    outputcc0 = "U";

elseif boxcc0 == [1 1 1 0 0 1]
    outputcc0 = "V";

elseif boxcc0 == [0 1 0 1 1 1]
    outputcc0 = "W";

elseif boxcc0 == [1 0 1 1 0 1]
    outputcc0 = "X";
    
elseif boxcc0 == [1 0 1 1 1 1]
    outputcc0 = "Y";

elseif boxcc0 == [1 0 1 0 1 1]
    outputcc0 = "Z";
    
elseif boxcc0 == [0 0 0 0 0 0]
    outputcc0 = " ";
      
end

fprintf(outputcc0)

for k = 1:characters
[output] = decode_character(characters,cc,threshold);
fprintf(output)
end

