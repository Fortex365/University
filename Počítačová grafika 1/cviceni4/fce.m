function [posunuti, zvetseni_x, zvetseni_y] = register(I,J)
moved = [];
for i = 1 : size(I,1)
    for j = 1 : size(I,2)
        if(I(i,j)==0)
            moved=[moved;i j];
        end
    end
end
Ilh = moved(1,:)
Ipd = moved(end,:)

scaled = [];
for i = 1 : size(J,1)
    for j = 1 : size(J,2)
        if(J(i,j) == 0)
            scaled=[scaled;i j];
        end
    end
end
Jlh = scaled(1,:)
Jpd = scaled(end,:)
% return
posunuti = Jpd - Ipd;
zvetseni_x = (Jpd(1) - Jlh(1))/ (Ipd(1) - Ilh(1));
zvetseni_y = (Jpd(2) - Jlh(2)) / (Ipd(2) - Ilh(2));
end

