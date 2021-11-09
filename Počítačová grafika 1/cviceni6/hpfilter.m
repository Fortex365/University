function  O = hpfilter(type, M, N, D0)
[U, V] = dftuv(M, N);

Distance = sqrt(U .^ 2 + V .^ 2);

switch type
    
case 'ideal'
   O = double(Distance >= D0);

% by the way :D
case 'btw'
   if nargin == 4
      n = 1;
   end
   O = 1 - (1 ./ (1 + (Distance ./ D0) .^ (2 * n)));
   
case 'gaussian'
   O = 1 - (exp(- (Distance .^ 2) ./ (2 * (D0 ^ 2))));
   
otherwise
   error('NotImplemented filter :c')
   
end

