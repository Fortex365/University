function out = ba_prerusovana2(A,B,velikost, delka)

dx = B(1)-A(1);
dy = B(2)-A(2);

delka = round((abs(dx) / sqrt(dx^2 + dy^2) )*delka);
aktualni_delka = delka;
plny = 1;

out = ones(velikost);

% nastaveni offsetu pro primky se souradnicema <=0

if (A(1) <=0 || B(1) <= 0)
    offset_x = - min(A(1),B(1)) + 1;
else
    offset_x = 0;
end

if (A(2) <=0 || B(2) <= 0)
    offset_y = - min(A(2),B(2)) + 1;
else
    offset_y = 0;
end


% z koncovych bodu se urci konstanty

k1 = 2*dy;
k2 = 2*(dy-dx);

% rozhodovaci clen
p = 2*(dy-dx);

%inicializace [x,y]
x = A(1);
y = A(2);

while(x <= B(1))
    x = x +1;
    if (p >0)   % p je kladne
        y = y +1;
        p = p + k2;
    else        % p neni kladne
        p = p + k1;
    end
    
    %vykresleni jen, pokud je v plnem useku
    if(plny == 1)
        out(y+offset_y, x+offset_x) = 0;  %vykresleni bodu   (v obrazcich je prvni souradnice sloupec a druhy radek)
    end
    
    aktualni_delka = aktualni_delka -1;
    if(aktualni_delka ==0)
        if(plny == 1)
            plny = 0;
        else
            plny = 1;
        end
        aktualni_delka = delka;
    end
        
end

out = flipud(out);  % otoceni obrazku
end

