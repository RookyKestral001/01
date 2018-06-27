function [ AObs, dObs ] = CalcBetaAdjMat( Num, NumObs, RObs, DObs_delta, Sigma, H, q, q_beta )
%CALCBETAADJMAT 此处显示有关此函数的摘要
%   此处显示详细说明
    AObs = zeros(Num, NumObs);
    dObs = zeros(Num, NumObs);
    dObsNorm = zeros(Num, NumObs);
    for i = 1:Num
        for k = 1:NumObs
            dObs(i, k) = sqrt((q(1, i) - q_beta(1, i, k))^2 + (q(2, i) - q_beta(2, i, k))^2);
%             if dObs(i, k) <= RObs
%                 AObs(i, k) = 1;
%             end
            dObsNorm(i, k) = CalcDeltaNorm( Sigma, dObs(i, k) ); 
            z1 = dObsNorm(i, k)/DObs_delta;
            AObs(i, k) = CalcBumpFunc( H, z1 );
        end
    end

end

