function [ phy_single ] = CalcPhy( a, b, c, z2 )
%CALCPHY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
phy_single = ((a + b) * ((z2 + c)/sqrt(1 + (z2 + c)^2)) + (a - b))/2;

end

