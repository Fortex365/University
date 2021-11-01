function vistform( tform,wz )

%transformace
xy = tformfwd(tform,wz);

%orezani vykresleni
minlim = min([wz;xy],[],1);
maxlim = max([wz;xy],[],1);
limits=[minlim(1), maxlim(1), minlim(2), maxlim(2)];
subplot(1,2,1), grid_plot(wz,limits,'w','z');
subplot(1,2,2), grid_plot(xy,limits,'x','y');

end


function grid_plot(ab,limits,a_label,b_label)

plot(ab(:,1),ab(:,2),'.','MarkerSize', 2);
axis equal, axis ij, axis(limits);
set(gca,'XAxisLocation','top');
xlabel(a_label),ylabel(b_label);

end

