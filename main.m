close all;
clear all;
clc;
%% -----------------������ֵ-----------------
Frames = 500;                 %֡��
Dim = 2;                      %ά��

Num = 10;                     %���˻��ĸ���
NumFollow = 50;                       %�쵼Ӱ�����˻�����

Sigma = 0.1;                  %����norm�Ĳ���
R = 6;                        %���˻���֪���˻��뾶
R_delta = CalcDeltaNorm( Sigma, R );

RObs = 5;                     %���˻���֪�ϰ���뾶
RObs_delta = CalcDeltaNorm( Sigma, RObs );

D = 5;                        %����alpha-lattice�ĳߴ�scale      
D_delta = CalcDeltaNorm( Sigma, D ); %����ߴ��delta-norm

DObs = 25/6;                  %���˻����ϰ�������ߴ�
DObs_delta =CalcDeltaNorm( Sigma, DObs );

K = R/D;                      %ratio
H = 0.1;                      %bump function�Ĳ���

PosRange = 50;                    %���˻���ʼʱ��λ�÷�Χ
StepLength = 0.1;                    %ÿһ֡��0.1s

%�ƺ����е�uneven sigmoidal function�Ĳ���0<a<=b, c������֤phy(0) = 0  
a = 1;                        
b = 2;                        
c = abs(a - b)/sqrt(4*a*b);

ca1 = 0;
ca2 = 0;
cb1 = 0;
cb2 = 10;
%���������ٶȷ����еĲ�����������0
cr1 = 0.1;
cr2 = 0.15;

AObsAll = [];
dObsAll = [];
%% -----------------���˻�״̬��ʼ��-----------------
%q����ʼʱ��λ�� p����ʼʱ���ٶ� u����ʼʱ�̼��ٶ� 
%qr:��ʼʱ���쵼λ�� pr����ʼʱ���쵼�ٶ�
%qmat������ʱ��λ�� pmat������ʱ���ٶ� 
%prmat������ʱ���쵼λ�� qrmat������ʱ���쵼�ٶ� urmat������ʱ���쵼���ٶ�
[ q, p, u, qr, pr, qmat, pmat, qrmat, prmat, urmat ] = FlockInitialization( Dim, PosRange, Num, Frames );
%% -----------------��ͼ���ϰ����ʼ��-----------------
% [ CM ] = ObstacleInitialization( );
%% -----------------ѭ��-----------------
%-----------------��Ƶ����-----------------
% figure;
% H = 900;
% W = 1600;
mov = VideoWriter('Flock1806.avi');
mov.FrameRate = 30;  %֡�ʣ�Ĭ��30
obj.Quality = 100; %��Ƶ������[0, 100]
open(mov);
tic
    
for iRound = 1:Frames
    clf;
%     set(gcf, 'color', [1 1 1]); %��ɫ����
%     title('Process');
%     axis([1 120 1 120]);
    set (gca,'position',[0.03 0 0.95 1] );
    set (gcf,'position',[20 50 1500 700] );

%% -----------------��Ҫ����-----------------
    %�����ϰ����ͼ
    [ obsmat, CM, NumObs ] = ObstacleInitialization( ); %MΪ�ϰ����Բ������Ͱ뾶��CMΪ�ϰ����Ե�ĵ����꣬NumObsΪ�ϰ������
    %��¼Flock���������˻�λ�á��ٶ���Ϣ
    [ ur, qmat, pmat, qrmat, prmat, urmat ] = FlockRecord( iRound, q, p, qr, pr ); 
    
    %%%%ÿ�����˻���������Ƿ����ϰ������
    
    %����beta-agent
    [ q_beta, p_beta ] = CalcBetaAgent( q, p, obsmat, Dim, Num, NumObs );
    
    %����Adjacency Matrix
    [ A, d ] = CalcAdjMat( Num, R, q ); 
    %����beta Adjacency Matrix ��ʾ���˻����ϰ����ڽӾ���
    [ AObs, dObs ] = CalcBetaAdjMat( Num, NumObs, RObs, DObs_delta, Sigma, H, q, q_beta );
    
    AObsAll = [AObsAll; AObs];
    dObsAll = [dObsAll; dObs];
    
    %������ٶ�u_alpha�ķ���gradient-based term
    [ u_alpha_gradient ] = CalcGradientTerm( Dim, Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q );
    %������ٶ�u_alpha�ķ���consensus term
    [ u_alpha_consensus ] = CalcConsensusTerm( Dim, Num, A, p );
    
    %������ٶ�u_beta�ķ���gradient-based term
    [ u_beta_gradient ] = CalcBetaGradientTerm( Dim, Num, NumObs, Sigma, H, DObs_delta, RObs_delta, AObs, dObs, q, q_beta );
    %������ٶ�u_beta�ķ���consensus term
    [ u_beta_consensus ] = CalcBetaConsensusTerm( Dim, Num, NumObs, AObs, p, p_beta );
    
    %������ٶ�u_gamma��navigational feedback
    [ u_gamma ] = CalcNaviTerm( Num, NumFollow, cr1, cr2, q, p, qr, pr );
    %����ÿ�����˻����ܼ��ٶȣ��������������˻����ٶ���λ��
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
    frame1 = getframe(gcf); %���Ƶ�ǰͼ�Σ�gcfΪget current figure������legend��title��label����дgcfʱĬ��Ϊgca��axis��
%     frame1.cdata = imresize(frame1.cdata, [H W]); %��Ƶ�ֱ���
    writeVideo(mov, frame1);
%     pause(0.5);
end

toc
mov.close();

% figure;
% flock0.coherenceCal();