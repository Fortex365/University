function H = lpfilter(type, M, N, D0, n)
%LPFILTER Computes frequency domain lowpass filters
% TYPE 'ideal', 'btw', gaussian' 

[U, V] = dftuv(M, N);

% Vzdalenost D(U, V).
D = sqrt(U.^2 + V.^2);


switch type
case 'ideal'
   H = double(D <=D0);
case 'btw'
   if nargin == 4
      n = 1;
   end
   H = 1./(1 + (D./D0).^(2*n));
case 'gaussian'
   H = exp(-(D.^2)./(2*(D0^2)));
otherwise
   error('Neznamy filtr.')
end