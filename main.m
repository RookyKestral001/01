close all;
clear all;
clc;
%% -----------------参数赋值-----------------
Frames = 500;                 %帧数
Dim = 2;                      %维度

Num = 40;                     %无人机的个数
NumFollow = 50;                       %领导影响无人机个数

Sigma = 0.1;                  %计算norm的参数
R = 6;                        %无人机感知半径
R_delta = CalcDeltaNorm( Sigma, R);
D = 5;                        %网格alpha-lattice的尺寸scale
D_delta = CalcDeltaNorm( Sigma, D ); %网格尺寸的delta-norm
K = R/D;                      %ratio
H = 0.1;                      %bump function的参数

PosRange = 50;                    %无人机初始时刻位置范围
StepLength = 0.1;                    %每一帧是0.1s

%势函数中的uneven sigmoidal function的参数0<a<=b, c用来保证phy(0) = 0  
a = 1;                        
b = 2;                        
c = abs(a - b)/sqrt(4*a*b);

%导航反馈速度分量中的参数，均大于0
c1 = 0.1;
c2 = 0.2;
%% -----------------无人机状态初始化-----------------
%q：初始时刻位置 p：初始时刻速度 u：初始时刻加速度 
%qr:初始时刻领导位置 pr：初始时刻领导速度
%qmat：所有时刻位置 pmat：所有时刻速度 
%prmat：所有时刻领导位置 qrmat：所有时刻领导速度 urmat：所有时刻领导加速度
[ q, p, u, qr, pr, qmat, pmat, qrmat, prmat, urmat ] = FlockInitialization( Dim, PosRange, Num, Frames );
%% -----------------地图中障碍物初始化-----------------
% [ CM ] = ObstacleInitialization( );
%% -----------------循环-----------------
%-----------------视频设置-----------------
% figure;
% H = 900;
% W = 1600;
mov = VideoWriter('Flock1806.avi');
mov.FrameRate = 30;  %帧率，默认30
obj.Quality = 100; %视频质量，[0, 100]
open(mov);
tic
    
for iRound = 1:Frames
    clf;
%     set(gcf, 'color', [1 1 1]); %白色背景
%     title('Process');
%     axis([1 120 1 120]);

%% -----------------主要部分-----------------
    %画出障碍物地图
    [ CM ] = ObstacleInitialization( );
    %记录Flock内所有无人机位置、速度信息
    [ ur, qmat, pmat, qrmat, prmat, urmat ] = FlockRecord( iRound, q, p, qr, pr ); 
    %计算Adjacency Matrix
    [ A, d ] = CalcAdjMat( Num, R, q ); 
    %计算加速度u_alpha的分量gradient-based term
    [ u_alpha_gradient ] = CalcGradientTerm( Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q );
    %计算加速度u_alpha的分量consensus term
    [ u_alpha_consensus ] = CalcConsensusTerm( Num, A, p );
    %计算加速度u_gamma，navigational feedback
    [ u_gamma ] = CalcNaviTerm( Num, NumFollow, c1, c2, q, p, qr, pr );
    %计算每个无人机的总加速度，并更新所有无人机的速度与位置
    for i = 1:2
        for j = 1:Num
            u(i, j) = u_alpha_gradient(i, j) + u_alpha_consensus(i, j) + u_gamma(i, j);
            p(i, j) = p(i, j) + StepLength * u(i, j);
            q(i, j) = q(i, j) + StepLength * p(i, j);            
        end
        pr(i, 1) = pr(i, 1) + StepLength * ur(i, 1);
        qr(i, 1) = qr(i, 1) + StepLength * pr(i, 1);        
    end
    DrawFlock( Num, iRound, qmat, pmat );
    
%% 
    frame1 = getframe(gcf); %复制当前图形，gcf为get current figure，包括legend、title和label。不写gcf时默认为gca（axis）
%     frame1.cdata = imresize(frame1.cdata, [H W]); %视频分辨率
    writeVideo(mov, frame1);
%     pause(0.5);
end

toc
mov.close();

% figure;
% flock0.coherenceCal();