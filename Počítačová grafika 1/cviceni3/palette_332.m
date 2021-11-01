function [B] = palette_332( A )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    B = A;
    [x, y, z] = size(A);

    for i = 1 : x
        for j = 1 : y
            B(i,j,1) = bitand(A(i,j,1), 224); %224 -> 11100000
            B(i,j,2) = bitand(A(i,j,2), 224);
            B(i,j,3) = bitand(A(i,j,3), 192); %192 -> 11000000
        end
    end



end