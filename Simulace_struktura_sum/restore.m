clear all
close all
clc

figure
load('vysledekCVX-270416-104503.mat')
loglog(struktura.tau, abs(log(mean(struktura.kroky)./(struktura.nastaveni.pocet_radku - mean(struktura.kroky)))), 'r')
hold on
load('vysledekL22-270416-201252.mat')
loglog(struktura.tau, mean(struktura.kroky), 'b')
legend('analyza', 'simulace')
legend('show')
title('Prumer simulace + vzorec pro analyzu z clanku')
hold off

figure
load('vysledekCVX-270416-104503.mat')
loglog(struktura.tau, mean(struktura.kroky), 'r')
hold on
load('vysledekL22-270416-201252.mat')
loglog(struktura.tau, mean(struktura.kroky), 'b')
legend('analyza', 'simulace')
legend('show')
title('Prumery')
hold off