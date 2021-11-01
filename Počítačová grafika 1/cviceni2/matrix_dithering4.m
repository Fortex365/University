function [ vysl ] = matrix_dithering4( obrazek )
[w, h] = size(obrazek);
vysl = zeros(w, h);
patern = [
    16*255/17 15*255/17 14*255/17 13*255/17;
    12*255/17 11*255/17 10*255/17 9*255/17;
    8*255/17 7*255/17 6*255/17 5*255/17;
    4*255/17 3*255/17 2*255/17 1*255/17
    ];
display(patern);
for x = 1 : w
    for y = 1 : h
        px = obrazek(x, y);
        if  px > patern(mod(x,4)+1,mod(y,4)+1)
            vysl(x , y) = vysl(x , y) + 1;
        end
    end
end
end
