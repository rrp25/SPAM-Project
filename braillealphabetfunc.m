output = "N/A"
box = zeros(1,6)
color = zeros(1,6)
threshold = 200; % need to find actual value

for a = 1:6
   %look at each image and sum up entire matrix and assign that number to indexed spot in array 
   %sumcolor = sum(A, 'all')
   %color[i] = sumcolor
end

for i = 1:6
    if color[i] > threshold
        box[i] == 1;
end

if box == [1 0 0 0 0 0] 
    output = "A";
    
elseif box == [1 1 0 0 0 0]
    output = "B";
    
elseif box == [1 0 0 1 0 0]
    output = "C";

elseif box == [1 0 0 1 1 0]
    output = "D";

elseif box == [1 0 0 0 1 0]
    output = "E";
    
elseif box == [1 1 0 1 0 0]
    output = "F";

elseif box == [1 1 0 1 1 0]
    output = "G";

elseif box == [1 1 0 0 1 0]
    output = "H";

elseif box == [0 1 0 1 0 0]
    output = "I";

elseif box == [0 1 0 1 1 0]
    output = "J";

elseif box == [1 0 1 0 0 0]
    output = "K";

elseif box == [1 1 1 0 0 0]
    output = "L";

elseif box == [1 0 1 1 0 0]
    output = "M";

elseif box == [1 0 1 1 1 0]
    output = "N";
    
elseif box == [1 0 1 0 1 0]
    output = "O";

elseif box == [1 1 1 1 0 0]
    output = "P";

elseif box == [1 1 1 1 1 0]
    output = "Q";

elseif box == [1 1 1 0 1 0]
    output = "R";

elseif box == [0 1 1 1 0 0]
    output = "S";

elseif box == [0 1 1 1 1 0]
    output = "T";

elseif box == [1 0 1 0 0 1]
    output = "U";

elseif box == [1 1 1 0 0 1]
    output = "V";

elseif box == [0 1 0 1 1 1]
    output = "W";

elseif box == [1 0 1 1 0 1]
    output = "X";
    
elseif box == [1 0 1 1 1 1]
    output = "Y";

elseif box == [1 0 1 0 1 1]
    output = "Z";
    
elseif box == [0 0 0 0 0 0]
    output = " ";
      
end
        
        