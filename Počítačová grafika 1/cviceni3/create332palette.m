function map = create332palette()

    k = 0;
    map = uint8(zeros(256,3));
    for i = 1 : 256
            map(i,1) = floor((bitshift(k,-5) * 255) / 7);
            map(i,2) = floor(((bitand(bitshift(k,-2), 7)) * 255) / 7);
            map(i,3) = floor((bitand(k,3) * 255) / 3);
            k = k + 1;
    end
    
    
end

