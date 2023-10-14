function []=PlotAllDirection(alphaa,aycena,axa,thetaa_rtk,deltaa,anglecar_revise)
    arguments
        alphaa (7,6) double %7次数据各自的平均侧偏角
        aycena (7,3) double %7次数据各自的平均侧向加速度
        axa (7,3) double %7次数据各自的平均纵向加速度
        thetaa_rtk (7,2) double %7次数据各自的平均车间夹角,用rtk版方便修正
        deltaa (7,6) double %7次数据各自的平均转向角
        anglecar_revise (1,3) double %车间夹角修正量
    end
    for i=1:6
        alphaa(:,i) = alphaa(:,i) + anglecar_revise(ceil(i/2));
    end
    thetaa = thetaa_rtk + [anglecar_revise(1)-anglecar_revise(2) anglecar_revise(2)-anglecar_revise(3)];

    [Ftya,result]=SolveFtya(aycena,axa,thetaa,deltaa,alphaa);

    anglecar_revise=anglecar_revise*180/pi;
    %将anglecar_revise转成char类型,并加入"_"以隔断,前方加入"R30_"以标记工况
    %后方加入"deg.png"以声明单位及文件保存类型
    anglecar_revise=['R30_' num2str(anglecar_revise(1)) '_' num2str(anglecar_revise(2)) ...
        '_' num2str(anglecar_revise(3)) 'deg.png'];
    %把负号"-"改为"m",代表minus
    anglecar_revise=strrep(anglecar_revise,'-','m');
    %定义空白cahr，方便对anglecar_revise中的空白符进行替换
    % temp_blank = char(32);
    % anglecar_revise=strrep(anglecar_revise,temp_blank,'_');
    
    %清楚当前figure的内容,修改figure的name
    clf;
    % set(gcf,'name',anglecar_revise)
    
    hold on
    R=30;
    PlotFtyAlpha(Ftya,alphaa,R)
    %暂存文件名
    % temp=['R30_修正_',anglecar_revise,'度.png'];
    
    saveas(gcf,[pwd,'\AllFigure\anglecar_revise\',anglecar_revise])
%     figure('name',['R30:','修正anglecar_revise(1)/anglecar_revise(2)/anglecar_revise(3):',...
%         num2str(anglecar_revise(1)),'/',num2str(anglecar_revise(2)),'/',num2str(anglecar_revise(3)),'/度']);
%     R=20;
%     PlotFtyAlpha(Ftya,alphaa,R)
%     saveas(gcf,[pwd,'\AllFigure\','R30:','修正anglecar_revise(1)/anglecar_revise(2)/anglecar_revise(3):',...
%         num2str(anglecar_revise(1)),'/',num2str(anglecar_revise(2)),'/',num2str(anglecar_revise(3)),'/度.png'])
end