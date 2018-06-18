function [ phy_single ] = CalcPhy( a, b, c, z2 )
%CALCPHY 此处显示有关此函数的摘要
%   此处显示详细说明
phy_single = ((a + b) * ((z2 + c)/sqrt(1 + (z2 + c)^2)) + (a - b))/2;

end

