function [q, p, u, qr, pr, qt, pt, qrt, prt, urt] = FlockInitialization(Dim, posR, N, Frames )
%FLOCKINITIALIZATION 此处显示有关此函数的摘要
%   此处显示详细说明

% q = posR * rand(Dim, N);
% p = 2 * rand(Dim, N) - 1;
% u = zeros(Dim, N);
% qr = posR * rand(Dim, 1);
% pr = 2 * rand(Dim, 1) - 1;

% q = randi([-40, 80], Dim, N);
q = randi([-80, 40], Dim, N);
p = zeros(Dim, N);
u = zeros(Dim, N);
qr = [200; 10];
pr = [5; 0];

qt = zeros(Dim, N, Frames);
pt = zeros(Dim, N, Frames);
qrt = zeros(Dim, Frames);
prt = zeros(Dim, Frames);
urt = zeros(Dim, Frames);

end

