function [ vysl ] = matrix_dithering3( obrazek )
[w, h] = size(obrazek);
vysl = zeros(w, h);
patern = [4*255/5 3*255/5; 2*255/5 1*255/5];
display(patern);
for x = 1 : w
    for y = 1 : h
        px = obrazek(x, y);
        if  px > patern(mod(x,2)+1,mod(y,2)+1)
            vysl(x , y) = vysl(x , y) + 1;
        end
    end
end
end