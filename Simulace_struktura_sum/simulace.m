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
    load('vysledekCVX-270416-104503.mat')
    tau = struktura.tau .* mean(struktura.kroky);
    clear i struktura
    struktura = struct();
    struktura.nastaveni.nazev_zalohy = ['vysledekL22-' datestr(now,'ddmmyy-HHMMSS') '.mat'];
    
    struktura.nastaveni.pocet_tau = 100;
    struktura.nastaveni.pocet_prvku = 100;
    struktura.nastaveni.pocet_radku = floor(struktura.nastaveni.pocet_prvku/2);
    struktura.nastaveni.pocet_opakovani = 1000;
    struktura.nastaveni.odchylka = 10^(-6);
    struktura.nastaveni.max_iter = 5000;
    struktura.x_orig = full(sprandn(struktura.nastaveni.pocet_prvku,1,0.1));
    struktura.A = randn(struktura.nastaveni.pocet_radku, struktura.nastaveni.pocet_prvku, struktura.nastaveni.pocet_opakovani);
%     struktura.tau = logspace(-6,2.7, struktura.nastaveni.pocet_tau);
    struktura.tau = tau;
    struktura.kroky = zeros(struktura.nastaveni.pocet_opakovani, struktura.nastaveni.pocet_tau);
    struktura.nastaveni.sigma = 0.1;
    
    startI = 1;
    clear tau
end

for i = startI:struktura.nastaveni.pocet_opakovani
    noise = struktura.nastaveni.sigma*randn(struktura.nastaveni.pocet_radku,1);
    y_orig = struktura.A(:,:,i)*struktura.x_orig + noise;
    for j = 1:struktura.nastaveni.pocet_tau
%         disp([i j])
        x_compute = ForwardBackward(y_orig,struktura.A(:,:,i),struktura.tau(j),struktura.nastaveni.odchylka,struktura.nastaveni.max_iter);
        struktura.kroky(i, j) = norm(struktura.x_orig - x_compute, 2)^2;
        struktura.kroky(i, j) = struktura.kroky(i, j) / mean(noise.^2);
    end
    save(struktura.nastaveni.nazev_zalohy, 'struktura', 'i');
end
save(struktura.nastaveni.nazev_zalohy, 'struktura')
plot(struktura.tau, sum(struktura.kroky)/struktura.nastaveni.pocet_opakovani)
set(gca,'xscale','log')
set(gca,'yscale','log')

clear ans i j startI vstup x_compute y_orig zaloha konec soubor