%多领导者改进算法
%---------系统附初值------------------------
clear;clc;
loop=500;                               %确定循环周期
s=0.1;                                  %s取值范围为(0,1)
n=10;                                   %初始化智能体个数
r=6;                                    %初始化智能体感知半径
dw=5;                                   %网格Lattice距离
a=1;b=2;                                %0<=a<=b
c1=0.1;c2=0.2;                          %领导者影响函数参数，c1,c2>0
step=0.1;                               %确定步长
h=0.9;                                  %定义参数h，其取值范围为（0,1）
size=50;                                %初始范围
%---------系统初始化------------------------
q=size*rand(2,n);                       %初始化智能体初始位置向量
p=2*rand(2,n)-1;                        %初始化智能体初始速度向量
qr1=size*rand(2,1);                     %初始领导者1位置向量
pr1=2*rand(2,1)-1;                      %初始领导者1速度向量
qr2=size*rand(2,1);                     %初始领导者2位置向量
pr2=2*rand(2,1)-1;                      %初始领导者2速度向量
qqr1=zeros(2,loop);                     %每个时间段领导者的位置向量
ppr1=zeros(2,loop);                     %每个时间段领导者的速度向量
qqr2=zeros(2,loop);                     %每个时间段领导者的位置向量
ppr2=zeros(2,loop);                     %每个时间段领导者的速度向量
qq=zeros(2,n,loop);                     %每个时间段的位置向量
pp=zeros(2,n,loop);                     %每个时间段的速度向量
ra=(1/s)*[sqrt(1+s*(r^2))-1];
dwa=(1/s)*[sqrt(1+s*(dw^2))-1];
%----------开始循环--------------------------
%对智能体进行循环，实验主题
 for ld=1:loop
     qq(:,:,ld)=q(:,:);
     pp(:,:,ld)=p(:,:); 
     qqr1(:,ld)=qr1(:,:);
     ppr1(:,ld)=pr1(:,:); 
     qqr2(:,ld)=qr2(:,:);
     ppr2(:,ld)=pr2(:,:); 
     ur1(:,1)=cos(qr1(:,1));
     ur2(:,1)=cos(qr2(:,1));
     qr=zeros(2,10);
     pr=zeros(2,10);
     %-------给每个智能体对应领导者--------------
     %----1~5跟随领导者1,6~10跟随领导者2---------
     for j=1:10
         if j>=1&j<=5
             qr(:,j)=qr1(:,1);
         else 
             qr(:,j)=qr2(:,1);
         end
     end
     for j=1:10
         if j>=1&j<=5
             pr(:,j)=pr1(:,1);
         else 
             apr(:,j)=pr2(:,1);
         end
     end
     
    %----------------系统结构搭建-----------------------
    %定义共识网络A，判断智能体之间的相互影响
    A=zeros(n,n);
    for i=1:n
        for j=1:n
            if [q(1,i)-q(1,j)]^2+[q(2,i)-q(2,j)]^2<=r^2
                A(i,j)=1;
            end
        end    
    end
    for i=1:n
        A(i,i)=0;
    end
    %求agent之间距离d
    d=zeros(n,n);
    for i=1:n
        for j=1:n
            d(i,j)=sqrt((q(1,i)-q(1,j)-qr(1,i)+qr(1,j))^2+(q(2,i)-q(2,j)-qr(2,i)+qr(2,j))^2);
        end
    end
    %实现fya（z）
    %计算n（i,j）
    N=zeros(n,n,2);
    for i=1:n
        for j=1:n
            N(i,j,1)=(q(1,j)-q(1,i))/sqrt(1+s*d(i,j)^2);
            N(i,j,2)=(q(2,j)-q(2,i))/sqrt(1+s*d(i,j)^2);
        end
    end
    %计算dai=||qj-qi+qri-qrj||σ
    da=zeros(n,n);
    for i=1:n
        for j=1:n
            da(i,j)=(1/s)*[sqrt(1+s*(d(i,j)^2))-1];
        end
    end
    %计算fya（da）
    fya=zeros(n,n);
    ph=zeros(n,n);
    for i=1:n
        for j=1:n
            z1=da(i,j)/ra;
            if z1<h & z1>=0      
                 ph(i,j)=1;
            elseif z1<=1|z1>=h
                 ph(i,j)=0.5*(1+cos(pi*((z1-h)/(1-h))));
            else
                 ph(i,j)=0;
            end
            z2=da(i,j)-dwa;
            c=(b-a)/sqrt(4*a*b);
            fy(i,j)=0.5*((a+b)*((z2+c)/sqrt(1+(z2+c)^2))+(a-b));
            fya(i,j)=ph(i,j)*fy(i,j)*A(i,j);
        end
    end
    %-----------------求智能体的位置影响------------------
    %求u11=fya*N（i,j）
    u11=zeros(n,n,2);
    for i=1:n
        for j=1:n
            u11(i,j,1)=fya(i,j)*N(i,j,1);
            u11(i,j,2)=fya(i,j)*N(i,j,2);
        end
    end
    u1=zeros(2,n);
    for i=1:n
        for j=1:n
            u1(1,i)=u1(1,i)+u11(i,j,1);
            u1(2,i)=u1(2,i)+u11(i,j,2);
        end
    end
    %----------------求智能体的速度影响----------------------
    %求u22=aij*(pj-pi-prj+pri)
    u22=[n,n,2];
    for i=1:n
        for j=1:n
            u22(i,j,1)=A(i,j)*(p(1,j)-p(1,i)-pr(1,i)+pr(1,i));
            u22(i,j,2)=A(i,j)*(p(2,j)-p(2,i)-pr(2,i)+pr(2,i));
        end
    end
    %u2为反馈2
    u2=zeros(2,n);
    for i=1:n
        for j=1:n
            u2(1,i)= u22(i,j,1)+ u2(1,i);
            u2(2,i)= u22(i,j,2)+ u2(2,i);
        end
    end
    %-----------------求领导者的影响------------------
    u3=zeros(2,n);
    for i=1:5
        u3(1,i)=-c1*(q(1,i)-qr1(1,1))-c2*(p(1,i)-pr1(1,1));
        u3(2,i)=-c1*(q(2,i)-qr1(2,1))-c2*(p(2,i)-pr1(2,1));
    end
    for i=6:10
        u3(1,i)=-c1*(q(1,i)-qr2(1,1))-c2*(p(1,i)-pr2(1,1));
        u3(2,i)=-c1*(q(2,i)-qr2(2,1))-c2*(p(2,i)-pr2(2,1));
    end
    %-----------------求加速度u---------------------------
    %----各智能体在计算时加入其领导智能体的加速度反馈ur------
    u=zeros(2,n);
    for i=1:2
        for j=1:5
          u(i,j)=u1(i,j)+u2(i,j)+u3(i,j)+ur1(i,1);
        end
    end
    for i=1:2
        for j=6:10
          u(i,j)=u1(i,j)+u2(i,j)+u3(i,j)+ur2(i,1);
        end
    end
    %----------------进行下一步运算--------------
    %-------------智能体离散计算------------
    for i=1:2
        for j=1:n
            q(i,j)=q(i,j)+step*p(i,j);
            p(i,j)=p(i,j)+step*u(i,j);
        end
    end
    %------------虚拟领导者离散计算------------
    for i=1:2
        qr1(i,1)=qr1(i,1)+step*pr1(i,1);
        pr1(i,1)=pr1(i,1)+step*ur1(i,1);
    end
    for i=1:2
        qr2(i,1)=qr2(i,1)+step*pr2(i,1);
        pr2(i,1)=pr2(i,1)+step*ur2(i,1);
    end

