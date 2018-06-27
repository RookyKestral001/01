function [ u_beta_consensus ] = CalcBetaConsensusTerm( Dim, Num, NumObs, AObs, p, p_beta )
%CALCBETACONSENSUSTERM 此处显示有关此函数的摘要
%   此处显示详细说明
u_beta_consensus = zeros(Dim, Num);
u_beta_consensus_parts = zeros(Num, NumObs, Dim);
for i = 1:Num
    for k = 1:NumObs
        u_beta_consensus_parts(i, k, 1) = AObs(i, k) * (p_beta(1, i, k) - p(1, i));
        u_beta_consensus_parts(i, k, 2) = AObs(i, k) * (p_beta(2, i, k) - p(2, i));
        
        u_beta_consensus(1, i) = u_beta_consensus(1, i) + u_beta_consensus_parts(i, k, 1);
        u_beta_consensus(2, i) = u_beta_consensus(2, i) + u_beta_consensus_parts(i, k, 2);
    end
end

end

