I = imread('picture1.png');
[h,w,o] = size(I);

J = I;
for i = 1 : h
    for j = 1 : w
        if(mod(I(i,j),2) == 1)
            J(i,j) = I(i,j) + 10;
            if(J(i,j) > 255)
                J(i,j) = 255;
            end
        else 
            J(i,j) = I(i,j) - 10;
            if(J(i,j) < 0)
                J(i,j) = 0
            end
        end
    end
end
imwrite(J,'result.png');