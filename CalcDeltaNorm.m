function [ norm ] = CalcDeltaNorm(sigma, z)
%CALCNORM �����-Norm
%   �˴���ʾ��ϸ˵��
norm = (sqrt(1+sigma*z^2)-1)/sigma;

end

