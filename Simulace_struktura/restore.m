clear all
close all
clc

soubory = dir('*.mat');
for soubor = 1:size(soubory,1)
    load(soubory(soubor).name);
    figure
    plot(struktura.tau, sum(struktura.kroky)/struktura.nastaveni.pocet_opakovani)
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    title(soubory(soubor).name)
end