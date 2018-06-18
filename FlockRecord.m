function [ur, qmat, pmat, qrmat, prmat, urmat] = FlockRecord(f, q, p, qr, pr)
%FLOCKRECORD 此处显示有关此函数的摘要
%   此处显示详细说明
    qmat(:, :, f) = q(:, :);
    pmat(:, :, f) = p(:, :);
    qrmat(:, f) = qr(:, :);
    prmat(:, f) = pr(:, :);
    
    ur = cos(qr(:, 1));
    urmat(:, f) = ur(:, :);
    
end

