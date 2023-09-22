function [Flag,f]=JudgeAll(alphaa,aycena,axa,thetaa,deltaa)
%Flag为64维列向量，每一行表示一个加速度组合
% 如果对应组合正确，Flag当前元素返回0，否则返回错误的点的数量
    DirectionAccX=[1 1 1;1 1 -1;
                   1 -1 1;1 -1 -1;
                   -1 1 1;-1 1 -1;
                   -1 -1 1;-1 -1 -1;];
    DirectionAccY=[1 1 1;1 1 -1;
                   1 -1 1;1 -1 -1;
                   -1 1 1;-1 1 -1;
                   -1 -1 1;-1 -1 -1;];
    Flag=zeros(64,1);
    f=zeros(64,1);
    for i=1:1:8 %ax方向
        for j=1:1:8 %ay方向
            [Ftya,result]=SolveFtya(DirectionAccX(i,:),DirectionAccY(j,:),aycena,axa,thetaa,deltaa,alphaa);
            order=i*8+j-8;
            temp=Judge(Ftya,alphaa);
            Flag(order)=sum(temp(:));
            f(order)=result(33,2);
        end
    end
end