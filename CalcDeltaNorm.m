function [ norm ] = CalcDeltaNorm(sigma, z)
%CALCNORM 计算δ-Norm
%   此处显示详细说明
norm = (sqrt(1+sigma*z^2)-1)/sigma;

end