end
%---------------------循环结束，绘图------------------------
%---------------------智能体初始时刻状态--------------------
figure(1);
plot(qq(1,:,1),qq(2,:,1),'o');
hold on;
quiver(qq(1,:,1),qq(2,:,1),pp(1,:,1),pp(2,:,1),'Color','red');
for i=1:n
    for j=1:n
        if sqrt((qq(1,i,1)-qq(1,j,1))^2+(qq(2,i,1)-qq(2,j,1))^2)<=r
            line([qq(1,i,1),qq(1,j,1)],[qq(2,i,1),qq(2,j,1)]); 
        end
    end
end
%-------------------智能体最终时刻状态---------------
figure(2);
plot(qq(1,:,loop),qq(2,:,loop),'o');
hold on;
quiver(qq(1,:,loop),qq(2,:,loop),pp(1,:,loop),pp(2,:,loop),'Color','red');
for i=1:n
    for j=1:n
        if sqrt((qq(1,i,loop)-qq(1,j,loop))^2+(qq(2,i,loop)-qq(2,j,loop))^2)<=r
            line([qq(1,i,loop),qq(1,j,loop)],[qq(2,i,loop),qq(2,j,loop)]); 
        end
    end
end
%--------------------智能体t时刻--------------------------------
%------将下面注释段复制到工作窗，给t赋值，显示步数为t时的状态------
% figure(1);
% plot(qq(1,:,t),qq(2,:,t),'o');
% hold on;
% quiver(qq(1,:,t),qq(2,:,t),pp(1,:,t),pp(2,:,t),'Color','red');
% for i=1:n
%     for j=1:n
%         if sqrt((qq(1,i,t)-qq(1,j,t))^2+(qq(2,i,t)-qq(2,j,t))^2)<=r
%             line([qq(1,i,t),qq(1,j,t)],[qq(2,i,t),qq(2,j,t)]); 
%         end
%     end
% end
%------------智能体速度方向跟随情况---------------------------
%-----------画领导者方向----------------
figure(3);
mdqr=zeros(1,loop);
for i=1:loop
mdqr(1,i)=sqrt((ppr1(1,i))^2+(ppr1(2,i))^2);
csqr(1,i)=ppr1(1,i)/mdqr(1,i);
end
plot(1:loop,csqr(1,1:loop),'color','red')
hold on
mdqr=zeros(1,loop);
for i=1:loop
mdqr(1,i)=sqrt((ppr2(1,i))^2+(ppr2(2,i))^2);
csqr(1,i)=ppr2(1,i)/mdqr(1,i);
end
plot(1:loop,csqr(1,1:loop),'color','yellow')
hold on
%-----------画一般智能体---------------
for i=1:n
    for j=1:loop
        mdq(i,j)=sqrt((pp(1,i,j))^2+(pp(2,i,j))^2);
        csq(i,j)=pp(1,i,j)/mdq(i,j);
    end
end
for i=1:10
plot(1:loop,csq(i,1:loop))
hold on
end



