%���쵼�߸Ľ��㷨
%---------ϵͳ����ֵ------------------------
clear;clc;
loop=500;                               %ȷ��ѭ������
s=0.1;                                  %sȡֵ��ΧΪ(0,1)
n=10;                                   %��ʼ�����������
r=6;                                    %��ʼ���������֪�뾶
dw=5;                                   %����Lattice����
a=1;b=2;                                %0<=a<=b
c1=0.1;c2=0.2;                          %�쵼��Ӱ�캯��������c1,c2>0
step=0.1;                               %ȷ������
h=0.9;                                  %�������h����ȡֵ��ΧΪ��0,1��
size=50;                                %��ʼ��Χ
%---------ϵͳ��ʼ��------------------------
q=size*rand(2,n);                       %��ʼ���������ʼλ������
p=2*rand(2,n)-1;                        %��ʼ���������ʼ�ٶ�����
qr1=size*rand(2,1);                     %��ʼ�쵼��1λ������
pr1=2*rand(2,1)-1;                      %��ʼ�쵼��1�ٶ�����
qr2=size*rand(2,1);                     %��ʼ�쵼��2λ������
pr2=2*rand(2,1)-1;                      %��ʼ�쵼��2�ٶ�����
qqr1=zeros(2,loop);                     %ÿ��ʱ����쵼�ߵ�λ������
ppr1=zeros(2,loop);                     %ÿ��ʱ����쵼�ߵ��ٶ�����
qqr2=zeros(2,loop);                     %ÿ��ʱ����쵼�ߵ�λ������
ppr2=zeros(2,loop);                     %ÿ��ʱ����쵼�ߵ��ٶ�����
qq=zeros(2,n,loop);                     %ÿ��ʱ��ε�λ������
pp=zeros(2,n,loop);                     %ÿ��ʱ��ε��ٶ�����
ra=(1/s)*[sqrt(1+s*(r^2))-1];
dwa=(1/s)*[sqrt(1+s*(dw^2))-1];
%----------��ʼѭ��--------------------------
%�����������ѭ����ʵ������
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
     %-------��ÿ���������Ӧ�쵼��--------------
     %----1~5�����쵼��1,6~10�����쵼��2---------
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
     
    %----------------ϵͳ�ṹ�-----------------------
    %���干ʶ����A���ж�������֮����໥Ӱ��
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
    %��agent֮�����d
    d=zeros(n,n);
    for i=1:n
        for j=1:n
            d(i,j)=sqrt((q(1,i)-q(1,j)-qr(1,i)+qr(1,j))^2+(q(2,i)-q(2,j)-qr(2,i)+qr(2,j))^2);
        end
    end
    %ʵ��fya��z��
    %����n��i,j��
    N=zeros(n,n,2);
    for i=1:n
        for j=1:n
            N(i,j,1)=(q(1,j)-q(1,i))/sqrt(1+s*d(i,j)^2);
            N(i,j,2)=(q(2,j)-q(2,i))/sqrt(1+s*d(i,j)^2);
        end
    end
    %����dai=||qj-qi+qri-qrj||��
    da=zeros(n,n);
    for i=1:n
        for j=1:n
            da(i,j)=(1/s)*[sqrt(1+s*(d(i,j)^2))-1];
        end
    end
    %����fya��da��
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
    %-----------------���������λ��Ӱ��------------------
    %��u11=fya*N��i,j��
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
    %----------------����������ٶ�Ӱ��----------------------
    %��u22=aij*(pj-pi-prj+pri)
    u22=[n,n,2];
    for i=1:n
        for j=1:n
            u22(i,j,1)=A(i,j)*(p(1,j)-p(1,i)-pr(1,i)+pr(1,i));
            u22(i,j,2)=A(i,j)*(p(2,j)-p(2,i)-pr(2,i)+pr(2,i));
        end
    end
    %u2Ϊ����2
    u2=zeros(2,n);
    for i=1:n
        for j=1:n
            u2(1,i)= u22(i,j,1)+ u2(1,i);
            u2(2,i)= u22(i,j,2)+ u2(2,i);
        end
    end
    %-----------------���쵼�ߵ�Ӱ��------------------
    u3=zeros(2,n);
    for i=1:5
        u3(1,i)=-c1*(q(1,i)-qr1(1,1))-c2*(p(1,i)-pr1(1,1));
        u3(2,i)=-c1*(q(2,i)-qr1(2,1))-c2*(p(2,i)-pr1(2,1));
    end
    for i=6:10
        u3(1,i)=-c1*(q(1,i)-qr2(1,1))-c2*(p(1,i)-pr2(1,1));
        u3(2,i)=-c1*(q(2,i)-qr2(2,1))-c2*(p(2,i)-pr2(2,1));
    end
    %-----------------����ٶ�u---------------------------
    %----���������ڼ���ʱ�������쵼������ļ��ٶȷ���ur------
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
    %----------------������һ������--------------
    %-------------��������ɢ����------------
    for i=1:2
        for j=1:n
            q(i,j)=q(i,j)+step*p(i,j);
            p(i,j)=p(i,j)+step*u(i,j);
        end
    end
    %------------�����쵼����ɢ����------------
    for i=1:2
        qr1(i,1)=qr1(i,1)+step*pr1(i,1);
        pr1(i,1)=pr1(i,1)+step*ur1(i,1);
    end
    for i=1:2
        qr2(i,1)=qr2(i,1)+step*pr2(i,1);
        pr2(i,1)=pr2(i,1)+step*ur2(i,1);
    end

end
%---------------------ѭ����������ͼ------------------------
%---------------------�������ʼʱ��״̬--------------------
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
%-------------------����������ʱ��״̬---------------
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
%--------------------������tʱ��--------------------------------
%------������ע�Ͷθ��Ƶ�����������t��ֵ����ʾ����Ϊtʱ��״̬------
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
%------------�������ٶȷ���������---------------------------
%-----------���쵼�߷���----------------
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
%-----------��һ��������---------------
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



