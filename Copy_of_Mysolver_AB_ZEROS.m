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
file_name = 'Mc1R30v10ready';
data = readtable([file_name, '.csv']); 
data.veh_head(1)
%%
%转角，车间夹角，单位：rad(表中单位是1/1000°）
% delta1=(table2array(data(:,27))-table2array(data(:,33)))/1000/180*pi;
% delta3=(table2array(data(:,28))-table2array(data(:,34)))/1000/180*pi;
% delta4=(table2array(data(:,29))-table2array(data(:,35)))/1000/180*pi;
% delta5=(table2array(data(:,30))-table2array(data(:,36)))/1000/180*pi;
% delta6=(table2array(data(:,31))-table2array(data(:,37)))/1000/180*pi;
% delta8=(table2array(data(:,32))-table2array(data(:,38)))/1000/180*pi;
% theta=[table2array(data(:,83))/180*pi table2array(data(:,84))/180*pi];
[row,col]=size(data);
n=fix(row/5);
delta1=zeros(n,1);
delta3=zeros(n,1);
delta4=zeros(n,1);
delta5=zeros(n,1);
delta6=zeros(n,1);
delta8=zeros(n,1);
theta=zeros(n,2);
ay=zeros(n,3);
PositionAxle1=zeros(n,2);
PositionAxle34=zeros(n,2);
PositionAxle56=zeros(n,2);
PositionAxle8=zeros(n,2);


for i=1:1:n
    delta1(i)=(data.odr1_real(5*i-4)-data.odr1_diff(5*i-4))/1000/180*pi;
    delta3(i)=(data.odr2_real(5*i-4)-data.odr2_diff(5*i-4))/1000/180*pi;
    delta4(i)=(data.odr3_real(5*i-4)-data.odr3_diff(5*i-4))/1000/180*pi;
    delta5(i)=(data.odr4_real(5*i-4)-data.odr4_diff(5*i-4))/1000/180*pi;
    delta6(i)=(data.odr5_real(5*i-4)-data.odr5_diff(5*i-4))/1000/180*pi;
    delta8(i)=(data.odr6_real(5*i-4)-data.odr6_diff(5*i-4))/1000/180*pi;
    theta(i,:)=[data.angle12(5*i-4) data.angle23(5*i-4)];
%%
%加速度，橫摆角速度（表中单位是rad/s）
% ay=[table2array(data(:,75)) table2array(data(:,76)) table2array(data(:,77))];
    ay(i,:)=[data.imu_acc1_y(5*i-4) data.imu_acc2_y(5*i-4) data.imu_acc3_y(5*i-4)];
% omega=[table2array(data(:,36)) table2array(data(:,37)) table2array(data(:,38))];
% aycen=[ay(:,1)+omega(:,1).^2*(1004-12)/1000 ay(:,2)+omega(:,2).^2*(1024+4)/1000 ay(:,3)-omega(:,3).^2*(1004-12)/1000];
% aycen=[ay(:,1) ay(:,2) ay(:,3)];
%%
%RTK放在1轴中间，12铰接点，23铰接点和8轴中间,Mc1头
% PositionAxle1=table2array(data(:,[90,91]))-table2array(data(1,[90,91]));
% PositionAxle34=table2array(data(:,[94,95]))-table2array(data(1,[90,91]));
% PositionAxle56=table2array(data(:,[98,99]))-table2array(data(1,[90,91]));
% PositionAxle8=table2array(data(:,[102,103]))-table2array(data(1,[90,91]));
% PositionAxle2=(PositionAxle1*7150+PositionAxle34*1500)/8650;
% PositionAxle3=(PositionAxle1*900+PositionAxle34*7750)/8650;
% PositionAxle4=(PositionAxle34*8100+PositionAxle56*900)/9000;
% PositionAxle5=(PositionAxle34*900+PositionAxle56*8100)/9000;
% PositionAxle6=(PositionAxle56*7750+PositionAxle8*900)/8650;
% PositionAxle7=(PositionAxle56*1500+PositionAxle8*7150)/8650;
% PositionAxle12=(PositionAxle1+PositionAxle2)/2;
% PositionAxle78=(PositionAxle7+PositionAxle8)/2;
%%
%RTK放在1轴中间，12铰接点向前偏移400mm，23铰接点向后偏移400mm和8轴中间,Mc1头
% PositionAxle1=table2array(data(:,[160,161]))-table2array(data(1,[160,161]));
% PositionAxle3p=table2array(data(:,[164,165]))-table2array(data(1,[160,161]));
% PositionAxle6p=table2array(data(:,[168,169]))-table2array(data(1,[160,161]));
% PositionAxle8=table2array(data(:,[172,173]))-table2array(data(1,[160,161]));

    PositionAxle1(i,:)=[data.rtk1_lat(5*i-4)-data.rtk1_lat(1) data.rtk1_lon(5*i-4)-data.rtk1_lon(1)];
    PositionAxle34(i,:)=[data.rtk2_lat(5*i-4)-data.rtk1_lat(1) data.rtk2_lon(5*i-4)-data.rtk1_lon(1)];
    PositionAxle8(i,:)=[data.rtk3_lat(5*i-4)-data.rtk1_lat(1) data.rtk3_lon(5*i-4)-data.rtk1_lon(1)];
    PositionAxle56(i,:)=[data.rtk4_lat(5*i-4)-data.rtk1_lat(1) data.rtk4_lon(5*i-4)-data.rtk1_lon(1)];

end
figure(7)
hold on
plot(delta1*180/pi)
plot(delta3*180/pi)
plot(delta4*180/pi)
plot(delta5*180/pi)
plot(delta6*180/pi)
plot(delta8*180/pi)

% A1=PositionAxle1-APositionAxle1;
% A3p=PositionAxle3p-APositionAxle3p;
% A6p=PositionAxle6p-APositionAxle6p;
% A8=PositionAxle8-APositionAxle8;
% ay(:,1)=lowpass(ay(:,1),100,1000);
% ay(:,2)=lowpass(ay(:,2),100,1000);
% ay(:,3)=lowpass(ay(:,3),100,1000);
figure(1)
hold on
% plot(-ay(:,1))
% plot(-ay(:,2))
% plot(-ay(:,3))
% lpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
%          'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
%          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
% ay(:,1)=filtfilt(lpFilt,ay(:,1));
% ay(:,2)=filtfilt(lpFilt,ay(:,2));
% ay(:,3)=filtfilt(lpFilt,ay(:,3));
aycen=[ay(:,1) ay(:,2) ay(:,3)];


% %调整头尾
    % aycen=[ay(:,3) ay(:,2) ay(:,1)];
    % aycen=-aycen;
    % temp1=PositionAxle1;
    % temp2=PositionAxle3p;
    % temp3=PositionAxle6p;
    % temp4=PositionAxle8;
    % PositionAxle1=temp4;
    % PositionAxle3p=temp3;
    % PositionAxle6p=temp2;
    % PositionAxle8=temp1;

figure(1)
hold on
plot(aycen(:,1))
plot(aycen(:,2))
plot(aycen(:,3))

PositionAxle2=(PositionAxle1*7150+PositionAxle34*1500)/8650;
PositionAxle3=(PositionAxle1*900+PositionAxle34*7750)/8650;
PositionAxle4=(PositionAxle34*8100+PositionAxle56*900)/9000;
PositionAxle5=(PositionAxle34*900+PositionAxle56*8100)/9000;
PositionAxle6=(PositionAxle56*7750+PositionAxle8*900)/8650;
PositionAxle7=(PositionAxle56*1500+PositionAxle8*7150)/8650;
PositionAxle12=(PositionAxle1+PositionAxle2)/2;
PositionAxle78=(PositionAxle7+PositionAxle8)/2;
%%
%换头
% temp=[PositionAxle8 PositionAxle78 PositionAxle7 PositionAxle6 PositionAxle56 PositionAxle5...
%     PositionAxle4 PositionAxle34 PositionAxle3 PositionAxle2 PositionAxle12 PositionAxle1];
% PositionAxle1=temp(:,[1 2]);
% PositionAxle12=temp(:,[3 4]);
% PositionAxle2=temp(:,[5 6]);
% PositionAxle3=temp(:,[7 8]);
% PositionAxle34=temp(:,[9 10]);
% PositionAxle4=temp(:,[11 12]);
% PositionAxle5=temp(:,[13 14]);
% PositionAxle56=temp(:,[15 16]);
% PositionAxle6=temp(:,[17 18]);
% PositionAxle7=temp(:,[19 20]);
% PositionAxle78=temp(:,[21 22]);
% PositionAxle8=temp(:,[23 24]);
%%
%RTK放在12轴中间，12铰接点，23铰接点和78轴中间,Mc1头
% PositionAxle12=table2array(data(:,[90,91]))-table2array(data(1,[90,91]));
% PositionAxle34=table2array(data(:,[94,95]))-table2array(data(1,[90,91]));
% PositionAxle56=table2array(data(:,[98,99]))-table2array(data(1,[90,91]));
% PositionAxle78=table2array(data(:,[102,103]))-table2array(data(1,[90,91]));
% PositionAxle3=(PositionAxle12*900+PositionAxle34*7000)/7900;
% PositionAxle4=(PositionAxle34*8100+PositionAxle56*900)/9000;
% PositionAxle5=(PositionAxle34*900+PositionAxle56*8100)/9000;
% PositionAxle6=(PositionAxle56*7000+PositionAxle8*900)/7900;
%%
%画轨迹
figure(2)
hold on
% plot(PositionAxle6p(:,1),PositionAxle6p(:,2));
plot(PositionAxle34(:,1),PositionAxle34(:,2));

long1_2=sqrt((PositionAxle1(:,1)-PositionAxle2(:,1)).^2+(PositionAxle1(:,2)-PositionAxle2(:,2)).^2);%1500
long2_3=sqrt((PositionAxle3(:,1)-PositionAxle2(:,1)).^2+(PositionAxle3(:,2)-PositionAxle2(:,2)).^2);%6250
% long1_3p=sqrt((PositionAxle3p(:,1)-PositionAxle1(:,1)).^2+(PositionAxle3p(:,2)-PositionAxle1(:,2)).^2);%8250
long4_5=sqrt((PositionAxle4(:,1)-PositionAxle5(:,1)).^2+(PositionAxle4(:,2)-PositionAxle5(:,2)).^2);%7200
long6_7=sqrt((PositionAxle6(:,1)-PositionAxle7(:,1)).^2+(PositionAxle6(:,2)-PositionAxle7(:,2)).^2);%6250
% long6p_8=sqrt((PositionAxle6p(:,1)-PositionAxle8(:,1)).^2+(PositionAxle6p(:,2)-PositionAxle8(:,2)).^2);%8250
long7_8=sqrt((PositionAxle7(:,1)-PositionAxle8(:,1)).^2+(PositionAxle7(:,2)-PositionAxle8(:,2)).^2);%1500
long3_34=sqrt((PositionAxle34(:,1)-PositionAxle3(:,1)).^2+(PositionAxle34(:,2)-PositionAxle3(:,2)).^2);%900
long34_4=sqrt((PositionAxle34(:,1)-PositionAxle4(:,1)).^2+(PositionAxle34(:,2)-PositionAxle4(:,2)).^2);%900
long5_56=sqrt((PositionAxle56(:,1)-PositionAxle5(:,1)).^2+(PositionAxle56(:,2)-PositionAxle5(:,2)).^2);%900
long56_6=sqrt((PositionAxle56(:,1)-PositionAxle6(:,1)).^2+(PositionAxle56(:,2)-PositionAxle6(:,2)).^2);%900
long1_34=sqrt((PositionAxle34(:,1)-PositionAxle1(:,1)).^2+(PositionAxle34(:,2)-PositionAxle1(:,2)).^2);%8650
long56_8=sqrt((PositionAxle56(:,1)-PositionAxle8(:,1)).^2+(PositionAxle56(:,2)-PositionAxle8(:,2)).^2);%8650
long34_56=sqrt((PositionAxle56(:,1)-PositionAxle34(:,1)).^2+(PositionAxle56(:,2)-PositionAxle34(:,2)).^2);%9000
figure(3)
hold on
step=length(PositionAxle1)/10; % second
number=0;
colormap=['k','r','g','m','b'];
j=1;
for i=1:length(PositionAxle1)
    if i>=number*step
        
        plot([PositionAxle1(i,1) PositionAxle2(i,1)],[PositionAxle1(i,2) PositionAxle2(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle2(i,1) PositionAxle3(i,1)],[PositionAxle2(i,2) PositionAxle3(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle3(i,1) PositionAxle34(i,1)],[PositionAxle3(i,2) PositionAxle34(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle34(i,1) PositionAxle4(i,1)],[PositionAxle34(i,2) PositionAxle4(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle4(i,1) PositionAxle5(i,1)],[PositionAxle4(i,2) PositionAxle5(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle5(i,1) PositionAxle56(i,1)],[PositionAxle5(i,2) PositionAxle56(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle56(i,1) PositionAxle6(i,1)],[PositionAxle56(i,2) PositionAxle6(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle6(i,1) PositionAxle7(i,1)],[PositionAxle6(i,2) PositionAxle7(i,2)],colormap( j ),'LineWidth',3);
        plot([PositionAxle7(i,1) PositionAxle8(i,1)],[PositionAxle7(i,2) PositionAxle8(i,2)],colormap( j ),'LineWidth',3);

                
        xlabel('x方向位置(m)');
        ylabel('y方向位置(m)');
        title('汽车转向轨迹俯视图')
        
        plot(PositionAxle1(i,1),PositionAxle1(i,2),'ob') 
        plot(PositionAxle2(i,1),PositionAxle2(i,2),'ob')
        plot(PositionAxle3(i,1),PositionAxle3(i,2),'ob')
        plot(PositionAxle4(i,1),PositionAxle4(i,2),'ob')
        plot(PositionAxle5(i,1),PositionAxle5(i,2),'ob')
        plot(PositionAxle6(i,1),PositionAxle6(i,2),'ob')
        plot(PositionAxle7(i,1),PositionAxle7(i,2),'ob')
        plot(PositionAxle8(i,1),PositionAxle8(i,2),'ob')
        plot(PositionAxle34(i,1),PositionAxle34(i,2),'ob')
        plot(PositionAxle56(i,1),PositionAxle56(i,2),'ob')

        
        j=j+1; 
        if j>5
            j=j-5;
        end
        number=number+1;
    end
end

%%
%求侧偏角
row=length(PositionAxle1);
anglev=zeros(row-1,6);
anglecar=zeros(row-1,3);
alpha=zeros(row-1,6);
k=zeros(row-1,3);
Fty=zeros(row-1,6);
for i=1:1:(row-1)
    anglev(i,:)=[atan2((PositionAxle1(i+1,2)-PositionAxle1(i,2)),(PositionAxle1(i+1,1)-PositionAxle1(i,1)))...
        atan2((PositionAxle3(i+1,2)-PositionAxle3(i,2)),(PositionAxle3(i+1,1)-PositionAxle3(i,1)))...
        atan2((PositionAxle4(i+1,2)-PositionAxle4(i,2)),(PositionAxle4(i+1,1)-PositionAxle4(i,1)))...
        atan2((PositionAxle5(i+1,2)-PositionAxle5(i,2)),(PositionAxle5(i+1,1)-PositionAxle5(i,1)))...
        atan2((PositionAxle6(i+1,2)-PositionAxle6(i,2)),(PositionAxle6(i+1,1)-PositionAxle6(i,1)))...
        atan2((PositionAxle8(i+1,2)-PositionAxle8(i,2)),(PositionAxle8(i+1,1)-PositionAxle8(i,1)))];
    anglecar(i,:)=[atan2((PositionAxle1(i,2)-PositionAxle34(i,2)),(PositionAxle1(i,1)-PositionAxle34(i,1)))...
        atan2((PositionAxle34(i,2)-PositionAxle56(i,2)),(PositionAxle34(i,1)-PositionAxle56(i,1)))...
        atan2((PositionAxle56(i,2)-PositionAxle8(i,2)),(PositionAxle56(i,1)-PositionAxle8(i,1)))];
%     alpha(i,:)=[anglev(i,1)-anglecar(i,1)-delta1(i)...
%         anglev(i,2)-anglecar(i,1)-delta3(i)...
%         anglev(i,3)-anglecar(i,2)-delta4(i)...
%         anglev(i,4)-anglecar(i,2)-delta5(i)...
%         anglev(i,5)-anglecar(i,3)-delta6(i)...
%         anglev(i,6)-anglecar(i,3)-delta8(i)];
end

% for i=1:1:6
%     anglev(:,i)=filtfilt(lpFilt,anglev(:,i));
% end
% for i=1:1:3
%     anglecar(:,i)=filtfilt(lpFilt,anglecar(:,i));
% end
% figure(4)
% hold on
% plot(anglev(:,6))

%手动排除前边振荡的数据
anglev(294,1)=-3.12373740849265;

% for i=1:1:(row-1)
%     for j=1:1:6
%         if anglev(i,j)==0
%             anglev(i,j)=anglev(i+1,j);
%         end
%         if anglev(i,j)==0
%             anglev(i,j)=anglev(i+2,j);
%         end
%     end
% end
% % figure(20)
% % hold on
% % plot(anglev(:,1))
% for j=1:1:6
%     if (abs(anglev(1,j)-anglev(2,j))>0.1)...
%             &&(abs(anglev(1,j)-anglev(3,j))>0.1)
%         anglev(1,j)=anglev(2,j);
%     end
% end
% temp1=anglev;
% temp=anglev;
% for i=2:1:(row-1)
%     for j=1:1:6
%         if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
%                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi)...
%                 &&(abs(temp1(i,j)-temp1(i-1,j))>0.1))
%             % i
%             % j
%            temp1(i,j) = temp(i-1,j);
%         end
%         if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
%                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
%                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
%                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
%            temp1(i,j) = temp(i-2,j);
%         end
%         if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
%                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
%                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
%                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
%            temp1(i,j) = temp(i-3,j);
%         end
%         if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
%                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
%                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
%                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
%            temp1(i,j) = temp(i-4,j);
%         end
%     end
% end
% anglev=temp1;
figure(20)
hold on
plot(anglev(:,1))
plot(anglev(:,2))
plot(anglev(:,3))
plot(anglev(:,4))
plot(anglev(:,5))
plot(anglev(:,6))

for i=60:1:(row-1)
    for t=1:1:6
        if (anglev(i,t)-anglev(i-1,t))<(-3/2*pi)
            for j=i:1:(row-1)
                anglev(j,t)=anglev(j,t)+2*pi;
            end
        end
        if (anglev(i,t)-anglev(i-1,t))>(3/2*pi)
            for j=i:1:(row-1)
                anglev(j,t)=anglev(j,t)-2*pi;
            end
        end
    end
end
%保持一致
for i=60:1:(row-1)
    for t=1:1:3
        if (anglecar(i,t)-anglecar(i-1,t))<(-3/2*pi)
            for j=i:1:(row-1)
                anglecar(j,t)=anglecar(j,t)+2*pi;
            end
        end
        if (anglecar(i,t)-anglecar(i-1,t))>(3/2*pi)
            for j=i:1:(row-1)
                anglecar(j,t)=anglecar(j,t)-2*pi;
            end
        end
    end
end
alpha=[anglev(:,1)-anglecar(:,1)-delta1(1:(row-1))...
        anglev(:,2)-anglecar(:,1)-delta3(1:(row-1))...
        anglev(:,3)-anglecar(:,2)-delta4(1:(row-1))...
        anglev(:,4)-anglecar(:,2)-delta5(1:(row-1))...
        anglev(:,5)-anglecar(:,3)-delta6(1:(row-1))...
        anglev(:,6)-anglecar(:,3)-delta8(1:(row-1))];
figure(4)
hold on
plot(anglev(:,1))
plot(anglev(:,2))
plot(anglev(:,3))
plot(anglev(:,4))
plot(anglev(:,5))
plot(anglev(:,6))
title('anglev')
figure(5)
hold on
plot(anglecar(:,1))
plot(anglecar(:,2))
plot(anglecar(:,3))
title('anglecar')
%对侧偏角滤波
figure(6)
% hold on
% plot(alpha(:,1))

% lpFilt2 = designfilt('lowpassfir','PassbandFrequency',0.025, ...
%          'StopbandFrequency',0.035,'PassbandRipple',0.05, ...
%          'StopbandAttenuation',6.5,'DesignMethod','kaiserwin');
% for i=1:1:6
%     alpha(:,i)=filtfilt(lpFilt2,alpha(:,i));
% end

figure(6)
hold on
plot(alpha(:,1)*180/pi)
plot(alpha(:,2)*180/pi)
plot(alpha(:,3)*180/pi)
plot(alpha(:,4)*180/pi)
plot(alpha(:,5)*180/pi)
plot(alpha(:,6)*180/pi)
title('alpha')
%%
alphaa=mean(alpha(120:end,:));
aycena=mean(aycen(120:end,:));
thetaa=mean(theta(120:end,:));
delta1a=mean(delta1(120:end));
delta3a=mean(delta3(120:end));
delta4a=mean(delta4(120:end));
delta5a=mean(delta5(120:end));
delta6a=mean(delta6(120:end));
delta8a=mean(delta8(120:end));

for i=120:1:(row-1)
    syms Fx1 Fx2 Fx3 Fx4 Fx5 Fx6 Fy1 Fy2 Fy3 Fy4 Fy5 Fy6 Ftx1 Ftx2 Ftx3 Ftx4 Ftx5 Ftx6 Fty1 Fty2 Fty3 Fty4 Fty5 Fty6 
    syms FJ11x FJ11y FJ12x FJ12y FJ22x FJ22y FJ23x FJ23y f k16 k25 k34
    
%     feq1=Fx1+Fx2+FJ11x==0;
    A1=zeros(1,36);
    A1([1 2 25])=[1 1 1];
    B1=0;
%     feq2=Fy1+Fy2+FJ11y-m1*aycen(i,1)==0;
    A2=zeros(1,36);
    A2([7 8 26])=[1 1 1];
    B2=m1*aycen(i,1);
%     feq3=Fy1*a1-Fy2*b1-FJ11y*c1==0;
    A3=zeros(1,36);
    A3([7 8 26])=[a1 -b1 -c1];
    B3=0;
%     feq4=Fx3+Fx4+FJ12x+FJ22x==0;
    A4=zeros(1,36);
    A4([3 4 27 29])=[1 1 1 1];
    B4=0;
%     feq5=Fy3+Fy4+FJ12y+FJ22y-m2*aycen(i,2)==0;
    A5=zeros(1,36);
    A5([9 10 28 30])=[1 1 1 1];
    B5=m2*aycen(i,2);
%     feq6=Fy3*a2-Fy4*b2+FJ12y*d2-FJ22y*c2==0;
    A6=zeros(1,36);
    A6([9 10 28 30])=[a2 -b2 d2 -c2];
    B6=0;
%     feq7=Fx5+Fx6+FJ23x==0;
    A7=zeros(1,36);
    A7([5 6 31])=[1 1 1];
    B7=0;
%     feq8=Fy5+Fy6+FJ23y-m3*aycen(i,3)==0;
    A8=zeros(1,36);
    A8([11 12 32])=[1 1 1];
    B8=m3*aycen(i,3);
%     feq9=Fy5*a3-Fy6*b3-FJ23y*d3==0;
    A9=zeros(1,36);
    A9([11 12 32])=[a3 -b3 -d3];
    B9=0;
    
%     feq10=FJ12x+FJ11x*cos(theta(i,1))-FJ11y*sin(theta(i,1))==0;
    A10=zeros(1,36);
    A10([25 26 27])=[cos(theta(i,1)) -sin(theta(i,1)) 1];
    B10=0;
%     feq11=FJ12y+FJ11x*sin(theta(i,1))+FJ11y*cos(theta(i,1))==0;
    A11=zeros(1,36);
    A11([25 26 28])=[sin(theta(i,1)) cos(theta(i,1)) 1];
    B11=0;
%     feq12=FJ23x+FJ22x*cos(theta(i,2))-FJ22y*sin(theta(i,2))==0;
    A12=zeros(1,36);
    A12([29 30 31])=[cos(theta(i,2)) -sin(theta(i,2)) 1];
    B12=0;
%     feq13=FJ23y+FJ22x*sin(theta(i,2))+FJ22y*cos(theta(i,2))==0;
    A13=zeros(1,36);
    A13([29 30 32])=[sin(theta(i,2)) cos(theta(i,2)) 1];
    B13=0;
    
%     feq14=Ftx2+f*G2==0;
    A14=zeros(1,36);
    A14([14 33])=[1 G2];
    B14=0;
%     feq15=Ftx3+f*G3==0;
    A15=zeros(1,36);
    A15([15 33])=[1 G3];
    B15=0;
%     feq16=Ftx4+f*G4==0;
    A16=zeros(1,36);
    A16([16 33])=[1 G4];
    B16=0;
%     feq17=Ftx5+f*G5==0;
    A17=zeros(1,36);
    A17([17 33])=[1 G5];
    B17=0;
%     feq18=Ftx6+f*G6==0;
    A18=zeros(1,36);
    A18([18 33])=[1 G6];
    B18=0;

%     feq19=Fty1-k16*alpha(i,1)==0;
    A19=zeros(1,36);
    A19([19 34])=[1 -alpha(i,1)];
    B19=0;
%     feq20=Fty2-k25*alpha(i,2)==0;
    A20=zeros(1,36);
    A20([20 35])=[1 -alpha(i,2)];
    B20=0;
%     feq21=Fty3-k34*alpha(i,3)==0;
    A21=zeros(1,36);
    A21([21 36])=[1 -alpha(i,3)];
    B21=0;
%     feq22=Fty6-k16*alpha(i,6)==0;
    A22=zeros(1,36);
    A22([24 34])=[1 -alpha(i,6)];
    B22=0;
%     feq23=Fty5-k25*alpha(i,5)==0;
    A23=zeros(1,36);
    A23([23 35])=[1 -alpha(i,5)];
    B23=0;
%     feq24=Fty4-k34*alpha(i,4)==0;
    A24=zeros(1,36);
    A24([22 36])=[1 -alpha(i,4)];
    B24=0;
    
%     feq25=Fx1-Ftx1*cos(delta1(i))+Fty1*sin(delta1(i))==0;
    A25=zeros(1,36);
    A25([1 13 19])=[1 -cos(delta1(i)) sin(delta1(i))];
    B25=0;
%     feq26=Fy1-Ftx1*sin(delta1(i))-Fty1*cos(delta1(i))==0;
    A26=zeros(1,36);
    A26([7 13 19])=[1 -sin(delta1(i)) -cos(delta1(i))];
    B26=0;
%     feq27=Fx2-Ftx2*cos(delta3(i))+Fty2*sin(delta3(i))==0;
    A27=zeros(1,36);
    A27([2 14 20])=[1 -cos(delta3(i)) sin(delta3(i))];
    B27=0;
%     feq28=Fy2-Ftx2*sin(delta3(i))-Fty2*cos(delta3(i))==0;
    A28=zeros(1,36);
    A28([8 14 20])=[1 -sin(delta3(i)) -cos(delta3(i))];
    B28=0;
%     feq29=Fx3-Ftx3*cos(delta4(i))+Fty3*sin(delta4(i))==0;
    A29=zeros(1,36);
    A29(3)=1;A29(15)=-cos(delta4(i));A29(21)=sin(delta4(i));
    B29=0;
%     feq30=Fy3-Ftx3*sin(delta4(i))-Fty3*cos(delta4(i))==0;
    A30=zeros(1,36);
    A30(9)=1;A30(15)=-sin(delta4(i));A30(21)=-cos(delta4(i));
    B30=0;
%     feq31=Fx4-Ftx4*cos(delta5(i))+Fty4*sin(delta5(i))==0;
    A31=zeros(1,36);
    A31(4)=1;A31(16)=-cos(delta5(i));A31(22)=sin(delta5(i));
    B31=0;
%     feq32=Fy4-Ftx4*sin(delta5(i))-Fty4*cos(delta5(i))==0;
    A32=zeros(1,36);
    A32(10)=1;A32(16)=-sin(delta5(i));A32(22)=-cos(delta5(i));
    B32=0;
%     feq33=Fx5-Ftx5*cos(delta6(i))+Fty5*sin(delta6(i))==0;
    A33=zeros(1,36);
    A33(5)=1;A33(17)=-cos(delta6(i));A33(23)=sin(delta6(i));
    B33=0;
%     feq34=Fy5-Ftx5*sin(delta6(i))-Fty5*cos(delta6(i))==0;
    A34=zeros(1,36);
    A34(11)=1;A34(17)=-sin(delta6(i));A34(23)=-cos(delta6(i));
    B34=0;
%     feq35=Fx6-Ftx6*cos(delta8(i))+Fty6*sin(delta8(i))==0;
    A35=zeros(1,36);
    A35(6)=1;A35(18)=-cos(delta8(i));A35(24)=sin(delta8(i));
    B35=0;
%     feq36=Fy6-Ftx6*sin(delta8(i))-Fty6*cos(delta8(i))==0;
    A36=zeros(1,36);
    A36(12)=1;A36(18)=-sin(delta8(i));A36(24)=-cos(delta8(i));
    B36=0;

%     allanswer=solve([feq1 feq2 feq3 feq4 feq5 feq6 feq7 feq8 feq9 feq10 feq11 feq12 feq13 feq14 feq15 ...
%         feq16 feq17 feq18 feq19 feq20 feq21 feq22 feq23 feq24 feq25 feq26 feq27 feq28 feq29 feq30 ...
%         feq31 feq32 feq33 feq34 feq35 feq36],[Fx1 Fx2 Fx3 Fx4 Fx5 Fx6 Fy1 Fy2 Fy3 Fy4 Fy5 Fy6 Ftx1 ...
%         Ftx2 Ftx3 Ftx4 Ftx5 Ftx6 Fty1 Fty2 Fty3 Fty4 Fty5 Fty6 FJ11x FJ11y FJ12x FJ12y FJ22x...
%         FJ22y FJ23x FJ23y f k16 k25 k34]);

    A=[A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;A11;A12;A13;A14;A15;A16;A17;A18;A19;...
        A20;A21;A22;A23;A24;A25;A26;A27;A28;A29;A30;A31;A32;A33;A34;A35;A36];
    B=[B1;B2;B3;B4;B5;B6;B7;B8;B9;B10;B11;B12;B13;B14;B15;B16;B17;B18;B19;...
        B20;B21;B22;B23;B24;B25;B26;B27;B28;B29;B30;B31;B32;B33;B34;B35;B36];    
   temp0=A\B; 
%     k(i,:)=[double(allanswer.k16) double(allanswer.k25) double(allanswer.k34)];
%     Fty(i,:)=[double(allanswer.Fty1) double(allanswer.Fty2) double(allanswer.Fty3) double(allanswer.Fty4) ...
%         double(allanswer.Fty5) double(allanswer.Fty6)];
    k(i,:)=temp0(34:36);
    Fty(i,:)=temp0(19:24);

end
figure(8)
plot(Fty(:,1))
% plot(alpha(:,1),Fty(:,1),'*')
    
