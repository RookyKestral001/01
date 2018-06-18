close all;
clear all;
clc;

%% ≤‚ ‘Bump Function

z = 0:0.01:1;
H = 0.1;
ph = zeros(length(z));
for i = 1:length(z)
    ph(i) = CalcBumpFunc( H, z(i));
end

figure(1);
plot(z, ph);
title('Bump Function');
