%% Cvičení 2
%% RGB to GRAY

I_rgb = imread('pastelky2.jpg');
figure, subplot(1,3,1), imshow(I_rgb);
% prumerovanim slozek

gray1 = (1/3)*I_rgb(:,:,1) + (1/3)*I_rgb(:,:,2) + (1/3)*I_rgb(:,:,3);
subplot(1,3,2), imshow(gray1,[]);

% vazeny prumer

gray2 = rgb2gray(I_rgb);
subplot(1,3,3), imshow(gray2,[]);
%% RGB to CMY

I_cmy = rgb2cmy(I_rgb);
%I = 255 - I2;
I_rgb2 = cmy2rgb(I_cmy);

figure, subplot(2,2,1), imshow(I_rgb);
title('RGB'); 
subplot(2,2,2), imshow(I_cmy);
title('CMY'); 
subplot(2,2,3), imshow(I_rgb2);
title('RGB');
%% CMY to RGB

I_rgb = imcomplement(I_cmy);
%I = 255 - I2;

figure, subplot(1,2,1), imshow(I_rgb);
title('RGB'); 
subplot(1,2,2), imshow(I_cmy);
title('CMY');
%% RGB to HSV

I_hsv = rgb2hsv(I_rgb);

figure, subplot(2,2,1), imshow(I_rgb);
title('RGB'); 
subplot(2,2,2), imshow(I_hsv(:,:,1));
title('hue'); 
subplot(2,2,3), imshow(I_hsv(:,:,2));
title('saturation'); 
subplot(2,2,4), imshow(I_hsv(:,:,3));
title('value');
%% HSV to RGB

I_rgb2 = hsv2rgb(I_hsv);

figure, imshow(I_rgb2);
%% RGB to YCbCr

I_ycbcr = rgb2ycbcr(I_rgb);

figure, subplot(2,2,1), imshow(I_rgb);
title('RGB'); 
subplot(2,2,2), imshow(I_ycbcr(:,:,1));
title('Y'); 
subplot(2,2,3), imshow(I_ycbcr(:,:,2));
title('Cb'); 
subplot(2,2,4), imshow(I_ycbcr(:,:,3));
title('Cr');
%% YCbCr to RGB

I_rgb2 = ycbcr2rgb(I_ycbcr);

figure, imshow(I_rgb2);

%% Rozliseni 
% skutecna velikost obrazu pri tisku

B = imread('pastelky2.jpg');

imwrite(B, 'p1.tif','resolution',[1000,1000]);
imfinfo('p1.tif')
imwrite(B, 'p2.tif','resolution',[500,500]);
imfinfo('p2.tif')
imwrite(B, 'p3.tif','resolution',[250,250]);
imfinfo('p3.tif')

%% Rozliseni 
% velikost obrazu

B1 = imresize(B,0.5);
B2 = imresize(B,0.2);
B3 = imresize(B,0.1);
B4 = imresize(B,0.05);
B5 = imresize(B,0.01);

figure, subplot(2,3,1), imshow(B);
title('original'); 
subplot(2,3,2), imshow(B1);
title('0.5'); 
subplot(2,3,3), imshow(B2);
title('0.2'); 
subplot(2,3,4), imshow(B3);
title('0.1');
subplot(2,3,5), imshow(B4);
title('0.05'); 
subplot(2,3,6), imshow(B5);
title('0.01');

%% Barevna hloubka

B = imread('picture1.png');
Bi = gray2ind(B,256);
Bi1 = gray2ind(B,64);
Bi2 = gray2ind(B,16);
Bi3 = gray2ind(B,8);
Bi4 = gray2ind(B,4);
Bi5 = gray2ind(B,2);


figure, subplot(2,3,1), imshow(Bi,[]);
title('original'); 
subplot(2,3,2), imshow(Bi1,[]);
title('64'); 
subplot(2,3,3), imshow(Bi2,[]);
title('16'); 
subplot(2,3,4), imshow(Bi3,[]);
title('8');
subplot(2,3,5), imshow(Bi4,[]);
title('4'); 
subplot(2,3,6), imshow(Bi5,[]);
title('2')

