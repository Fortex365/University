function out = ba_kruznice(r, stred, velikost)
%BA_KRUZNICE Summary of this function goes here
%   Detailed explanation goes here

out = ones(velikost);

% offset, aby byla kruynice uprostred. Pripadne by zde 
offset_x = stred(1);
offset_y = stred(2);

devx = 3;
devy = 2*r - 2;

% rozhodovaci clen
p = 1 - r;

x = 0;
y = r;

while(x <= y)
    out(x+offset_x, y+offset_y) = 0;
    out(-x+offset_x, y+offset_y) = 0;
    out(x+offset_x, -y+offset_y) = 0;
    out(-x+offset_x,-y+offset_y) = 0;
    out(y+offset_y, x+offset_x) = 0;
    out(-y+offset_y, x+offset_x) = 0;
    out(y+offset_y, -x+offset_x) = 0;
    out(-y+offset_y,-x+offset_x) = 0;
    if (p >= 0)
        p = p - devy;
        devy = devy - 2;
        y = y - 1;
    end
    p = p + devx;
    devx = devx + 2;
    x = x+1;
end

end
