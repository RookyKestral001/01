function [ A, d ] = CalcAdjMat( n, r, q )
%CALCADJMAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    A = zeros(n, n);
    d = zeros(n, n);
    for i = 1:n
        for j = 1:n
            d(i, j) = sqrt((q(1, i) - q(1, j))^2 + (q(2, i) - q(2, j))^2);
            if d(i, j) <= r
                A(i, j) = 1;
            end
        end
    end


end

