function [ Circle, l ] = DrawCircle( x, y, r )
%DRAWCIRCLE 此处显示有关此函数的摘要
%   此处显示详细说明
theta = 0 : 0.3:(2*pi);
l = length(theta);
Circle1 = x + r*cos(theta);
Circle2 = y + r*sin(theta);

Circle = [Circle1; Circle2];  %[x;y] 两列
% c = [123, 14, 52];      %天蓝色
% plot(Circle1, Circle2, 'c', 'linewidth', 1);
plot(Circle1, Circle2, '.', 'color', 'r');
fill(Circle1, Circle2, 'r');
axis equal
hold on
end

