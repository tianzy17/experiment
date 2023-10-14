function [Flag]=JudgeAll(alphaa,aycena,axa,thetaa,deltaa)
%Flag为64维列向量，每一行表示一个加速度组合
% 如果对应组合正确，Flag当前元素返回0，否则返回错误的点的数量
%     DirectionAccX=[1 1 1;1 1 -1;
%                    1 -1 1;1 -1 -1;
%                    -1 1 1;-1 1 -1;
%                    -1 -1 1;-1 -1 -1;];
%     DirectionAccY=[1 1 1;1 1 -1;
%                    1 -1 1;1 -1 -1;
%                    -1 1 1;-1 1 -1;
%                    -1 -1 1;-1 -1 -1;];

    [Ftya,result]=SolveFtya(aycena,axa,thetaa,deltaa,alphaa);
    Flag=Judge(Ftya,alphaa);
end