%% Interpolace
% Nejblizsi soused
% (Nearest neighbor)

I = [1 0 1 0 1];
J_near = imresize(I,1.5,'nearest');

figure, imshow(J_near);

%%
B = imread('picture1.png');
B1a = imresize(B,0.5, 'nearest');
B2a = imresize(B,0.1, 'nearest');
B3a = imresize(B,2, 'nearest');
B4a = imresize(B,3, 'nearest');
B5a = imresize(B,5, 'nearest');

figure, subplot(2,3,1), imshow(B);
title('original'); 
subplot(2,3,2), imshow(B1a);
title('0.5'); 
subplot(2,3,3), imshow(B2a);
title('0.1'); 
subplot(2,3,4), imshow(B3a);
title('2');
subplot(2,3,5), imshow(B4a);
title('3'); 
subplot(2,3,6), imshow(B5a);
title('5');

% Bilinearni 

I = [1 0 1 0 1];
J_bilin = imresize(I,1.5,'bilinear');

figure, imshow(J_bilin);
%%
B1b = imresize(B,0.5, 'bilinear');
B2b = imresize(B,0.1, 'bilinear');
B3b = imresize(B,2, 'bilinear');
B4b = imresize(B,3, 'bilinear');
B5b = imresize(B,4, 'bilinear');

figure, subplot(2,3,1), imshow(B);
title('original'); 
subplot(2,3,2), imshow(B1b);
title('0.5'); 
subplot(2,3,3), imshow(B2b);
title('0.1'); 
subplot(2,3,4), imshow(B3b);
title('2');
subplot(2,3,5), imshow(B4b);
title('3'); 
subplot(2,3,6), imshow(B5b);
title('5');

% Bikubicka

I = [1 0 1 0 1];
J_bicub = imresize(I,1.5,'bicubic');

figure, imshow(J_bicub);

%%

B1c = imresize(B,0.5, 'bicubic');
B2c = imresize(B,0.1, 'bicubic');
B3c = imresize(B,2, 'bicubic');
B4c = imresize(B,3, 'bicubic');
B5c = imresize(B,5, 'bicubic');

figure, subplot(2,3,1), imshow(B);
title('original'); 
subplot(2,3,2), imshow(B1c);
title('0.5'); 
subplot(2,3,3), imshow(B2c);
title('0.1'); 
subplot(2,3,4), imshow(B3c);
title('2');
subplot(2,3,5), imshow(B4c);
title('3'); 
subplot(2,3,6), imshow(B5c);
title('5');

%%
figure,
subplot(1,3,1), imshow(J_near);
title('nejblizsi soused'); 
subplot(1,3,2), imshow(J_bilin);
title('bilinearni'); 
subplot(1,3,3), imshow(J_bicub);
title('bikubicka'); 
%% Snizeni barevne hloubky
% Nahodne rozptylovani
% zpracovani prvek po prvku

I = imread('skala.png');

Cmax = max(max(I));

J = uint8(zeros(size(I,1),size(I,2)));

for i = 1 : size(I,1)
    for j = 1 : size(I,2)
        % randi vrati nahodne cislo
        r = randi(Cmax);
        if I(i,j) > r
            J(i,j) = J(i,j) +1;
        end
    end
end

figure
subplot(1,2,1)
imshow(I,[])
subplot(1,2,2)
imshow(J,[]);

%% 
% zpracovani pomoci maticovych operaci

I = imread('skala.png');
[m,n] = size(I);
Cmax = max(max(I));
J = uint8(zeros(size(I,1),size(I,2)));

J = J + uint8(I >= randi(Cmax,[m,n]));
figure
subplot(1,2,1)
imshow(I,[]);
subplot(1,2,2)
imshow(J,[]);
% Spatny pristup
% porovnavaji se vsechny pixely se stejnou hodnotou.

