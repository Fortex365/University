function wz = pointgrid( corners )

%10 horizontalnich linii s 50 body
[w1,z1] = meshgrid(linspace(corners(1,1),corners(2,1), 46), linspace(corners(1),corners(2),10));

% 10 vertikalnich linii s 50 body
[w2,z2] = meshgrid(linspace(corners(1),corners(2), 10), linspace(corners(1),corners(2),46));

wz = [w1(:) z1(:); w2(:), z2(:)];

end

