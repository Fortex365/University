prologues := 3;

u := 10mm;
pen_width := 1;

%% function
start := -2.5;
finish := 4.5;
one_step := .01;

vardef f (expr X) = 
  abs(X**2 - 2X - 2)
enddef;

%% cross
x_min := start + 0.5;
x_max := finish - 0.5;
y_min := -1;
y_max := 10;
x_step := 1;
y_step := 1;
x_cross_size := .5;
y_cross_size := .5;

picture p[];

beginfig(0)
  pickup pencircle scaled pen_width;
  
  pair points[];
  points_count := 0;
  for i = start step one_step until finish:
    points[points_count] := ( i, f(i) );
    points_count := points_count + 1;
  endfor    
  
  for i = 1 upto (points_count-1): 
    draw (points[i-1] .. points[i]) scaled u withcolor .7red; 
  endfor

 
  p[0] := currentpicture;
endfig;

beginfig(1)
  %% X axis
  pickup pencircle scaled pen_width;
  drawarrow ((0, 0) -- (x_max+1, 0)) scaled u;  
  drawarrow ((0, 0) -- (x_min-1, 0)) scaled u; 
  pickup pensquare scaled pen_width;
  for i = x_min step x_step until x_max:
    draw ((i, -x_cross_size/2)--(i, x_cross_size/2)) scaled u;
    label.llft(decimal(i),(i,0) scaled u);
  endfor 
  label.top(btex $\overrightarrow{x\ }$ etex, (x_max+1, 0) scaled u);

  %% Y axis
  pickup pencircle scaled pen_width;
  drawarrow ((0, 0) -- (0, y_max+1)) scaled u;  
  drawarrow ((0, 0) -- (0, y_min-1)) scaled u; 
  pickup pensquare scaled pen_width;
  for i = y_min step y_step until y_max:
    draw ((-y_cross_size/2, i)--(y_cross_size/2, i)) scaled u;
    label.llft(decimal(i),(0,i) scaled u);
  endfor  
  label.rt(btex $\overrightarrow{y\ }$ etex, (0, y_max+1) scaled u);
 
  p[1] := currentpicture;
endfig;

beginfig(2)
  draw p[0];
  draw p[1];
  
  label.rt(btex $f(x) = \vert x^2 - 2x -2 \vert$ etex, (2, 10) scaled u);
endfig;

end