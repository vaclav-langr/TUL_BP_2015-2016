clear all
close all
clc

load('quadvysledek-20-04-2016.mat')

figure
plot(tau, mean(struktura.kroky))
hold on
plot(tau, abs(log(mean(vysledek)./(struktura.nastaveni.pocet_radku-mean(vysledek)))), 'r')
hold off
set(gca,'xscale','log')
set(gca,'yscale','log')

figure
plot(tau, mean(struktura.kroky))
hold on
plot(tau, abs(log(mean(vysledek)./(struktura.nastaveni.pocet_prvku-mean(vysledek)))), 'r')
hold off
set(gca,'xscale','log')
set(gca,'yscale','log')