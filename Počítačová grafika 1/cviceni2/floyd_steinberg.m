function [ outputPicture ] = floyd_steinberg( inputPicture )

[rows, columns] = size(inputPicture);
outputPicture = zeros(rows, columns);

for i = 1 : rows
    for j = 1 : columns
        oldPixel = double(inputPicture(i, j));
              
        newPixel = findClosestPaletteColor(oldPixel);
        outputPicture(i, j) = newPixel;        
        quantError = oldPixel - newPixel;
        
        if ((i + 1) <= rows)
            inputPicture(i + 1, j) = inputPicture(i + 1, j) + quantError * 7 / 16;
            
            if ((j + 1) <= columns)
                inputPicture(i + 1, j + 1) = inputPicture(i + 1, j + 1) + quantError * 1 / 16;             
            end
        end
        
        if ((j + 1) <= columns)
            inputPicture(i, j + 1) = inputPicture(i, j + 1) + quantError * 5 / 16;
        end
        
        if (((j + 1) <= columns) && ((i - 1) >= 1))
            inputPicture(i - 1, j + 1) = inputPicture(i - 1, j + 1) + quantError * 3 / 16;
        end 
    end
end
end

function [ newPixel ] = findClosestPaletteColor( oldPixel )
if oldPixel > 128
 newPixel = 255;
else
 newPixel = 0;
end
end


