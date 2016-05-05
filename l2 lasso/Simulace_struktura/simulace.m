clear all
close all
clc

i = 0;
zaloha = dir('*.mat');

if ~isempty(zaloha)
    konec = false;
    while ~konec
        for soubor=1:length(zaloha)
            disp(['[' num2str(soubor) '] - ' zaloha(soubor).name])
        end
        disp('[0] - None')
        vstup = input('Select file: ');
        if vstup == 0
            konec = true;
            startI = 1;
        elseif (vstup >= 1 && vstup <= length(zaloha))
            konec = true;
            load(zaloha(vstup).name)
            vstup = 1;
            if exist('i','var') && i > 0
                startI = i+1;
            else
                startI = struktura.nastaveni.pocet_opakovani + 1;
            end
        end
    end
else
    vstup = 0;
end
if vstup == 0
    struktura = struct();
    struktura.nastaveni.nazev_zalohy = ['vysledek-' datestr(now,'ddmmyy-HHMMSS') '.mat'];
    
    struktura.nastaveni.pocet_tau = 100;
    struktura.nastaveni.pocet_prvku = 100;
    struktura.nastaveni.pocet_radku = floor(struktura.nastaveni.pocet_prvku/2);
    struktura.nastaveni.pocet_opakovani = 1000;
    struktura.nastaveni.odchylka = 10^(-6);
    struktura.nastaveni.max_iter = 15000;
    struktura.x_orig = full(sprandn(struktura.nastaveni.pocet_prvku,1,0.1));
    struktura.A = randn(struktura.nastaveni.pocet_radku, struktura.nastaveni.pocet_prvku, struktura.nastaveni.pocet_opakovani);
    struktura.tau = logspace(-6,2.7, struktura.nastaveni.pocet_tau);
    struktura.kroky = zeros(struktura.nastaveni.pocet_opakovani, struktura.nastaveni.pocet_tau);
    
    startI = 1;
end

for i = startI:struktura.nastaveni.pocet_opakovani
    sum = random('normal', 0, 10^-(2), struktura.nastaveni.pocet_radku, 1);
    y_orig = struktura.A(:,:,i)*struktura.x_orig + sum;
    for j = 1:struktura.nastaveni.pocet_tau
%         disp([i j])
        x_compute = ForwardBackward(y_orig,struktura.A(:,:,i),struktura.tau(j),struktura.nastaveni.odchylka,struktura.nastaveni.max_iter);
        struktura.kroky(i, j) = norm(struktura.x_orig - x_compute, 2)^2;
        struktura.kroky(i, j) = struktura.kroky(i, j) / mean(sum.^2);
    end
    save(struktura.nastaveni.nazev_zalohy, 'struktura', 'i');
end
save(struktura.nastaveni.nazev_zalohy, 'struktura')

clear ans command i j startI vstup x_compute y_orig zaloha konec soubor