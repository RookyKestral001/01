close all;
clear all;
clc;
%% -----------------参数赋值-----------------
Frames = 500;                 %帧数
Dim = 2;                      %维度

Num = 10;                     %无人机的个数
NumFollow = 50;                       %领导影响无人机个数

Sigma = 0.1;                  %计算norm的参数
R = 6;                        %无人机感知无人机半径
R_delta = CalcDeltaNorm( Sigma, R );

RObs = 5;                     %无人机感知障碍物半径
RObs_delta = CalcDeltaNorm( Sigma, RObs );

D = 5;                        %网格alpha-lattice的尺寸scale      
D_delta = CalcDeltaNorm( Sigma, D ); %网格尺寸的delta-norm

DObs = 25/6;                  %无人机与障碍的网格尺寸
DObs_delta =CalcDeltaNorm( Sigma, DObs );

K = R/D;                      %ratio
H = 0.1;                      %bump function的参数

PosRange = 50;                    %无人机初始时刻位置范围
StepLength = 0.1;                    %每一帧是0.1s

%势函数中的uneven sigmoidal function的参数0<a<=b, c用来保证phy(0) = 0  
a = 1;                        
b = 2;                        
c = abs(a - b)/sqrt(4*a*b);

ca1 = 0;
ca2 = 0;
cb1 = 0;
cb2 = 10;
%导航反馈速度分量中的参数，均大于0
cr1 = 0.1;
cr2 = 0.15;

AObsAll = [];
dObsAll = [];
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
    set (gca,'position',[0.03 0 0.95 1] );
    set (gcf,'position',[20 50 1500 700] );

%% -----------------主要部分-----------------
    %画出障碍物地图
    [ obsmat, CM, NumObs ] = ObstacleInitialization( ); %M为障碍物的圆心坐标和半径，CM为障碍物边缘的点坐标，NumObs为障碍物个数
    %记录Flock内所有无人机位置、速度信息
    [ ur, qmat, pmat, qrmat, prmat, urmat ] = FlockRecord( iRound, q, p, qr, pr ); 
    
    %%%%每架无人机搜索身边是否有障碍物存在
    
    %计算beta-agent
    [ q_beta, p_beta ] = CalcBetaAgent( q, p, obsmat, Dim, Num, NumObs );
    
    %计算Adjacency Matrix
    [ A, d ] = CalcAdjMat( Num, R, q ); 
    %计算beta Adjacency Matrix 表示无人机与障碍的邻接矩阵
    [ AObs, dObs ] = CalcBetaAdjMat( Num, NumObs, RObs, DObs_delta, Sigma, H, q, q_beta );
    
    AObsAll = [AObsAll; AObs];
    dObsAll = [dObsAll; dObs];
    
    %计算加速度u_alpha的分量gradient-based term
    [ u_alpha_gradient ] = CalcGradientTerm( Dim, Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q );
    %计算加速度u_alpha的分量consensus term
    [ u_alpha_consensus ] = CalcConsensusTerm( Dim, Num, A, p );
    
    %计算加速度u_beta的分量gradient-based term
    [ u_beta_gradient ] = CalcBetaGradientTerm( Dim, Num, NumObs, Sigma, H, DObs_delta, RObs_delta, AObs, dObs, q, q_beta );
    %计算加速度u_beta的分量consensus term
    [ u_beta_consensus ] = CalcBetaConsensusTerm( Dim, Num, NumObs, AObs, p, p_beta );
    
    %计算加速度u_gamma，navigational feedback
    [ u_gamma ] = CalcNaviTerm( Num, NumFollow, cr1, cr2, q, p, qr, pr );
    %计算每个无人机的总加速度，并更新所有无人机的速度与位置
    for i = 1:Dim
        for j = 1:Num
            u(i, j) = ca1*u_alpha_gradient(i, j) + ca2*u_alpha_consensus(i, j) + cb1 * u_beta_gradient(i, j) + cb2 * u_beta_consensus(i, j) + u_gamma(i, j);
            p(i, j) = p(i, j) + StepLength * u(i, j);
            q(i, j) = q(i, j) + StepLength * p(i, j);            
        end
        pr(i, 1) = pr(i, 1) + StepLength * ur(i, 1);
        qr(i, 1) = qr(i, 1) + StepLength * pr(i, 1);        
    end
    
    DrawFlock( Num, iRound, qmat, pmat, q_beta, p_beta, qr, pr );
    
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