I = imread('skala.png');
[m,n] = size(I);
Cmax = max(max(I));
J = uint8(zeros(size(I,1),size(I,2)));

J = (I >= randi(Cmax)); 

figure
subplot(1,2,1)
imshow(I,[]);
subplot(1,2,2)
imshow(J,[]);

% Maticove rozptylovani
% Zvetseni velikosti obrazu


I2 = imread('skala.png');
[ J ] = matrix_dithering( I2 );

figure
subplot(1,2,1)
imshow(I2,[]);
subplot(1,2,2)
imshow(J,[]);

% Nevhodne zvolene matice

I2 = imread('skala.png');
[ J ] = matrix_dithering2( I2 );

figure
subplot(1,2,1)
imshow(I2,[]);
subplot(1,2,2)
imshow(J,[]);

% Maticove rozptylovani se zachovanim velikosti

I2 = imread('skala.png');
[ J ] = matrix_dithering3( I2 );

figure
subplot(1,2,1)
imshow(I2,[]);
subplot(1,2,2)
imshow(J,[]);
%% Ukol 1
% Upravte funkci matrix_dithering3 tak, aby k rozptylovani pouzila matici 4x4. 
% Vyzkousejte ruzne matice. Odevzdejte kod (pripadne kody) a alespon 2 obrazky, 
% ktere vznikly maticovym rozptylovanim s ruznyma maticema.
% Rozptylovani s distribuci chyby
% Floyd Steinberg


I2 = imread('picture1.png');
J = floyd_steinberg( I2 );

I3 = imread('picture1.png');
[ P ] = matrix_dithering4( I3 );

I4 = imread('skala.png');
[ G ] = matrix_dithering4( I4 );

figure
subplot(1,4,1);
imshow(I2,[]);

subplot(1,4,2);
imshow(J,[]);

subplot(1,4,3);
imshow(P,[]);

subplot(1,4,4);
imshow(G,[]);
%% Ukol 2
% Napiste skript na barevne nahodne rozptylovani, maticove rozptylovani a rozptylovani 
% s distribuci chyby. 
% Napoveda:
% Kazda barevna slozka se zpracovava zvlast.
%% 2.1 Rozptylovaní
I = imread('pastelky2.jpg');
I_red = I(:,:,1);
I_green = I(:,:,2);
I_blue = I(:,:,3);
 
J=[];

[m,n] = size(I_red);
Cmax = max(max(I_red));
J_red = uint8(zeros(m,n));
J_red = J_red + uint8(I >= randi(Cmax, [m,n]));

Cmax = max(max(I_green));
J_green = uint8(zeros(m,n));
J_green = J_green + uint8(I >= randi(Cmax, [m,n]));

Cmax = max(max(I_blue));
J_blue = uint8(zeros(m,n));
J_blue = J_blue + uint8(I >= randi(Cmax, [m,n]));


J(:,:,1) = J_red;
J(:,:,2) = J_green;
J(:,:,3) = J_blue;
%% 2.2 Floyd
I = imread('pastelky2.jpg');

I_red = I(:,:,1);
I_green = I(:,:,2);
I_blue = I(:,:,3);

J = [];

J_red = floyd_steinberg(I_red);
J_green = floyd_steinberg(I_green);
J_blue = floyd_steinberg(I_blue);

J(:,:,1) = J_red;
J(:,:,2) = J_green;
J(:,:,3) = J_blue;

imshow(J,[]);


%%  2.3 Matrix dithering :)
I = imread('pastelky2.jpg');
I_red = I (:,:,1);
I_green = I (:,:,2);
I_blue = I(:,:,3);

J = [];

[J_red] = matrix_dithering3(I_red);
[J_green] = matrix_dithering3(I_green);
[J_blue] = matrix_dithering3(I_blue);

J(:,:,1) = J_red;
J(:,:,2) = J_green;
J(:,:,3) = J_blue;

imshow(J,[]);
