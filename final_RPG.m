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


% Find sizes of cropped image to initialize cell array (use interval for
% column length)
[rows, columns, colors] = size(GCI);
cc = cell(rows,round(interval),colors);

% Run loop to crop each character to equal size and then plot it on same 
% figure. Also, create variables for each cropped image to use during
% further processing.
for k = 1:characters
    
    cropped_char1 = imcrop(GCI,[0 0 interval size(GCI,[1])]);
    subplot(4,4,3);
    imshow(cropped_char1);
    cropped_char2 = imcrop(GCI,[(k)*interval 1.51 interval (k+1)*interval]);
    subplot(4,4,k+3);
	imshow(cropped_char2);
    
    % Create first cropped character for future reference
    cc0 = cropped_char1;
    % Create remaining cropped characters for each interval point
    cc{k} = imcrop(GCI,[(k)*interval 1.51 interval (k+1)*interval]);
end

%%

threshold = 1000;
boxcc0 = zeros(1,6);

upperLeftcc0 = cc0(1:69,1:90,:);
upperRightcc0 = cc0(1:69,91:180,:);
middleLeftcc0 = cc0(70:139,1:90,:);
middleRightcc0 = cc0(70:139,91:180,:);
bottomLeftcc0 = cc0(140:209,1:90,:);
bottomRightcc0 = cc0(140:209,91:180,:);

numBlackPixels1 = sum(upperLeftcc0 == 0);
numBlackPixels2 = sum(upperRightcc0 == 0);
numBlackPixels3 = sum(middleLeftcc0 == 0);
numBlackPixels4 = sum(middleRightcc0 == 0);
numBlackPixels5 = sum(bottomLeftcc0 == 0);
numBlackPixels6 = sum(bottomRightcc0 == 0);

boxval1 = sum(numBlackPixels1,2);
boxval2 = sum(numBlackPixels3,2);
boxval3 = sum(numBlackPixels5,2);
boxval4 = sum(numBlackPixels2,2);
boxval5 = sum(numBlackPixels4,2);
boxval6 = sum(numBlackPixels6,2);

for i = 1
    if boxval1 > threshold
        boxcc0(i) = 1;
    end
    if boxval2 > threshold
        boxcc0(i+1) = 1;
    end
    if boxval3 > threshold
        boxcc0(i+2) = 1;
    end
    if boxval4 > threshold
        boxcc0(i+3) = 1;    
    end
    if boxval5 > threshold
        boxcc0(i+4) = 1;
    end
    if boxval6 > threshold
        boxcc0(i+5) = 1;
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

boxcc = zeros(1,6);

for k = 1:characters-1

characterk = cc{k};
upperLeftcc = characterk(1:69,1:90,:);
upperRightcc = characterk(1:69,91:179,:);
middleLeftcc = characterk(70:139,1:90,:);
middleRightcc = characterk(70:139,91:179,:);
bottomLeftcc = characterk(140:208,1:90,:);
bottomRightcc = characterk(140:208,91:179,:);

numBlackPixelscc1 = sum(upperLeftcc == 0);
numBlackPixelscc2 = sum(upperRightcc == 0);
numBlackPixelscc3 = sum(middleLeftcc == 0);
numBlackPixelscc4 = sum(middleRightcc == 0);
numBlackPixelscc5 = sum(bottomLeftcc == 0);
numBlackPixelscc6 = sum(bottomRightcc == 0);

boxvalcc1 = sum(numBlackPixelscc1,2);
boxvalcc2 = sum(numBlackPixelscc2,2);
boxvalcc3 = sum(numBlackPixelscc3,2);
boxvalcc4 = sum(numBlackPixelscc4,2);
boxvalcc5 = sum(numBlackPixelscc5,2);
boxvalcc6 = sum(numBlackPixelscc6,2);

    for i = 1
        if boxval1 > threshold
            boxcc(i) = 1;
        end
        if boxval2 > threshold
            boxcc(i+1) = 1;
        end
        if boxval3 > threshold
            boxcc(i+2) = 1;
        end
        if boxval4 > threshold
            boxcc(i+3) = 1;    
        end
        if boxval5 > threshold
            boxcc(i+4) = 1;
        end
        if boxval6 > threshold
            boxcc(i+5) = 1;
        end
    end
    
if boxcc == [1 0 0 0 0 0] 
    output = "A";
    
elseif boxcc == [1 1 0 0 0 0]
    output = "B";
    
elseif boxcc == [1 0 0 1 0 0]
    output = "C";

elseif boxcc == [1 0 0 1 1 0]
    output = "D";

elseif boxcc == [1 0 0 0 1 0]
    output = "E";
    
elseif boxcc == [1 1 0 1 0 0]
    output = "F";

elseif boxcc == [1 1 0 1 1 0]
    output = "G";

