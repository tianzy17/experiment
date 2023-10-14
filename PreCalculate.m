function [alphaa,axa,aycena,thetaa,deltaa,thetaa_rtk]=PreCalculate(file_name,start)
    arguments
        file_name {mustBeText}
        start {mustBeInteger}
    end
    % 作用：读取csv数据，输出后续计算所需数据的平均值
    % 输入：
    %   file_name:不带后缀的文件名
    %   start:规定从第多少行数据开入读取
    % 输出
    %     alphaa:1~6轴轮胎侧偏角平均值，实际对应车上第(1/2)/3/4/5/6/(7/8)轴,double(1,6)
    %     axa:1~3车纵向加速度平均值double(1,3)
    %     aycena:1~3侧向加速度平均值double(1,3)
    %     thetaa:传感器测量得到的(Mc1/T)/(T/Mc2)车间夹角平均值double(1,2)
    %     deltaa:1~6轴轮胎转角平均值，实际对应车上第(1/2)/3/4/5/6/(7/8)轴,double(1,6)
    %     thetaa_rtk:用RTK数据差分得到的(Mc1/T)/(T/Mc2)车间夹角平均值double(1,2)

    %R30v5/v10ready从10开始 R30v15从524开始 R30v20ready从41开始
    %R20v10ready/v15ready/v20从10开始
    start=start+1;
    data = readtable([file_name, '.csv']);
    data.veh_head(1);
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
    v=zeros(n,1);
    delta1=zeros(n,1);
    delta3=zeros(n,1);
    delta4=zeros(n,1);
    delta5=zeros(n,1);
    delta6=zeros(n,1);
    delta8=zeros(n,1);
    theta=zeros(n,2);
    ay=zeros(n,3);
    ax=zeros(n,3);
    PositionAxle1=zeros(n,2);
    PositionAxle34=zeros(n,2);
    PositionAxle56=zeros(n,2);
    PositionAxle8=zeros(n,2);
    
    
    for i=1:1:n
        v(i)=data.vel_final(5*i-4);
        delta1(i)=(data.odr1_real(5*i-4)-data.odr1_diff(5*i-4))/1000/180*pi;
        delta3(i)=(data.odr2_real(5*i-4)-data.odr2_diff(5*i-4))/1000/180*pi;
        delta4(i)=(data.odr3_real(5*i-4)-data.odr3_diff(5*i-4))/1000/180*pi;
        delta5(i)=(data.odr4_real(5*i-4)-data.odr4_diff(5*i-4))/1000/180*pi;
        delta6(i)=(data.odr5_real(5*i-4)-data.odr5_diff(5*i-4))/1000/180*pi;
        delta8(i)=(data.odr6_real(5*i-4)-data.odr6_diff(5*i-4))/1000/180*pi;
        theta(i,:)=[data.angle12(5*i-4) data.angle23(5*i-4)];
        %%
        %加速度，橫摆角速度（表中单位是rad/s）
        % ay=[table2array(data(:,75)) table2array(data(:,76))
        % table2array(data(:,77))];
        ax(i,:)=[data.imu_acc1_x(5*i-4) data.imu_acc2_x(5*i-4) data.imu_acc3_x(5*i-4)];
        ay(i,:)=[data.imu_acc1_y(5*i-4) data.imu_acc2_y(5*i-4) data.imu_acc3_y(5*i-4)];
        % omega=[table2array(data(:,36)) table2array(data(:,37))
        % table2array(data(:,38))]; aycen=[ay(:,1)+omega(:,1).^2*(1004-12)/1000
        % ay(:,2)+omega(:,2).^2*(1024+4)/1000
        % ay(:,3)-omega(:,3).^2*(1004-12)/1000]; aycen=[ay(:,1) ay(:,2)
        % ay(:,3)];
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
    % figure(24) plot(v)
    
    delta1=medfilt1(delta1);
    delta8=medfilt1(delta8);
    delta3=medfilt1(delta3);
    delta4=medfilt1(delta4);
    delta5=medfilt1(delta5);
    delta6=medfilt1(delta6);
    
    delta1=medfilt1(delta1);
    delta8=medfilt1(delta8);
    delta3=medfilt1(delta3);
    delta4=medfilt1(delta4);
    delta5=medfilt1(delta5);
    delta6=medfilt1(delta6);
    
    delta1=medfilt1(delta1);
    delta8=medfilt1(delta8);
    delta3=medfilt1(delta3);
    delta4=medfilt1(delta4);
    delta5=medfilt1(delta5);
    delta6=medfilt1(delta6);
    
    % figure(7) hold on plot(delta1*180/pi,'.') plot(delta3*180/pi)
    % plot(delta4*180/pi) plot(delta5*180/pi) plot(delta6*180/pi)
    % plot(delta8*180/pi,'--')
    
    theta(:,1)=medfilt1(theta(:,1));
    theta(:,2)=medfilt1(theta(:,2));
    
    theta(:,1)=medfilt1(theta(:,1));
    theta(:,2)=medfilt1(theta(:,2));
    
    theta(:,1)=medfilt1(theta(:,1));
    theta(:,2)=medfilt1(theta(:,2));
    
    % figure(22) hold on plot(theta(:,1)) plot(theta(:,2))
    % A1=PositionAxle1-APositionAxle1; A3p=PositionAxle3p-APositionAxle3p;
    % A6p=PositionAxle6p-APositionAxle6p; A8=PositionAxle8-APositionAxle8;
    % ay(:,1)=lowpass(ay(:,1),100,1000); ay(:,2)=lowpass(ay(:,2),100,1000);
    % ay(:,3)=lowpass(ay(:,3),100,1000); figure(1) hold on plot(-ay(:,1))
    % plot(-ay(:,2)) plot(-ay(:,3)) lpFilt =
    % designfilt('lowpassfir','PassbandFrequency',0.25, ...
    %          'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
    %          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
    % ay(:,1)=filtfilt(lpFilt,ay(:,1)); ay(:,2)=filtfilt(lpFilt,ay(:,2));
    % ay(:,3)=filtfilt(lpFilt,ay(:,3));
    aycen=[ay(:,1) ay(:,2) ay(:,3)];
    
    
    % %调整头尾 aycen=[ay(:,3) ay(:,2) ay(:,1)]; aycen=-aycen; temp1=PositionAxle1;
    % temp2=PositionAxle3p; temp3=PositionAxle6p; temp4=PositionAxle8;
    % PositionAxle1=temp4; PositionAxle3p=temp3; PositionAxle6p=temp2;
    % PositionAxle8=temp1;
    
    % figure(1) hold on plot(aycen(:,1)) plot(aycen(:,2)) plot(aycen(:,3))
    % title('ay')
    
    % figure(25) hold on plot(ax(:,1)) plot(ax(:,2)) plot(ax(:,3)) title('ax')
    
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
    % temp=[PositionAxle8 PositionAxle78 PositionAxle7 PositionAxle6
    % PositionAxle56 PositionAxle5...
    %     PositionAxle4 PositionAxle34 PositionAxle3 PositionAxle2
    %     PositionAxle12 PositionAxle1];
    % PositionAxle1=temp(:,[1 2]); PositionAxle12=temp(:,[3 4]);
    % PositionAxle2=temp(:,[5 6]); PositionAxle3=temp(:,[7 8]);
    % PositionAxle34=temp(:,[9 10]); PositionAxle4=temp(:,[11 12]);
    % PositionAxle5=temp(:,[13 14]); PositionAxle56=temp(:,[15 16]);
    % PositionAxle6=temp(:,[17 18]); PositionAxle7=temp(:,[19 20]);
    % PositionAxle78=temp(:,[21 22]); PositionAxle8=temp(:,[23 24]);
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
    % figure(2) hold on plot(PositionAxle6p(:,1),PositionAxle6p(:,2));
    % plot(PositionAxle34(:,1),PositionAxle34(:,2));
    
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
    % figure(3) hold on step=length(PositionAxle1)/10; % second number=0;
    % colormap=['k','r','g','m','b']; j=1; for i=1:length(PositionAxle1)
    %     if i>=number*step
    %
    %         plot([PositionAxle1(i,1) PositionAxle2(i,1)],[PositionAxle1(i,2)
    %         PositionAxle2(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle2(i,1) PositionAxle3(i,1)],[PositionAxle2(i,2)
    %         PositionAxle3(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle3(i,1) PositionAxle34(i,1)],[PositionAxle3(i,2)
    %         PositionAxle34(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle34(i,1)
    %         PositionAxle4(i,1)],[PositionAxle34(i,2)
    %         PositionAxle4(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle4(i,1) PositionAxle5(i,1)],[PositionAxle4(i,2)
    %         PositionAxle5(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle5(i,1) PositionAxle56(i,1)],[PositionAxle5(i,2)
    %         PositionAxle56(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle56(i,1)
    %         PositionAxle6(i,1)],[PositionAxle56(i,2)
    %         PositionAxle6(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle6(i,1) PositionAxle7(i,1)],[PositionAxle6(i,2)
    %         PositionAxle7(i,2)],colormap( j ),'LineWidth',3);
    %         plot([PositionAxle7(i,1) PositionAxle8(i,1)],[PositionAxle7(i,2)
    %         PositionAxle8(i,2)],colormap( j ),'LineWidth',3);
    %
    %
    %         xlabel('x方向位置(m)'); ylabel('y方向位置(m)'); title('汽车转向轨迹俯视图')
    %
    %         plot(PositionAxle1(i,1),PositionAxle1(i,2),'ob')
    %         plot(PositionAxle2(i,1),PositionAxle2(i,2),'ob')
    %         plot(PositionAxle3(i,1),PositionAxle3(i,2),'ob')
    %         plot(PositionAxle4(i,1),PositionAxle4(i,2),'ob')
    %         plot(PositionAxle5(i,1),PositionAxle5(i,2),'ob')
    %         plot(PositionAxle6(i,1),PositionAxle6(i,2),'ob')
    %         plot(PositionAxle7(i,1),PositionAxle7(i,2),'ob')
    %         plot(PositionAxle8(i,1),PositionAxle8(i,2),'ob')
    %         plot(PositionAxle34(i,1),PositionAxle34(i,2),'ob')
    %         plot(PositionAxle56(i,1),PositionAxle56(i,2),'ob')
    %
    %
    %         j=j+1; if j>5
    %             j=j-5;
    %         end number=number+1;
    %     end
    % end
    
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
    % end for i=1:1:3
    %     anglecar(:,i)=filtfilt(lpFilt,anglecar(:,i));
    % end figure(4) hold on plot(anglev(:,6))
    
    %手动排除前边振荡的数据
    % anglev(294,1)=-3.12373740849265;
    
    % for i=1:1:(row-1)
    %     for j=1:1:6
    %         if anglev(i,j)==0
    %             anglev(i,j)=anglev(i+1,j);
    %         end if anglev(i,j)==0
    %             anglev(i,j)=anglev(i+2,j);
    %         end
    %     end
    % end % figure(20) % hold on % plot(anglev(:,1)) for j=1:1:6
    %     if (abs(anglev(1,j)-anglev(2,j))>0.1)...
    %             &&(abs(anglev(1,j)-anglev(3,j))>0.1)
    %         anglev(1,j)=anglev(2,j);
    %     end
    % end temp1=anglev; temp=anglev; for i=2:1:(row-1)
    %     for j=1:1:6
    %         if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
    %                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi)...
    %                 &&(abs(temp1(i,j)-temp1(i-1,j))>0.1))
    %             % i % j
    %            temp1(i,j) = temp(i-1,j);
    %         end if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
    %                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
    %                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
    %                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
    %            temp1(i,j) = temp(i-2,j);
    %         end if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
    %                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
    %                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
    %                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
    %            temp1(i,j) = temp(i-3,j);
    %         end if (abs(temp1(i,j)-temp(i-1,j))>0.1)...
    %                 &&(abs(temp1(i,j)-temp(i-1,j))<(3/4*pi))...
    %                 &&((abs(temp1(i,j)-temp1(i-1,j))>0.1)...
    %                 ||(abs(temp1(i,j)-temp1(i-2,j))>0.1))
    %            temp1(i,j) = temp(i-4,j);
    %         end
    %     end
    % end anglev=temp1;
    
    
    %
    anglecar(:,1)=medfilt1(anglecar(:,1));
    anglecar(:,2)=medfilt1(anglecar(:,2));
    anglecar(:,3)=medfilt1(anglecar(:,3));
    
    anglecar(:,1)=medfilt1(anglecar(:,1));
    anglecar(:,2)=medfilt1(anglecar(:,2));
    anglecar(:,3)=medfilt1(anglecar(:,3));
    
    anglecar(:,1)=medfilt1(anglecar(:,1));
    anglecar(:,2)=medfilt1(anglecar(:,2));
    anglecar(:,3)=medfilt1(anglecar(:,3));
    
    % figure(20) hold on plot(anglev(:,1)) plot(anglev(:,2)) plot(anglev(:,3))
    % plot(anglev(:,4)) plot(anglev(:,5)) plot(anglev(:,6))
    %
    % figure(23) hold on plot(anglecar(:,1)) plot(anglecar(:,2))
    % plot(anglecar(:,3))
    
    
    for i=(start-1):1:(row-1)
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
    for i=(start-1):1:(row-1)
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
    
    anglev(:,1)=medfilt1(anglev(:,1));
    anglev(:,2)=medfilt1(anglev(:,2));
    anglev(:,3)=medfilt1(anglev(:,3));
    anglev(:,4)=medfilt1(anglev(:,4));
    anglev(:,5)=medfilt1(anglev(:,5));
    anglev(:,6)=medfilt1(anglev(:,6));
    
    % anglev(:,1)=medfilt1(anglev(:,1)); anglev(:,2)=medfilt1(anglev(:,2));
    % anglev(:,3)=medfilt1(anglev(:,3)); anglev(:,4)=medfilt1(anglev(:,4));
    % anglev(:,5)=medfilt1(anglev(:,5)); anglev(:,6)=medfilt1(anglev(:,6));
    %
    % anglev(:,1)=medfilt1(anglev(:,1)); anglev(:,2)=medfilt1(anglev(:,2));
    % anglev(:,3)=medfilt1(anglev(:,3)); anglev(:,4)=medfilt1(anglev(:,4));
    % anglev(:,5)=medfilt1(anglev(:,5)); anglev(:,6)=medfilt1(anglev(:,6));
    %
    anglev(:,1)=medfilt1(anglev(:,1),6);
    anglev(:,2)=medfilt1(anglev(:,2),6);
    anglev(:,3)=medfilt1(anglev(:,3),6);
    anglev(:,4)=medfilt1(anglev(:,4),6);
    anglev(:,5)=medfilt1(anglev(:,5),6);
    anglev(:,6)=medfilt1(anglev(:,6),6);
    
    anglev(:,1)=medfilt1(anglev(:,1),6);
    anglev(:,2)=medfilt1(anglev(:,2),6);
    anglev(:,3)=medfilt1(anglev(:,3),6);
    anglev(:,4)=medfilt1(anglev(:,4),6);
    anglev(:,5)=medfilt1(anglev(:,5),6);
    anglev(:,6)=medfilt1(anglev(:,6),6);
    
    alpha=[anglev(:,1)-anglecar(:,1)-delta1(1:(row-1))...
        anglev(:,2)-anglecar(:,1)-delta3(1:(row-1))...
        anglev(:,3)-anglecar(:,2)-delta4(1:(row-1))...
        anglev(:,4)-anglecar(:,2)-delta5(1:(row-1))...
        anglev(:,5)-anglecar(:,3)-delta6(1:(row-1))...
        anglev(:,6)-anglecar(:,3)-delta8(1:(row-1))];
    
    % alpha=[anglev(:,1)-anglecar(:,1)...
    %         anglev(:,2)-anglecar(:,1)... anglev(:,3)-anglecar(:,2)...
    %         anglev(:,4)-anglecar(:,2)... anglev(:,5)-anglecar(:,3)...
    %         anglev(:,6)-anglecar(:,3)];
    
    % figure(4) hold on plot(anglev(:,1)) plot(anglev(:,2)) plot(anglev(:,3))
    % plot(anglev(:,4)) plot(anglev(:,5)) plot(anglev(:,6)) title('anglev')
    % figure(5) hold on plot(anglecar(:,1)) plot(anglecar(:,2))
    % plot(anglecar(:,3)) title('anglecar') %对侧偏角滤波 figure(6) hold on
    % plot(alpha(:,1))
    
    % lpFilt2 = designfilt('lowpassfir','PassbandFrequency',0.025, ...
    %          'StopbandFrequency',0.035,'PassbandRipple',0.05, ...
    %          'StopbandAttenuation',6.5,'DesignMethod','kaiserwin');
    % for i=1:1:6
    %     alpha(:,i)=filtfilt(lpFilt2,alpha(:,i));
    % end
    
    % alpha(:,1)=medfilt1(alpha(:,1),6); alpha(:,2)=medfilt1(alpha(:,2),6);
    % alpha(:,3)=medfilt1(alpha(:,3),6); alpha(:,4)=medfilt1(alpha(:,4),6);
    % alpha(:,5)=medfilt1(alpha(:,5),6); alpha(:,6)=medfilt1(alpha(:,6),6);
    
    % figure(6) hold on plot(alpha(:,1)*180/pi) plot(alpha(:,2)*180/pi)
    % plot(alpha(:,3)*180/pi) plot(alpha(:,4)*180/pi) plot(alpha(:,5)*180/pi)
    % plot(alpha(:,6)*180/pi) title('alpha')
    %
    % % start=11;
    figure(21)
    hold on
    plot(alpha(start:end,1)*180/pi)
    plot(alpha(start:end,2)*180/pi)
    plot(alpha(start:end,3)*180/pi)
    plot(alpha(start:end,4)*180/pi)
    plot(alpha(start:end,5)*180/pi)
    plot(alpha(start:end,6)*180/pi)
    title('alpha')
    %%
    alphaa=mean(alpha(start:end,:));
    axa=mean(ax(start:end,:));
    aycena=mean(aycen(start:end,:));
    thetaa=mean(theta(start:end,:));
    delta1a=mean(delta1(start:end));
    delta3a=mean(delta3(start:end));
    delta4a=mean(delta4(start:end));
    delta5a=mean(delta5(start:end));
    delta6a=mean(delta6(start:end));
    delta8a=mean(delta8(start:end));
    deltaa=[delta1a,delta3a,delta4a,delta5a,delta6a,delta8a];
    thetaa_rtk=mean([anglecar(start:end,1)-anglecar(start:end,2)...
        anglecar(start:end,2)-anglecar(start:end,3)])*180/pi;
    
end