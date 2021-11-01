%% Cvičení 3
%% Indexovy obraz
% kazdy pixel uchovava index do nejake palety
% 
% paleta je matice m x 3 (hodnoty od 0 do 1) 

I = imread('picture1.png');
m = (0:255)/255;

map1 = [m' zeros(256,1) zeros(256,1)];

map2=[m' ones(256,1)  m'];

figure, imshow(I,map2);
%%
% UKOL 1
% vytvorte paletu tak, aby vysledkem aplikace byl negativ obrazku (kazda hodnota 
% i je rovna 255-i)
% Matlab colormapy
% parula, hsv, hot, cool, spring, summer, autumn, winter, gray, bone, copper, 
% pink, jet, lines, colorcube, prism, flag, white

I = imread('picture1.png');
map = colormap(parula);

m = (255 - (0:255))/255;
map = [m' m' m'];

figure, subplot(2,1,1), imshow(I,map);
subplot(2,1,2), imshow(cat(3, map(:,1)',map(:,2)', map(:,3)'));

%%
% zobrazeni palety - kazda slozka je graf
figure, rgbplot(map);

%% 3-3-2 paleta

map = create332palette();
% zobrazeni palety - kazda slozka je graf
figure, rgbplot(map);
%%
RGB = imread('picture2.jpg');
[J] = palette_332( RGB );

figure,
subplot(2,1,1), imshow(J);
subplot(2,1,2), imshow(cat(3, map(:,1)',map(:,2)', map(:,3)')); 

%%
RGB2 = imread('pav.jpg');
J2 = palette_332( RGB2 );

figure,
subplot(2,1,1), imshow(J2);
subplot(2,1,2), imshow(cat(3, map(:,1)',map(:,2)', map(:,3)')); 
%% Paleta prizpusobena obrazu (adaptivni)

% adaptivni paleta - spatne reseni (nejcastejsi vyskyt)

RGB1 = imread('picture2.jpg');
p1 = adaptivniPaleta(RGB1,256);

[X,map] = rgb2ind(RGB1,im2double(p1));

figure, subplot(2,1,1), imshow(X, map);
subplot(2,1,2), imshow(cat(3, p1(:,1)',p1(:,2)', p1(:,3)')); 

%%
% adaptivni paleta - spatne reseni (nejcastejsi vyskyt)

RGB2 = imread('pav.jpg');
p2 = adaptivniPaleta(RGB2,256);

[X2,map2] = rgb2ind(RGB2,im2double(p2));

figure, subplot(2,1,1), imshow(X2, map2);
subplot(2,1,2), imshow(cat(3, p2(:,1)',p2(:,2)', p2(:,3)')); 

%% Aritmeticke operace s obrazky
% Obrazky chapeme, jako matice, je mozne s nimi pracovat jako s ciselnymi maticemi.
% 
% Priklad pouziti:
% 
% Soucet - morfing obrazku
% 
% Rozdil - hledani zmen v obraze
% 
% Nasobeni - vynasobeni obrazku nejakou maskou - region of interest (ROI) 
% 
% Podil - Odstraneni stinu (pokud zname jeho funkci)
% Rozdil

% nacteni obrazku a vytvoreni druheho
I = imread('picture1.png');
I2 = bitand(I,254); %odstraneni informace z nejmene vyznamneho bitu

figure
subplot(1,3,1)
imshow(I)
title('Original')
subplot(1,3,2)
imshow(I2)
title('Upraveny')
subplot(1,3,3)
imshow(I-I2,[])
title('Rozdil')
% Na prvni pohled obrazky vypadají stejne na 3. je videt, ze rozdily mezi nimi 
% jsou (bile pixely)
%
%% Soucin
% pro nasobeni matic prvek po prvku se pouziva .* (* predstavuje klasicke nasobeni 
% matic). Stejne tak u deleni.

I = imread('picture1.png');

% ROI maska
maska = uint8(zeros(size(I)));
maska(384:584,379:590) = 1;

I2 = maska.*I;
figure
subplot(1,3,1)
imshow(I)
title('Original')
subplot(1,3,2)
imshow(maska,[])
title('Maska')
subplot(1,3,3)
imshow(I2)
title('Soucin')

%% UKOL 2
% Prolinani dvou obrazku - soucet dvou obrazku, ktere jsou vynásobeny koeficienty 
% predstavujici jednotlive pruhlednosti. ( soucet by mel byt roven jedne. Tedy: 
% pruhlednost * I + (1-pruhlednost) * J

I = rgb2gray(imread('img01.jpg'));
J = rgb2gray(imread('img2.jpg'));

% TODO
soucet=0.50*I + 0.50*J;

subplot(1,3,1)
imshow(I)
title('Obrazek 1')
subplot(1,3,2)
imshow(J)
title('Obrazek 2')
subplot(1,3,3)
imshow(soucet)
title('Soucet')

%% Logicke operace and, or, xor, not
% operace nad cernobilymi obrazky (vetsinou predstavujici nejakou oblast)

%vytvoreni 2 obrazku 
A = logical(zeros(500));
B = logical(zeros(500));

A(100:200, 100:400) = 1;
B(15:250, 15:250) = 1;

figure
subplot(1,2,1)
imshow(A)
title('A')
subplot(1,2,2)
imshow(B)
title('B')
%% AND

figure
subplot(1,3,1)
imshow(A)
title('A')
subplot(1,3,2)
imshow(B)
title('B')
subplot(1,3,3)
imshow(and(A,B))
title('and')
%% OR

figure
subplot(1,3,1)
imshow(A)
title('A')
subplot(1,3,2)
imshow(B)
title('B')
subplot(1,3,3)
imshow(or(A,B))
title('or')
%% XOR

figure
subplot(1,3,1)
imshow(A)
title('A')
subplot(1,3,2)
imshow(B)
title('B')
subplot(1,3,3)
imshow(xor(A,B))
title('xor')
%% NOT

figure
subplot(1,2,1)
imshow(A)
title('A')
subplot(1,2,2)
imshow(not(A))
title('not')