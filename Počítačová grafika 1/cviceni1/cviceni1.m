%% Cvičení 1
% 
%% 
% * Seznámení s Matlabem
% * Příkazy, vektory, matice
% * Vytváření skriptů a funkcí
% * Práce s obrázky
%% 
% Matlab: více slidy (Martin Trnecka) <https://www.dropbox.com/s/idbyumx5xgi339a/matlab.pdf?dl=0 
% https://www.dropbox.com/s/idbyumx5xgi339a/matlab.pdf?dl=0>

% Nápověda k příkazům 
% help prikaz
help sum
%% Práce s obrázky

% nacteni obrazku
% imread(cesta);
I=imread('picture1.png');

% zobrazeni obrazku
% imshow(obrazek);
figure, imshow(I);

%%
% roztazeni intenzit (vsechny hodnoty mensi nez low budou nastaveny na 0,
% vsechny vetsi nez height na 255, a hodnoty mezi low a height budou
% roztazeny pravidelne mezi 0 a 255
% imshow(obrazek, [low,high]);
% [] na 0 je nastavena nejnizsi hodnota a na 255 nejvyssi
low = 48
high = 212
imshow(I,[low,high]);

%%
K = I/2;
imshow(K);
%%
imshow(K,[]);
%%


% hodnota pixelu na souradnicich 1, 1 (funkce display vypise vystup)
% I(x,y) 
% pozor indexuje se od 1
display(I(1,1));

% velikost obrazku, h - vyska obrazku (pocet radku), w - sirka obrazku
% (pocet sloupcu), o - dimenze urcujici kolik hodnot je potreba k
% reprezentaci informace o obraze, barevny = 3, sedotonovy = 1)
% size(promenna)

[h,w,o] = size(I);
display(h);
display(w);
display(o);

%%
I_rgb = imread("picture2.jpg");
figure, imshow(I_rgb);

display(I_rgb(1,1,:));

[h,w,o] = size(I);
display(h);
display(w);
display(o);
%%
% Vytvoreni vyrezu obrazku I(xmin:xmax, ymin:ymax)
xmin = 303
xmax = 479
ymin = 301
ymax = 850
J = I(xmin:xmax,ymin:ymax);

imshow(J);

%%
% vykresleni vice obrazku
% do noveho okna figure, imshow()
imshow(I);
figure, imshow(J);

%%
% vykresleni vice obrazku do jednoho
% subplot(pocetx, pocety, pozice), imshow()
subplot(1,2,1), imshow(I);
subplot(1,2,2), imshow(J);

%%
% Zobrazeni jednotlivych slozek obrazku

figure;
subplot(2,2,1), imshow(I_rgb);
subplot(2,2,2), imshow(I_rgb(:,:,1));
title('red');
subplot(2,2,3), imshow(I_rgb(:,:,2));
title('green');
subplot(2,2,4), imshow(I_rgb(:,:,3));
title('blue');
%%
% ulozeni obrazku
% imwrite(obrazek,cesta)
imwrite(J,"picture1small.png");
%%

% interaktivni prostredi pro praci s obrazky
% napriklad mereni vzdalenosti, prohlizeni hodnot jednotlivych obrazku
imtool(I);
%%
% cyklus for
for i = 1 : 10
    display(i);
end

%%
% cyklus while
i = 1;
while(i <= 10)
    display(i);
    i = i+1;
end

%%
% vetveni
i = 20
if (i > 0)
    display('vetsi');
else
    display('mensi');
end
%%
% pruchod obrazku pixel po pixelu (2 vnorene cykly)

for i = 1:h
    for j = 1:w
        L = 255-I;
    end
end

figure, imshow(L);
%%
% funkce

%    function I2 = negativ(I)
%    %NEGATIV Summary of this function goes here
%    %   Detailed explanation goes here
%
%          I2 = 255 - I;
%
%    end

M = negativ(I);
imshow(M);
%% Úkol 1
% Načtěte obrázek picture1.png a upravte ho následujícím způsobem:
% 
% pro pixely s lichou intenzitou přičtěte k intenzitě 10 (pozor na hodnoty > 
% 255) a od sudých oděčtěte 20 (pozor na hodnoty < 0). Uložte obrázek pomocí imwrite 
% a spolu s kódem odevzdejte.