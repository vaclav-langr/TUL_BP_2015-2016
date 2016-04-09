function [ vystup ] = podminka1( x, y, A, tau, odchylka )
indexy = find(abs(x) > odchylka);

L_term = (A(:, indexy))' * (A * x - y);

P_term = -tau * sign(x(indexy));

vystup = (sum(L_term < P_term) == length(indexy));
end