function [ ph_single ] = CalcBumpFunc( H, z )
%CALCBUMPFUNC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

if (z >= 0) & (z < H)
    ph_single = 1;
elseif (z >= H) & (z <= 1)
    ph_single = (1 + cos(pi * (z-H)/(1-H)))/2;
else
    ph_single = 0;
end

end

