close all;
clear all;
clc;
%% -----------------������ֵ-----------------
Frames = 500;                 %֡��
Dim = 2;                      %ά��

Num = 40;                     %���˻��ĸ���
NumFollow = 50;                       %�쵼Ӱ�����˻�����

Sigma = 0.1;                  %����norm�Ĳ���
R = 6;                        %���˻���֪�뾶
R_delta = CalcDeltaNorm( Sigma, R);
D = 5;                        %����alpha-lattice�ĳߴ�scale
D_delta = CalcDeltaNorm( Sigma, D ); %����ߴ��delta-norm
K = R/D;                      %ratio
H = 0.1;                      %bump function�Ĳ���

PosRange = 50;                    %���˻���ʼʱ��λ�÷�Χ
StepLength = 0.1;                    %ÿһ֡��0.1s

%�ƺ����е�uneven sigmoidal function�Ĳ���0<a<=b, c������֤phy(0) = 0  
a = 1;                        
b = 2;                        
c = abs(a - b)/sqrt(4*a*b);

%���������ٶȷ����еĲ�����������0
c1 = 0.1;
c2 = 0.2;
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

%% -----------------��Ҫ����-----------------
    %�����ϰ����ͼ
    [ CM ] = ObstacleInitialization( );
    %��¼Flock���������˻�λ�á��ٶ���Ϣ
    [ ur, qmat, pmat, qrmat, prmat, urmat ] = FlockRecord( iRound, q, p, qr, pr ); 
    %����Adjacency Matrix
    [ A, d ] = CalcAdjMat( Num, R, q ); 
    %������ٶ�u_alpha�ķ���gradient-based term
    [ u_alpha_gradient ] = CalcGradientTerm( Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q );
    %������ٶ�u_alpha�ķ���consensus term
    [ u_alpha_consensus ] = CalcConsensusTerm( Num, A, p );
    %������ٶ�u_gamma��navigational feedback
    [ u_gamma ] = CalcNaviTerm( Num, NumFollow, c1, c2, q, p, qr, pr );
    %����ÿ�����˻����ܼ��ٶȣ��������������˻����ٶ���λ��
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
    frame1 = getframe(gcf); %���Ƶ�ǰͼ�Σ�gcfΪget current figure������legend��title��label����дgcfʱĬ��Ϊgca��axis��
%     frame1.cdata = imresize(frame1.cdata, [H W]); %��Ƶ�ֱ���
    writeVideo(mov, frame1);
%     pause(0.5);
end

toc
mov.close();

% figure;
% flock0.coherenceCal();