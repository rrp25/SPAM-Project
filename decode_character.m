function[output] = decode_character(characters,cropped_char,threshold)

boxcc = zeros(1,6);
numBlackPixelscc = zeros(1,6);

for k = 1:characters-1

characterk = cropped_char{k};
upperLeftcc = characterk(1:69,1:90,:);
upperRightcc = characterk(1:69,91:179,:);
middleLeftcc = characterk(70:139,1:90,:);
middleRightcc = characterk(70:139,91:179,:);
bottomLeftcc = characterk(140:208,1:90,:);
bottomRightcc = characterk(140:208,91:179,:);

numBlackPixelscc(1) = sum(upperLeftcc == 0,'all');
numBlackPixelscc(3) = sum(upperRightcc == 0,'all');
numBlackPixelscc(5) = sum(middleLeftcc == 0,'all');
numBlackPixelscc(2) = sum(middleRightcc == 0,'all');
numBlackPixelscc(4) = sum(bottomLeftcc == 0,'all');
numBlackPixelscc(6) = sum(bottomRightcc == 0,'all');


    for i = 1:6
        if numBlackPixelscc(i) > threshold
            boxcc(i) = 1;
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