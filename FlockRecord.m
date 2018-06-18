function [ur, qmat, pmat, qrmat, prmat, urmat] = FlockRecord(f, q, p, qr, pr)
%FLOCKRECORD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    qmat(:, :, f) = q(:, :);
    pmat(:, :, f) = p(:, :);
    qrmat(:, f) = qr(:, :);
    prmat(:, f) = pr(:, :);
    
    ur = cos(qr(:, 1));
    urmat(:, f) = ur(:, :);
    
end

