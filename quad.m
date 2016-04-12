clear all
close all
clc

warning('off')

pocet_tau = 100;
tau = logspace(-6,2.7, pocet_tau);
pocet_prvku = 100;
x = full(sprandn(pocet_prvku,1,0.1));
options = optimoptions('quadprog','Algorithm','trust-region-reflective','Display','off');

lb = -ones(pocet_prvku, 1);

hb = ones(pocet_prvku, 1);


Aeg = ones(pocet_prvku, 1);
Aeg(x == 0) = 0;
Aeg = diag(Aeg);

Beg = zeros(pocet_prvku, 1);
Beg(x < 0) = -1;
Beg(x > 0) = 1;

pocet_opakovani = 1000;
vysledek = zeros(pocet_opakovani, pocet_tau);
for i = 1:pocet_opakovani
    h = randn(1,pocet_prvku);
    for j = 1:length(tau)
        disp([i j])
        H = 2 * (tau(j) * tau(j))*diag(ones(pocet_prvku, 1));
        f = -2*tau(j).*h';
        s_compute = quadprog(H,f,[],[],Aeg,Beg,lb,hb,[], options);
        vysledek(i, j) = norm(h'-tau(j)*s_compute)^2;
    end
end
save('quadvysledek.mat')
warning('on')