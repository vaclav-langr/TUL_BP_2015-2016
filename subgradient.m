clear all
close all
clc

pocet_prvku = 100;
x = full(sprandn(pocet_prvku,1,0.1));
s = zeros(pocet_prvku, 1);
s(x >= 0) = 1;
s(x < 0) = -1;