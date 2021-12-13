function kod = cs_kod(bod_oblasti1,bod_oblasti2, bod)
%CS_KOD Summary of this function goes here
%   Detailed explanation goes here

kod = [0 0 0 0];

% TO DO 
% vypocet kodu


% znazorneni
min_x = min(bod_oblasti1(1),bod(1)) - 20;
min_y = min(bod_oblasti1(2),bod(2)) - 20;
offset_x = 1 - min_x;
offset_y = 1 - min_y;

max_x = max(bod_oblasti2(1),bod(1)) + 20;
max_y = max(bod_oblasti2(2),bod(2)) + 20;

obr = ones(max_x-min_x, max_y - min_y);
obr(bod_oblasti1(1) + offset_x:bod_oblasti2(1) + offset_x,bod_oblasti1(2) + offset_y) = 0.2; 
obr(bod_oblasti1(1) + offset_x:bod_oblasti2(1) + offset_x,bod_oblasti2(2) + offset_y) = 0.2;
obr(bod_oblasti1(1) + offset_x,bod_oblasti1(2) + offset_y:bod_oblasti2(2) + offset_y) = 0.2;
obr(bod_oblasti2(1) + offset_x,bod_oblasti1(2) + offset_y:bod_oblasti2(2) + offset_y) = 0.2;
obr(bod(1) + offset_x,bod(2) + offset_y) = 0;
imshow(obr);
end

