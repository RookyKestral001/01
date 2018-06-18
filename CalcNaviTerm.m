function [ u_gamma ] = CalcNaviTerm( Num, NumFollow, c1, c2, q, p, qr, pr )
%CALCNAVITERM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
u_gamma = zeros(2, Num);
matFollow = zeros(1, Num);
matFollow(1, 1:NumFollow) = 1; %���쵼Ӱ��100% = 1

for i = 1:Num
    u_gamma(1, i) = matFollow(1, i)*(-c1*(q(1, i) - qr(1, 1)) - c2*(p(1, i) - pr(1, 1)));
    u_gamma(2, i) = matFollow(1, i)*(-c1*(q(2, i) - qr(2, 1)) - c2*(p(2, i) - pr(2, 1)));
end
end

