function [ u_alpha_gradient ] = CalcGradientTerm( Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q )
%CALCGRADIENTTERM ����u_alpha�е�Gradient-based Term�ٶȷ�����phy_alpha * nij
%   NΪ���о���nij��d_deltaΪ(qj-qi)��norm������phy_alpha(d_delta)
%   phy_alpha = ph * phy

%��ʼ��
u_alpha_gradient = zeros(2, Num);
u_alpha_gradient_parts = zeros(Num, Num, 2);
N = zeros(Num, Num, 2);
d_delta = zeros(Num, Num);
ph = zeros(Num, Num);
phy = zeros(Num, Num);
phy_alpha = zeros(Num, Num);

for i = 1:Num
    for j = 1:Num
        %�������nij
        N(i, j, 1) = (q(1, j) - q(1, i))/sqrt(1 + Sigma * d(i, j)^2);
        N(i, j, 2) = (q(2, j) - q(2, i))/sqrt(1 + Sigma * d(i, j)^2);
        
        %����(qj-qi)��norm
        d_delta(i, j) = CalcDeltaNorm( Sigma, d(i,j) ); 
        
        %����bump function����ph
        z1 = d_delta(i, j)/R_delta;
        ph(i, j) = CalcBumpFunc( H, z1 );
        
        %����phy
        z2 = d_delta(i, j) - D_delta;
        phy(i, j) = CalcPhy( a, b, c, z2 );
        
        %����phy_alpha
        phy_alpha(i, j) = ph(i, j) * phy(i, j) * A(i, j);
        
        %����u_alpha�е�gradient-based term
        u_alpha_gradient_parts(i, j, 1) = phy_alpha(i, j) * N(i, j, 1);
        u_alpha_gradient_parts(i, j, 2) = phy_alpha(i, j) * N(i, j, 2);
        
        u_alpha_gradient(1, i) = u_alpha_gradient(1, i) + u_alpha_gradient_parts(i, j, 1);
        u_alpha_gradient(2, i) = u_alpha_gradient(2, i) + u_alpha_gradient_parts(i, j, 2);
    end
end
end

