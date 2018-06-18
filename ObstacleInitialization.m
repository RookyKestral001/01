function [ CM ] = ObstacleInitialization( )
%OBSTACLEINITIALIZATION 此处显示有关此函数的摘要
%   此处显示详细说明
M = [100, 110, 120, 130, 150, 160; 20, 60, 40, -20, 40, 0; 10, 4, 2, 5, 5, 3]
CM = [];
for i = 1:size(M, 2);
    [ C, len ] = DrawCircle( M(1, i), M(2, i), M(3, i) );
    CM = [CM C];
end

axis([-50, 300, -50, 100]);    % axis([xmin xmax ymin ymax])
xlabel('x (m)');
ylabel('y (m)');
title('Map');
end

