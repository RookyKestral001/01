function DrawFlock( Num, frame, qmat, pmat, q_beta, p_beta, qr, pr )
%DRAWFLOCK 此处显示有关此函数的摘要
%   此处显示详细说明
% figure(1);
plot(qmat(1, :, frame), qmat(2, :, frame), 'o'), xlabel('x'), ylabel('y');
hold on;
quiver(qmat(1, :, frame), qmat(2, :, frame), pmat(1, :, frame), pmat(2, :, frame), 0.5);
hold on;
plot(q_beta(1, :, 1), q_beta(2, :, 1), 'x'); 
hold on;
quiver(q_beta(1, 1, 1), q_beta(2, 1, 1), p_beta(1, 1, 1), p_beta(2, 1, 1), 0.5);
hold on;
plot(qr(1, 1), qr(2, 1), 'x'); 
hold on;
quiver(qr(1, 1), qr(2, 1), pr(1, 1), pr(2, 1), 0.5);
% for i = 1:Num
%     for j = 1:Num
%         line([qmat(1, i, frame), qmat(1, j, frame)], [qmat(2, i, frame), qmat(2, j, frame)]);
%     end
% end
end

