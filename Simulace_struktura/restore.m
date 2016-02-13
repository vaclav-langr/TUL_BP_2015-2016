clear all
close all
clc

soubory = dir('*.mat');
for soubor = 1:size(soubory,1)
    load(soubory(soubor).name);
    for radek = 1:size(struktura.kroky,1)
        if radek > 1
            plot(struktura.tau, sum(struktura.kroky(1:radek,:))/struktura.nastaveni.pocet_opakovani)
        else
            plot(struktura.tau, struktura.kroky(1:radek,:)/struktura.nastaveni.pocet_opakovani)
        end
        set(gca,'xscale','log')
        set(gca,'yscale','log')
        drawnow
        pause(0.1)
    end
    pause
end