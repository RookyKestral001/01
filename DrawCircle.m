function [ Circle, l ] = DrawCircle( x, y, r )
%DRAWCIRCLE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
theta = 0 : 0.3:(2*pi);
l = length(theta);
Circle1 = x + r*cos(theta);
Circle2 = y + r*sin(theta);

Circle1Round = roundn(Circle1, -1);
Circle2Round = roundn(Circle2, -1);

Circle = [Circle1Round; Circle2Round];  %[x;y] ����
% c = [123, 14, 52];      %����ɫ
% plot(Circle1, Circle2, 'c', 'linewidth', 1);
plot(Circle1, Circle2, '.', 'color', 'r');
fill(Circle1, Circle2, 'r');
axis equal
hold on
end

