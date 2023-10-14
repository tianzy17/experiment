%R30v5/v10ready从10开始
%R30v15从524开始
%R30v20ready从41开始
%R20v10ready/v15ready/v20从10开始
clear;
clc;
close all;
start=[10,10,524,41,10,10,10];
file_name = ["Mc1R30v5","Mc1R30v10ready","Mc1R30v15","Mc1R30v20ready",...
    "Mc1R20v10ready","Mc1R20v15ready","Mc1R20v20"];

% axa=zeros(7,3);
% deltaa=zeros(7,6);
% DirectionAccX=[1 1 1;1 1 -1;
%                1 -1 1;1 -1 -1;
%                -1 1 1;-1 1 -1;
%                -1 -1 1;-1 -1 -1;];
% DirectionAccY=[1 1 1;1 1 -1;
%                1 -1 1;1 -1 -1;
%                -1 1 1;-1 1 -1;
%                -1 -1 1;-1 -1 -1;];

alphaa=zeros(7,6);
deltaa=zeros(7,6);
axa=zeros(7,3);
aycena=zeros(7,3);
thetaa=zeros(7,2);
thetaa_rtk=zeros(7,2);
Ftya=zeros(64,6);
%预处理7次数据并记录
for i=1:1:7
    close all
    [alphaa(i,:),axa(i,:),aycena(i,:),thetaa(i,:),deltaa(i,:),thetaa_rtk(i,:)]=...
        PreCalculate(file_name{i},start(i));
end

% thetaa_temp=[thetaa(:,1),thetaa_rtk(:,1),thetaa(:,2),thetaa_rtk(:,2)];
revise = (-2:0.1:2)*pi/180;
figure(1)
for i = 1:1:41
    for j = 1:1:41
        for k = 1:1:41
            anglecar_revise=[revise(i) revise(j) revise(k)];
            PlotAllDirection(alphaa,aycena,axa,thetaa_rtk,deltaa,anglecar_revise);
        end
        % close all;
        %加入进度条
        
        progress = (i*1681+41*j+k)/68921*100;
        % %测试用
        % progress = 999.9999;
        temp = fix(progress);
        integer = num2str(temp);
        decimal = num2str(progress - temp);
        %打印进度
        % progress=vpa(progress,2);
        decimal = decimal(2:4);
        % progress = [num2str(integer)];
        progress=[integer,decimal,'%']
    end
    % %加入进度条
    % progress=(i+41*j+1681)/68921;
    % %打印进度
    % progress=vpa(progress,2);
    % progress=[num2str(progress),'%']
end


% [Flag]=JudgeAll(alphaa,aycena,axa,thetaa,deltaa);
PlotAllDirection(alphaa,aycena,axa,thetaa,deltaa);

close all;


