function [ u_alpha_consensus ] = CalcConsensusTerm( Num, A, p )
%CALCCONSENSUSTERM 此处显示有关此函数的摘要
%   此处显示详细说明
u_alpha_consensus = zeros(2, Num);
u_alpha_consensus_parts = zeros(Num, Num, 2);
for i = 1:Num
    for j = 1:Num
        u_alpha_consensus_parts(i, j, 1) = A(i, j) * (p(1, j) - p(1, i));
        u_alpha_consensus_parts(i, j, 1) = A(i, j) * (p(1, j) - p(1, i));
        
        u_alpha_consensus(1, i) = u_alpha_consensus(1, i) + u_alpha_consensus_parts(i, j, 1);
        u_alpha_consensus(2, i) = u_alpha_consensus(2, i) + u_alpha_consensus_parts(i, j, 2);
    end
end

end

