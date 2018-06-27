function [ u_beta_gradient ] = CalcBetaGradientTerm( Dim, Num, NumObs, Sigma, H, DObs_delta, RObs_delta, AObs, dObs, q, q_beta )
%CALCBETAGRADIENTTERM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

u_beta_gradient = zeros(Dim, Num);
u_beta_gradient_parts = zeros(Num, NumObs, Dim);
N = zeros(Num, NumObs, Dim);
d_delta = zeros(Num, NumObs);
ph = zeros(Num, NumObs);
phy = zeros(Num, NumObs);
phy_beta = zeros(Num, NumObs);

for i = 1:Num
    for k = 1:NumObs
        %�������nij
        N(i, k, 1) = (q_beta(1, i, k) - q(1, i))/sqrt(1 + Sigma * dObs(i, k)^2);
        N(i, k, 2) = (q_beta(2, i, k) - q(2, i))/sqrt(1 + Sigma * dObs(i, k)^2);
        
        %����(qj-qi)��norm
        d_delta(i, k) = CalcDeltaNorm( Sigma, dObs(i,k) ); 
        
        %����bump function����ph
        z1 = d_delta(i, k)/DObs_delta;
        ph(i, k) = CalcBumpFunc( H, z1 );
        
        %����phy
        z2 = d_delta(i, k) - DObs_delta;
        phy(i, k) = z2/sqrt(1 + z2^2) - 1 ;
        
        %����phy_alpha
        phy_beta(i, k) = ph(i, k) * phy(i, k) * AObs(i, k);
        
        %����u_alpha�е�gradient-based term
        u_beta_gradient_parts(i, k, 1) = phy_beta(i, k) * N(i, k, 1);
        u_beta_gradient_parts(i, k, 2) = phy_beta(i, k) * N(i, k, 2);
        
        u_beta_gradient(1, i) = u_beta_gradient(1, i) + u_beta_gradient_parts(i, k, 1);
        u_beta_gradient(2, i) = u_beta_gradient(2, i) + u_beta_gradient_parts(i, k, 2);
    end
end

end

