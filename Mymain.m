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
Ftya=zeros(64,6);
for i=1:1:7
    close all
    [alphaa(i,:),axa(i,:),aycena(i,:),thetaa(i,:),deltaa(i,:)]=...
        PreCalculate(file_name{i},start(i));
end
save main4.mat

Flag=JudgeAll(alphaa,aycena,axa,thetaa,deltaa);
PlotAllDirection(alphaa,aycena,axa,thetaa,deltaa);

close all;


