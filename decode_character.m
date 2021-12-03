function[output] = decode_character(rows,interval,characters,cropped_char,threshold)

numBlackPixelscc = zeros(1,6);

for k = 1:characters-1

row1 = round(rows/3);
row2 = round(rows*2/3);
row3 = rows;  
col1 = round(interval/2);
col2 = interval;
    
characterk = cropped_char(:,:,k);
upperLeftcc = characterk(1:row1,1:col1);
upperRightcc = characterk(1:row1,col1:col2);
middleLeftcc = characterk(row1:row2,1:col1);
middleRightcc = characterk(row1:row2,col1:col2);
bottomLeftcc = characterk(row2:row3,1:col1);
bottomRightcc = characterk(row2:row3,col1:col2);

numBlackPixelscc(1) = sum(upperLeftcc == 0,'all');
numBlackPixelscc(4) = sum(upperRightcc == 0,'all');
numBlackPixelscc(2) = sum(middleLeftcc == 0,'all');
numBlackPixelscc(5) = sum(middleRightcc == 0,'all');
numBlackPixelscc(3) = sum(bottomLeftcc == 0,'all');
numBlackPixelscc(6) = sum(bottomRightcc == 0,'all');

boxcc = zeros(1,6);
    for i = 1:6
        if numBlackPixelscc(i) > threshold
            boxcc(i) = 1;
        end
 
    end
    
    
    
    
if boxcc == [1 0 0 0 0 0] 
    output(k) = "A";
    
elseif boxcc == [1 1 0 0 0 0]
    output(k) = "B";
    
elseif boxcc == [1 0 0 1 0 0]
    output(k) = "C";

elseif boxcc == [1 0 0 1 1 0]
    output(k) = "D";

elseif boxcc == [1 0 0 0 1 0]
    output(k) = "E";
    
elseif boxcc == [1 1 0 1 0 0]
    output(k) = "F";

elseif boxcc == [1 1 0 1 1 0]
    output(k) = "G";

elseif boxcc == [1 1 0 0 1 0]
    output(k) = "H";

elseif boxcc == [0 1 0 1 0 0]
    output(k) = "I";

elseif boxcc == [0 1 0 1 1 0]
    output(k) = "J";

elseif boxcc == [1 0 1 0 0 0]
    output(k) = "K";

elseif boxcc == [1 1 1 0 0 0]
    output(k) = "L";

elseif boxcc == [1 0 1 1 0 0]
    output(k) = "M";

elseif boxcc == [1 0 1 1 1 0]
    output(k) = "N";
    
elseif boxcc == [1 0 1 0 1 0]
    output(k) = "O";

elseif boxcc == [1 1 1 1 0 0]
    output(k) = "P";

elseif boxcc == [1 1 1 1 1 0]
    output(k) = "Q";

elseif boxcc == [1 1 1 0 1 0]
    output(k) = "R";

elseif boxcc == [0 1 1 1 0 0]
    output(k) = "S";

elseif boxcc == [0 1 1 1 1 0]
    output(k) = "T";

elseif boxcc == [1 0 1 0 0 1]
    output(k) = "U";

elseif boxcc == [1 1 1 0 0 1]
    output(k) = "V";

elseif boxcc == [0 1 0 1 1 1]
    output(k) = "W";

elseif boxcc == [1 0 1 1 0 1]
    output(k) = "X";
    
elseif boxcc == [1 0 1 1 1 1]
    output(k) = "Y";

elseif boxcc == [1 0 1 0 1 1]
    output(k) = "Z";
    
elseif boxcc == [0 0 0 0 0 0]
    output(k) = " ";
      
end

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
