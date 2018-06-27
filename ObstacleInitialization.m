function [ obsmat, CM, NumObs ] = ObstacleInitialization( )
%OBSTACLEINITIALIZATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
obsmat = [100, 110, 120, 130, 150, 160; 20, 60, 40, -20, 40, 0; 10, 4, 2, 5, 5, 3];
CM = [];
NumObs = size(obsmat, 2);
for i = 1:NumObs;
    [ C, len ] = DrawCircle( obsmat(1, i), obsmat(2, i), obsmat(3, i) );
    CM = [CM C]; 
end

axis([-50, 500, -50, 100]);    % axis([xmin xmax ymin ymax])
xlabel('x (m)');
ylabel('y (m)');
title('Map');
end

