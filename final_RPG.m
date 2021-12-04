%% Creation of Bounding Box

clear

% Translate image of interest by loading it into line of code below with
% exact file name 

RGB = imread('mathworks.JPG');

% Take the red channel.
grayImage = RGB(:, :, 1);

% Run a texture filter on it.
stdImage = stdfilt(grayImage);
% Threshold the image.
binaryImage = stdImage > 5;
% Get rid of small marks, if any. Keep only if 70 pixels or larger.
binaryImage = bwareafilt(binaryImage, [70, inf]); 

% Find the bounding box.
[dotRows, dotColumns] = find(binaryImage);

% If there are not enough pixels before or after the cropped image, stop
% function to prevent inaccurate translation.
if min(dotColumns)-31 < 0
    fprintf('The image does not have enough space before the first character for the bounding box')
    return
    
elseif max(dotColumns)+31 > length(RGB) 
    fprintf('The image does not have enough space after the last character for the bounding box')
    return
    
else
    
% Create new dimensions for the cropped image.    
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

%% Pre-Processing to Create Cropped Characters

% Crop it.
croppedImage = RGB(row1:row2, col1:col2, :);
% Convert to gray and use for display (Gray Cropped Image = GCI)
GCI = rgb2gray(croppedImage);

% Calculate image length and then estimate number of characters based on 
% known width (approx. 180 pixels). Use this to determine interval length.
% Rounded interval used in order to create integers for referencing.
len = length(GCI);
characters = round(len/180);
interval = round(len/characters);

% Once rounded numbers found, find the length of the cropped image that
% would result in creating evenly spaced intervals for each character. This
% is done in order to ensure that the indexing in the for loop will always
% result in a matrix with the same dimensions. Determine how many pixels
% need to be added back, and recrop final image.
length_rounded = characters*interval;
addedval = round((length_rounded - len)/2);
croppedImage = RGB(row1:row2, col1-addedval:col2+addedval, :);
GCI = rgb2gray(croppedImage);


% Create figure to plot original image and show cropped image next to it.
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


% Find sizes of cropped image for future reference.
[rows, columns] = size(GCI);

% Run loop to crop each character to equal size and then plot it on same 
% figure. Also, create indexed variables for each cropped image to use 
% during further processing. 
for k = 1:characters-1
    
    cropped_char1 = imcrop(GCI,[0 0 interval size(GCI,[1])]);
    subplot(4,4,3);
    imshow(cropped_char1);
    title('Character 1')
    cropped_char2(:,:,k) = imcrop(GCI,[(k)*interval 0 interval (k+1)*interval]);
    subplot(4,4,k+3);
	imshow(cropped_char2(:,:,k));
    caption = sprintf('Character %d', k+1);
	title(caption);
    
    % First cropped character for future reference
    cc0 = cropped_char1;
    
end



%% Translation of Braille Characters into English

% Threshold established by looking at number of summed black pixels in
% filled dot vs. unfilled dot.
threshold = 1000;

% Initialize matrix for each location in cropped box & for black pixel sum.
boxcc0 = zeros(1,6);
numBlackPixelscc0 = zeros(1,6);

% Create rows and columns of equal size for splitting up each cropped image
% into 1/6 segments.
row1 = round(rows/3);
row2 = round(rows*2/3);
row3 = round(rows);
col1 = round(interval/2);
col2 = interval;

% Create cropped dots for individual analysis within cropped character.
upperLeftcc0 = cc0(1:row1,1:col1);
upperRightcc0 = cc0(1:row1,col1:col2);
middleLeftcc0 = cc0(row1:row2,1:col1);
middleRightcc0 = cc0(row1:row2,col1:col2);
bottomLeftcc0 = cc0(row2:row3,1:col1);
bottomRightcc0 = cc0(row2:row3,col1:col2);

% Sum up the number of black pixels in each segment.
numBlackPixelscc0(1) = sum(upperLeftcc0 == 0,'all');
numBlackPixelscc0(4) = sum(upperRightcc0 == 0,'all');
numBlackPixelscc0(2) = sum(middleLeftcc0 == 0,'all');
numBlackPixelscc0(5) = sum(middleRightcc0 == 0,'all');
numBlackPixelscc0(3) = sum(bottomLeftcc0 == 0,'all');
numBlackPixelscc0(6) = sum(bottomRightcc0 == 0,'all');

% Determine if the number is greater than the threshold, then assign value
% of 1 if it is. Create a matrix from the initialized box with
% corresponding 0 & 1 values.
for i = 1:6
    if numBlackPixelscc0(i) > threshold
        boxcc0(i) = 1;
    end
end

% Assign matrix values to a letter to determine translated text.
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

% Plot if desired to see individual dots cropped on their own figure.
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

% Output first character.
fprintf(outputcc0)

% Run code for remaining characters -> see decode character function.
% Output translated text of remaining characters.
for k = 1:characters-1
[output] = decode_character(rows,interval,characters,cropped_char2,threshold);
fprintf(output(k))
end
