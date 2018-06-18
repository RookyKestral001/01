function [ ph_single ] = CalcBumpFunc( H, z )
%CALCBUMPFUNC 此处显示有关此函数的摘要
%   此处显示详细说明

if (z >= 0) & (z < H)
    ph_single = 1;
elseif (z >= H) & (z <= 1)
    ph_single = (1 + cos(pi * (z-H)/(1-H)))/2;
else
    ph_single = 0;
end

end

