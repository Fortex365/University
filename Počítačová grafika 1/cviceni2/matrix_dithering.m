function [ vysl ] = matrix_dithering( obrazek )
[w, h] = size(obrazek);
vysl = zeros(w * 2, h * 2);
patern = [4*255/5 3*255/5; 2*255/5 1*255/5];
display(patern);
for x = 1 : w
    for y = 1 : h
        px = obrazek(x, y);
        vysl(x * 2 - 1 : x * 2 + 0, y * 2 - 1 : y * 2 + 0) = patern < [px px; px px];
    end
end
end