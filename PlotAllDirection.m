function []=PlotAllDirection(alphaa,aycena,axa,thetaa,deltaa)
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
    % Flag=zeros(64,1);
    % for i=1:1:8 %ax方向
    %     for j=1:1:8 %ay方向
    %         Ftya=SolveFtya(DirectionAccX(i,:),DirectionAccY(j,:),aycena,axa,thetaa,deltaa,alphaa);
    %         R=30;
    %         order=i*8+j-8;
    %         temp=PlotFtyAlpha(Ftya,alphaa,R);
    %         Flag(order)=sum(temp(:));
    %     end
    % end

    for i=1:1:8 %ax方向
        for j=1:1:8 %ay方向
            Ftya=SolveFtya(DirectionAccX(i,:),DirectionAccY(j,:),aycena,axa,thetaa,deltaa,alphaa);
            order=8*(i-1)+j;
            figure(order)
            hold on
            R=30;
            PlotFtyAlpha(Ftya,alphaa,R)
            saveas(gcf,[pwd,'\AllFigure\AllR\','R30_',...
                num2str(order),'.png'])
            figure(8*(i-1)+j+64)
            R=20;
            PlotFtyAlpha(Ftya,alphaa,R)
            saveas(gcf,[pwd,'\AllFigure\AllR\','R20_',...
                num2str(order),'.png'])
        end
    end
end