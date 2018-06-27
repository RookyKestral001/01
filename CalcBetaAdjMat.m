function [ AObs, dObs ] = CalcBetaAdjMat( Num, NumObs, RObs, DObs_delta, Sigma, H, q, q_beta )
%CALCBETAADJMAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

