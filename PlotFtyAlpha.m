function []=PlotFtyAlpha(Fty,Alpha,R)
%如果正确，Flag返回0，否则返回错误的点的数量
    [row,col]=size(Fty);
    % FlagFty=zeros(4,6);%如果正确，Flag返回0，否则返回错误的点的数量
    % FlagAlpha=zeros(4,6);
    % for i=1:1:col
    %     for j=2:1:4
    %         if abs(Fty(j,i))>abs(Fty(1,i))
    %             FlagFty(j,i)=1;
    %         end
    %         if abs(Alpha(j,i))>abs(Alpha(1,i))
    %             FlagAlpha(j,i)=1;
    %         end
    %     end
    % end
    % Flag=xor(FlagFty,FlagAlpha);
%画图
    Alpha=Alpha*180/pi;
    for i=1:1:col
        subplot(2,3,i);
        hold on
%       Target=[line line line];
%       plot(alpha(1:4,i),F(1:4,i));
      if R==30
        plot(Alpha(1:4,i),Fty(1:4,i),'o-');
      elseif R==20
        plot(Alpha(5:7,i),Fty(5:7,i),'o-');
      end
      title(['第',num2str(i),'轴']);
      set(gca,'YDir','reverse');
      xlabel('侧偏角(°)')
      ylabel('侧偏力(N)')
    end
    % FlagAlpha
    % FlagFty
end