function [paleta] = adaptivniPaleta(I,pocet_barev)

color_map = zeros([256,256,256]);
[m,n,o] = size(I);
paleta =uint8( []);

for i = 1:m
    for j = 1:n
            color_map(I(i,j,1)+1,I(i,j,2)+1,I(i,j,3)+1) = color_map(I(i,j,1)+1,I(i,j,2)+1,I(i,j,3)+1) +1;
    end
end


[B,I] = maxk(color_map(:),pocet_barev);

for i = 1:256
    for j = 1:256
        for k = 1 : 256
            if(color_map(i,j,k) >= min(B))
                    paleta = [paleta;[i-1,j-1,k-1]];
            end
        end
    end
end

end