elseif boxcc == [1 1 0 0 1 0]
    output = "H";

elseif boxcc == [0 1 0 1 0 0]
    output = "I";

elseif boxcc == [0 1 0 1 1 0]
    output = "J";

elseif boxcc == [1 0 1 0 0 0]
    output = "K";

elseif boxcc == [1 1 1 0 0 0]
    output = "L";

elseif boxcc == [1 0 1 1 0 0]
    output = "M";

elseif boxcc == [1 0 1 1 1 0]
    output = "N";
    
elseif boxcc == [1 0 1 0 1 0]
    output = "O";

elseif boxcc == [1 1 1 1 0 0]
    output = "P";

elseif boxcc == [1 1 1 1 1 0]
    output = "Q";

elseif boxcc == [1 1 1 0 1 0]
    output = "R";

elseif boxcc == [0 1 1 1 0 0]
    output = "S";

elseif boxcc == [0 1 1 1 1 0]
    output = "T";

elseif boxcc == [1 0 1 0 0 1]
    output = "U";

elseif boxcc == [1 1 1 0 0 1]
    output = "V";

elseif boxcc == [0 1 0 1 1 1]
    output = "W";

elseif boxcc == [1 0 1 1 0 1]
    output = "X";
    
elseif boxcc == [1 0 1 1 1 1]
    output = "Y";

elseif boxcc == [1 0 1 0 1 1]
    output = "Z";
    
elseif boxcc == [0 0 0 0 0 0]
    output = " ";
      
end
 
% figure
% subplot(3,2,1)
% imshow(upperLeftcc);
% subplot(3,2,2);
% imshow(upperRightcc);
% subplot(3,2,3);
% imshow(middleLeftcc);
% subplot(3,2,4);
% imshow(middleRightcc);
% subplot(3,2,5);
% imshow(bottomLeftcc);
% subplot(3,2,6);
% imshow(bottomRightcc);

end

numBlackPixels1 = sum(upperLeftcc == 0);
numBlackPixels2 = sum(upperRightcc == 0);
numBlackPixels3 = sum(middleLeftcc == 0);
numBlackPixels4 = sum(middleRightcc == 0);
numBlackPixels5 = sum(bottomLeftcc == 0);
numBlackPixels6 = sum(bottomRightcc == 0);

boxval1 = sum(numBlackPixels1,2);
boxval2 = sum(numBlackPixels2,2);
boxval3 = sum(numBlackPixels3,2);
boxval4 = sum(numBlackPixels4,2);
boxval5 = sum(numBlackPixels5,2);
boxval6 = sum(numBlackPixels6,2);

if boxcc0 == [1 0 0 0 0 0] 
    output = "A";
    
elseif boxcc0 == [1 1 0 0 0 0]
    output = "B";
    
elseif boxcc0 == [1 0 0 1 0 0]
    output = "C";

elseif boxcc0 == [1 0 0 1 1 0]
    output = "D";

elseif boxcc0 == [1 0 0 0 1 0]
    output = "E";
    
elseif boxcc0 == [1 1 0 1 0 0]
    output = "F";

elseif boxcc0 == [1 1 0 1 1 0]
    output = "G";

elseif boxcc0 == [1 1 0 0 1 0]
    output = "H";

elseif boxcc0 == [0 1 0 1 0 0]
    output = "I";

elseif boxcc0 == [0 1 0 1 1 0]
    output = "J";

elseif boxcc0 == [1 0 1 0 0 0]
    output = "K";

elseif boxcc0 == [1 1 1 0 0 0]
    output = "L";

elseif boxcc0 == [1 0 1 1 0 0]
    output = "M";

elseif boxcc0 == [1 0 1 1 1 0]
    output = "N";
    
elseif boxcc0 == [1 0 1 0 1 0]
    output = "O";

elseif boxcc0 == [1 1 1 1 0 0]
    output = "P";

elseif boxcc0 == [1 1 1 1 1 0]
    output = "Q";

elseif boxcc0 == [1 1 1 0 1 0]
    output = "R";

elseif boxcc0 == [0 1 1 1 0 0]
    output = "S";

elseif boxcc0 == [0 1 1 1 1 0]
    output = "T";

elseif boxcc0 == [1 0 1 0 0 1]
    output = "U";

elseif boxcc0 == [1 1 1 0 0 1]
    output = "V";

elseif boxcc0 == [0 1 0 1 1 1]
    output = "W";

elseif boxcc0 == [1 0 1 1 0 1]
    output = "X";
    
elseif boxcc0 == [1 0 1 1 1 1]
    output = "Y";

elseif boxcc0 == [1 0 1 0 1 1]
    output = "Z";
    
elseif boxcc0 == [0 0 0 0 0 0]
    output = " ";
      
end

fprintf(output)
fprintf(output(i))
