% Compute the sum of white pixels in a 3x3 block of a binary image.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

% Get the base filename.
baseFileName = 'braillealphabet.png'; % Assign the one on the button that they clicked on.
% Get the full filename, with path prepended.
folder = pwd; % Current folder
fullFileName = fullfile(folder, baseFileName);

% Check if file exists.
if ~exist(fullFileName, 'file')
	% File doesn't exist -- didn't find it there.  Check the search path for it.
	fullFileNameOnSearchPath = baseFileName; % No path this time.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
% Read in image.
grayImage = imread(fullFileName);
% Get the dimensions of the image.
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(grayImage);
if numberOfColorBands > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = min(grayImage, [], 3); % Take green channel.
end
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(grayImage, []);
axis on;
title('Original Grayscale Image', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')

% Let's compute and display the histogram.
subplot(2, 2, 2);
histogram(grayImage);
grid on;
title('Histogram of original image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);

grayImage = imcrop(grayImage,[15 4 190 135]);
% We need to update size since we cropped the image.
[rows, columns, numberOfColorBands] = size(grayImage);
hPlot = 1; % Initialize.

% Threshold to find dark crack.
binaryImage = grayImage < 237;
% Blobs must be at least a certain number of pixels.
binaryImage = bwareaopen(binaryImage, 30);
% Display the binary image.
subplot(2, 2, 3);
imshow(binaryImage, []);
axis on;
hold on; % So we can draw boxes.
title('Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;

% Specify where the columns start and stop for the 8 "lanes".
columnDividers = round(linspace(1, columns, 8+1))
% Specify where the rows start and stop for the 3 "lanes".
rowDividers = round(linspace(1, rows, 3+1))

% Define lookup table.  Change it to the the correct letters.
myLookUpTable = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', ...
	'f', 'p', 'g', 'q', 'h', 'l', 'm', '!', 't', ...
	'0', '1', '2', '3', '4', '9', '5', '8', '7', ...
	'0', '1', '2', '3', '4', '9', '5', '8', '7', ...
	'P', 'Q', 'S', 'T', 'U', '6', 'X', 'W', '4', ...
	'0', '1', '2', '3', '4', '9', '5', '8', '7', ...
	'0', '1', '2', '3', '4', '9', '5', '8', '7', ...
	'A', 'C', 'E', 'G', 'Y', 'R', 'Q', 'Z', 'J']
finishNow = false;
% Let's get each of those subimages
for c = 1 : length(columnDividers) - 1
	col1 = columnDividers(c)
	col2 = columnDividers(c+1)
	for r = 1 : length(rowDividers) - 1
		row1 = rowDividers(r)
		row2 = rowDividers(r+1)
		% Draw box around
		subplot(2, 2, 3);
		xBox = [col1,col2,col2,col1,col1];
		yBox = [row1,row1,row2,row2,row1];
		delete('hPlot'); % Delete prior box.
		hPlot = plot(xBox, yBox, 'r-', 'LineWidth', 2);
		% Crop out sub image.
		thisImage = binaryImage(row1:row2, col1:col2);
		subplot(2, 2, 4);
		hold off;
		imshow(thisImage);
		hold on;
		grid on;
		axis on;
		% The places to look are at rows 16, 23, and 33
		% and in columns 9 and 17.  Get the values there
		% Plot points over it
		plot([9,9,9,17,17,17], [16,23,33,16,23,33], 'r*', 'LineWidth', 2);
		drawnow;
		pause(0.8);
		lutIndex = 2^5 * binaryImage(16, 9) + ...
			2^4 * binaryImage(23, 9) + ...
			2^3 * binaryImage(33, 9) + ...
			2^2 * binaryImage(16, 17) + ...
			2^1 * binaryImage(23, 17) + ...
			2^0 * binaryImage(33, 17)
		theLetter = myLookUpTable(lutIndex);
		promptMessage = sprintf('lutIndex = %d\nThe letter = %c\nDo you want to Continue processing,\nor Quit processing?', lutIndex, theLetter);
		titleBarCaption = 'Continue?';
		buttonText = questdlg(promptMessage, titleBarCaption, 'Continue', 'Quit', 'Continue');
		if strcmpi(buttonText, 'Quit')
			finishNow = true;
			break;
		end
	end
	if finishNow
		break;
	end
end