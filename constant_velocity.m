%%不用solve函数求解方程，按矩阵运算求解，矩阵生产方式按先全零再补充
clc;clear;
close all
a1=(3400-967)/1000;
b1=(3600+967)/1000;
c1=(4500+967)/1000;
% d1=0;
a2=(3600+10)/1000;
b2=(3600-10)/1000;
c2=(4500-10)/1000;
d2=(4500+10)/1000;
a3=(3600+967)/1000;
b3=(3400-967)/1000;
%c3=0;
d3=(4500+967)/1000;
G1=(7041+6958);
G6=7158+6296;
G2=4829;%
G3=5635;%
G4=5773;
G5=4395;
m1=G1+G2;%
m2=G3+G4;
m3=G5+G6;%
file_name = 'Mc2_25_R30_ready';
data = readtable([file_name, '.csv']); 
data.veh_head(1)
%%
%转角，车间夹角，单位：rad(表中单位是1/1000°）
[row,col]=size(data);
n=fix(row/5);
% n=fix(9900/5);
delta1=zeros(n,1);
delta3=zeros(n,1);
delta4=zeros(n,1);
delta5=zeros(n,1);
delta6=zeros(n,1);
delta8=zeros(n,1);
theta=zeros(n,2);
ay=zeros(n,3);
PositionAxle2=zeros(n,2);
PositionAxle4=zeros(n,2);
PositionAxle6=zeros(n,2);
PositionAxle1=zeros(n,2);
PositionAxle3=zeros(n,2);
PositionAxle5=zeros(n,2);
PositionJoint12_Mc1=zeros(n,2);
PositionJoint12_T=zeros(n,2);
PositionJoint23_Mc2=zeros(n,2);
PositionJoint23_T=zeros(n,2);
Azimuth1=zeros(n,1);
Azimuth2=zeros(n,1);
Azimuth3=zeros(n,1);
Length=zeros(n,2);
Angle=zeros(n,2);

% F=1;
% H=1;
% Q=0.01;
% R=0.1;
% Azimuth3_Ini=KaermanFilter(data.rtk1_timestamp(1),data.rtk1_timestamp, ...
%     F,Q,H,R,data.rtk1_timestamp(1)^2);
% Azimuth2_Ini=KaermanFilter(data.rtk2_timestamp(1),data.rtk2_timestamp, ...
%     F,Q,H,R,data.rtk2_timestamp(1)^2);
% Azimuth1_Ini=KaermanFilter(data.rtk3_timestamp(1),data.rtk3_timestamp, ...
%     F,Q,H,R,data.rtk3_timestamp(1)^2);

% lpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
%          'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
%          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% Azimuth3_Ini=filtfilt(lpFilt,data.rtk1_timestamp);
% Azimuth2_Ini=filtfilt(lpFilt,data.rtk2_timestamp);
% Azimuth1_Ini=filtfilt(lpFilt,data.rtk3_timestamp);


% figure(1)
% plot(data.rtk3_timestamp)
% hold on
% plot(Azimuth1_Ini)
% plot(data.rtk2_timestamp)
% plot(Azimuth2_Ini)
% plot(data.rtk1_timestamp)
% plot(Azimuth3_Ini)

legend('Mc2原始数据','Mc2滤波后','T原始数据','T滤波后','Mc1原始数据','Mc1滤波后')
for i=1:1:n
    delta1(i)=(data.odr1_real(5*i-4)-data.odr1_diff(5*i-4))/1000/180*pi;
    delta3(i)=(data.odr2_real(5*i-4)-data.odr2_diff(5*i-4))/1000/180*pi;
    delta4(i)=(data.odr3_real(5*i-4)-data.odr3_diff(5*i-4))/1000/180*pi;
    delta5(i)=(data.odr4_real(5*i-4)-data.odr4_diff(5*i-4))/1000/180*pi;
    delta6(i)=(data.odr5_real(5*i-4)-data.odr5_diff(5*i-4))/1000/180*pi;
    delta8(i)=(data.odr6_real(5*i-4)-data.odr6_diff(5*i-4))/1000/180*pi;
    theta(i,:)=[data.angle12(5*i-4) data.angle23(5*i-4)];
    PositionAxle5(i,:)=[data.rtk1_lon(5*i-4)-data.rtk1_lon(1) data.rtk1_lat(5*i-4)-data.rtk1_lat(1)];
    PositionAxle3(i,:)=[data.rtk2_lon(5*i-4)-data.rtk1_lon(1) data.rtk2_lat(5*i-4)-data.rtk1_lat(1)];
    PositionAxle1(i,:)=[data.rtk3_lon(5*i-4)-data.rtk1_lon(1) data.rtk3_lat(5*i-4)-data.rtk1_lat(1)];
    Azimuth3(i)=data.rtk1_timestamp(5*i-4)/180*pi+pi;
    Azimuth2(i)=data.rtk2_timestamp(5*i-4)/180*pi+pi;
    Azimuth1(i)=data.rtk3_timestamp(5*i-4)/180*pi+pi;
    Angle(i,:)=[(Azimuth2(i)-Azimuth1(i)) (Azimuth3(i)-Azimuth2(i))];
    Length(i,:)=[sqrt((PositionAxle1(i,1)-PositionAxle3(i,1)).^2 ...
    +(PositionAxle1(i,2)-PositionAxle3(i,2)).^2) sqrt((PositionAxle5(i,1)-PositionAxle3(i,1)).^2 ...
    +(PositionAxle5(i,2)-PositionAxle3(i,2)).^2)];
    % Azimuth3(i)=Azimuth3_Ini(5*i-4)/180*pi;
    % Azimuth2(i)=Azimuth2_Ini(5*i-4)/180*pi;
    % Azimuth1(i)=Azimuth1_Ini(5*i-4)/180*pi;
    PositionAxle2(i,:)=[PositionAxle1(i,1)+(a1+b1)*cos(Azimuth1(i)) PositionAxle1(i,2)+(a1+b1)*sin(Azimuth1(i))];
    PositionJoint12_Mc1(i,:)=[PositionAxle1(i,1)+(a1+c1)*cos(Azimuth1(i)) PositionAxle1(i,2)+(a1+c1)*sin(Azimuth1(i))];
    PositionAxle4(i,:)=[PositionAxle3(i,1)+(a2+b2)*cos(Azimuth2(i)) PositionAxle3(i,2)+(a2+b2)*sin(Azimuth2(i))];
    PositionJoint12_T(i,:)=[PositionAxle3(i,1)-(d2-a2)*cos(Azimuth2(i)) PositionAxle3(i,2)-(d2-a2)*sin(Azimuth2(i))];
    PositionJoint23_T(i,:)=[PositionAxle3(i,1)+(c2+a2)*cos(Azimuth2(i)) PositionAxle3(i,2)+(c2+a2)*sin(Azimuth2(i))];
    PositionAxle6(i,:)=[PositionAxle5(i,1)+(a3+b3)*cos(Azimuth3(i)) PositionAxle5(i,2)+(a3+b3)*sin(Azimuth3(i))];
    PositionJoint23_Mc2(i,:)=[PositionAxle5(i,1)-(d3-a3)*cos(Azimuth3(i)) PositionAxle5(i,2)-(d3-a3)*sin(Azimuth3(i))];
    
    ay(i,:)=[data.imu_acc1_y(5*i-4) data.imu_acc2_y(5*i-4) data.imu_acc3_y(5*i-4)];

end
figure(15)
plot(delta1)
hold on
plot(delta8)
plot(delta3)
plot(delta4)
plot(delta5)
plot(delta6)

figure(14)
plot(ay(:,1))
hold on
plot(ay(:,2))
plot(ay(:,3))

figure(10)
plot(Angle(:,1)/pi*180)
hold on
plot(Angle(:,2)/pi*180)
figure(11)
plot(Length(:,1))
hold on
plot(Length(:,2))
% PositionAxle1=[PositionAxle2(:,1)+(a1+b1)*cos(Azimuth1) PositionAxle2(:,2)+(a1+b1)*sin(Azimuth1)];
% PositionJoint12_Mc1=[PositionAxle2(:,1)-c1*cos(Azimuth1) PositionAxle2(:,2)-c1*sin(Azimuth1)];
% PositionAxle3=[PositionAxle4(:,1)+(a2+b2)*cos(Azimuth2) PositionAxle4(:,2)+(a2+b2)*sin(Azimuth2)];
% PositionJoint12_T=[PositionAxle4(:,1)+(d2+b2)*cos(Azimuth2) PositionAxle4(:,2)+(d2+b2)*sin(Azimuth2)];
% PositionJoint23_T=[PositionAxle4(:,1)-(c2-b2)*cos(Azimuth2) PositionAxle4(:,2)-(c2-b2)*sin(Azimuth2)];
% PositionAxle5=[PositionAxle6(:,1)+(a3+b3)*cos(Azimuth3) PositionAxle6(:,2)+(a3+b3)*sin(Azimuth3)];
% PositionJoint23_Mc2=[PositionAxle6(:,1)+(d3+b3)*cos(Azimuth3) PositionAxle6(:,2)+(d3+b3)*sin(Azimuth3)];

% figure(1)
% hold on
% lpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
%          'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
%          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% ay(:,1)=filtfilt(lpFilt,ay(:,1));
% ay(:,2)=filtfilt(lpFilt,ay(:,2));
% ay(:,3)=filtfilt(lpFilt,ay(:,3));
% aycen=[ay(:,1) ay(:,2) ay(:,3)];

% %调整头尾
% aycen=[ay(:,3) ay(:,2) ay(:,1)];
% aycen=-aycen;
% temp1=PositionAxle1;
% temp2=PositionAxle2;
% temp3=PositionAxle3;
% temp4=PositionAxle4;
% temp5=PositionAxle5;
% temp6=PositionAxle6;
% temp7=PositionJoint12_Mc1;
% temp8=PositionJoint12_T;
% temp9=PositionJoint23_T;
% temp10=PositionJoint23_Mc2;
% PositionAxle1=temp6;
% PositionAxle2=temp5;
% PositionAxle3=temp4;
% PositionAxle4=temp3;
% PositionAxle5=temp2;
% PositionAxle6=temp1;
% PositionJoint12_Mc1=temp10;
% PositionJoint12_T=temp9;
% PositionJoint23_T=temp8;
% PositionJoint23_Mc2=temp7;


% figure(8)
% hold on
% plot(aycen(:,1))
% plot(aycen(:,2))
% plot(aycen(:,3))

figure(3)
plot(PositionAxle1(:,1),PositionAxle1(:,2))
hold on
plot(PositionAxle2(:,1),PositionAxle2(:,2))
plot(PositionAxle3(:,1),PositionAxle3(:,2))
plot(PositionAxle4(:,1),PositionAxle4(:,2))
plot(PositionAxle5(:,1),PositionAxle5(:,2))
plot(PositionAxle6(:,1),PositionAxle6(:,2))

% lpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
%          'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
%          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% PositionAxle2=filtfilt(lpFilt,PositionAxle2);
% PositionAxle4=filtfilt(lpFilt,PositionAxle4);
% PositionAxle6=filtfilt(lpFilt,PositionAxle6);

% plot(PositionAxle2(:,1),PositionAxle2(:,2))
% plot(PositionAxle4(:,1),PositionAxle4(:,2))
% plot(PositionAxle6(:,1),PositionAxle6(:,2))

% figure(5)
% hold on
% plot(PositionJoint12_Mc1(:,1),PositionJoint12_Mc1(:,2),'--')
% plot(PositionJoint12_T(:,1),PositionJoint12_T(:,2),'-.')

axis equal

errorJoint=sqrt((PositionJoint12_Mc1(:,1)-PositionJoint12_T(:,1)).^2 ...
    +(PositionJoint12_Mc1(:,2)-PositionJoint12_T(:,2)).^2);

figure(4)
plot(errorJoint)
xlabel('时间')
ylabel('铰接点误差(m)')

DistanceAxle1_Joint12_T=sqrt((PositionAxle1(:,1)-PositionJoint12_T(:,1)).^2 ...
    +(PositionAxle1(:,2)-PositionJoint12_T(:,2)).^2);

figure(6)
plot(DistanceAxle1_Joint12_T)
xlabel('时间')
ylabel('距离(m)')

DistanceAxle1_Axle3=sqrt((PositionAxle1(:,1)-PositionAxle3(:,1)).^2 ...
    +(PositionAxle1(:,2)-PositionAxle3(:,2)).^2);

figure(7)
plot(DistanceAxle1_Axle3)
xlabel('时间')
ylabel('距离(m)')

figure(3)
hold on
for i=1:floor(n/4):n
    % plot(PositionJoint12_Mc1(i,1),PositionJoint12_Mc1(i,2),'*')
    % plot(PositionJoint12_T(i,1),PositionJoint12_T(i,2),'*')
    % plot(PositionAxle1(i,1),PositionAxle1(i,2),'o')
    % plot(PositionAxle3(i,1),PositionAxle3(i,2),'o')
    % plot(PositionAxle5(i,1),PositionAxle5(i,2),'o')
    % plot(PositionJoint23_Mc2(i,1),PositionJoint23_Mc2(i,2),'*')
    % plot(PositionJoint23_T(i,1),PositionJoint23_T(i,2),'o')
    plot([PositionAxle1(i,1),PositionAxle2(i,1)],[PositionAxle1(i,2),PositionAxle2(i,2)],'b','LineWidth',1)
    plot([PositionAxle3(i,1),PositionAxle4(i,1)],[PositionAxle3(i,2),PositionAxle4(i,2)],'b','LineWidth',1)
    plot([PositionAxle5(i,1),PositionAxle6(i,1)],[PositionAxle5(i,2),PositionAxle6(i,2)],'b','LineWidth',1)
    
    plot([PositionAxle2(i,1),PositionJoint12_T(i,1),PositionAxle3(i,1)],[PositionAxle2(i,2) ...
        ,PositionJoint12_T(i,2),PositionAxle3(i,2)])
    plot([PositionAxle4(i,1),PositionJoint23_Mc2(i,1),PositionAxle5(i,1)],[PositionAxle4(i,2) ...
        ,PositionJoint23_Mc2(i,2),PositionAxle5(i,2)])
    axis equal
    % plot([PositionAxle2(i,1),PositionJoint12_Mc1(i,1),PositionAxle3(i,1)],[PositionAxle2(i,2) ...
    %     ,PositionJoint12_Mc1(i,2),PositionAxle3(i,2)])
    % plot([PositionAxle4(i,1),PositionJoint23_T(i,1),PositionAxle5(i,1)],[PositionAxle4(i,2) ...
    %     ,PositionJoint23_T(i,2),PositionAxle5(i,2)])

end

%%
function  Xkf= KaermanFilter(InitX,Z,F,Q,H,R,P0)
%KAERMANFILTER 此处显示有关此函数的摘要
%参数说明： InitX:X的初始值,不知道初始值就输入零向量
%           Z:输入测量得到的数据
%           F：状态转移矩阵
%           H：观测矩阵
%           Q：协方差矩阵，反映状态受外界影响的大小
%           R：测量协方差矩阵，反映测量的精度，取决于传感器
%读取数据
X=InitX;
%数据点数目
[l,s]=size(X);%获取数据维数
L=length(Z);
%初始化观测值矩阵 
Xkf=zeros(L,s);
Xkf(:,1)=X(:,1);
P=P0;
%滤波 
for i=2:L
    Xn=F*(Xkf(i-1,:)');%一步预测
   P=F*P*F'+Q;%一步预测误差方差阵
    K=P*H'*inv(H*P*H'+R);;%滤波增益矩阵（权重）
    Xkf(i,:)=Xn+K*(Z(i,:)-H*Xn);%状态误差方差阵估计
    P=(eye(s)-K*H)*P;
end 
% fig=figure(1);
% set(fig,'position',[200 200 1200 500]);
% hold on;
% plot(Z(:,1),'-b.','MarkerSize',1);
% hold on;
% plot(Xkf(:,1),'-r','MarkerSize',1);
% legend('观测轨迹','滤波轨迹');
end