function [ u_alpha_gradient ] = CalcGradientTerm( Num, Sigma, H, D_delta, R_delta, a, b, c, A, d, q )
%CALCGRADIENTTERM 计算u_alpha中的Gradient-based Term速度分量，phy_alpha * nij
%   N为其中矩阵nij，d_delta为(qj-qi)的norm，再求phy_alpha(d_delta)
%   phy_alpha = ph * phy

%初始化
u_alpha_gradient = zeros(2, Num);
u_alpha_gradient_parts = zeros(Num, Num, 2);
N = zeros(Num, Num, 2);
d_delta = zeros(Num, Num);
ph = zeros(Num, Num);
phy = zeros(Num, Num);
phy_alpha = zeros(Num, Num);

for i = 1:Num
    for j = 1:Num
        %计算矩阵nij
        N(i, j, 1) = (q(1, j) - q(1, i))/sqrt(1 + Sigma * d(i, j)^2);
        N(i, j, 2) = (q(2, j) - q(2, i))/sqrt(1 + Sigma * d(i, j)^2);
        
        %计算(qj-qi)的norm
        d_delta(i, j) = CalcDeltaNorm( Sigma, d(i,j) ); 
        
        %计算bump function，即ph
        z1 = d_delta(i, j)/R_delta;
        ph(i, j) = CalcBumpFunc( H, z1 );
        
        %计算phy
        z2 = d_delta(i, j) - D_delta;
        phy(i, j) = CalcPhy( a, b, c, z2 );
        
        %计算phy_alpha
        phy_alpha(i, j) = ph(i, j) * phy(i, j) * A(i, j);
        
        %计算u_alpha中的gradient-based term
        u_alpha_gradient_parts(i, j, 1) = phy_alpha(i, j) * N(i, j, 1);
        u_alpha_gradient_parts(i, j, 2) = phy_alpha(i, j) * N(i, j, 2);
        
        u_alpha_gradient(1, i) = u_alpha_gradient(1, i) + u_alpha_gradient_parts(i, j, 1);
        u_alpha_gradient(2, i) = u_alpha_gradient(2, i) + u_alpha_gradient_parts(i, j, 2);
    end
end
end

