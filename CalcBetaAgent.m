function [ q_beta, p_beta ] = CalcBetaAgent( q, p, obsmat, Dim, Num, NumObs )
%CALCBETAAGENT 此处显示有关此函数的摘要
%   此处显示详细说明

% u = zeros(Num, NumObs);
% a = zeros(Num, NumObs);
% P = zeros(Num, NumObs);

dd = zeros(Num, NumObs);

q_beta_single = zeros(Dim, 1);
p_beta_single = zeros(Dim, 1);

q_beta = zeros(Dim, Num, NumObs);
p_beta = zeros(Dim, Num, NumObs);

for i = 1:Num
    for k = 1:NumObs
        dd(i, k) = sqrt((q(1, i) - obsmat(1, k))^2 + (q(2, i) - obsmat(2, k))^2);
        u = obsmat(3, k)/dd(i, k);
        ak = (q(:, i) - obsmat(1:2, k))/dd(i, k);
        I = eye(2,2);
        P = I - ak*ak';
        
        q_beta_single(:,1) = u * q(:, i) + (1 - u) * obsmat(1:2, k);
        p_beta_single(:,1) = u * P * p(:, i);
        
        q_beta(:, i, k) = q_beta_single(:,1);
        p_beta(:, i, k) = p_beta_single(:,1);
    end
end

end

