% close all;
% clear
% load('data.mat');

lW = 2.5;
boundL_final.max = zeros(length(body_pt),1);
boundL_final.x = zeros(length(body_pt),1);
boundL_final.y = zeros(length(body_pt),1);
boundL_final.j = zeros(length(body_pt),1);
boundL_final.cab_id = zeros(length(body_pt),1);

boundR_final.max = zeros(length(body_pt),1);
boundR_final.x = zeros(length(body_pt),1);
boundR_final.y = zeros(length(body_pt),1);
boundR_final.j = zeros(length(body_pt),1);
boundR_final.cab_id = zeros(length(body_pt),1);

for index_i = 1:length(body_pt)
    boundL.x = 0;
    boundL.y = 0;
    boundL.j = 0;
    boundL.cab_id = 0;
    boundL.max = 0;
    boundR.x = 0;
    boundR.y = 0;
    boundR.j = 0;
    boundR.cab_id = 0;
    boundR.max = 0;   
    
    
    
    
    k = 1;
    x_mid = body_pt(index_i,1) - cos(body_pt(index_i,5))*ext(1);
    y_mid = body_pt(index_i,2) - sin(body_pt(index_i,5))*ext(1);
    l1.x1 = x_mid + lW/2*sin(body_pt(index_i,16));
    l1.y1 = y_mid - lW/2*cos(body_pt(index_i,16));
    l1.x2 = x_mid - lW/2*sin(body_pt(index_i,16));
    l1.y2 = y_mid + lW/2*cos(body_pt(index_i,16));
    for j = 1:length(body_pt)
        for k = 1:3
            l2.x1 = body_pt(j,k*5-4) - lW/2*sin(body_pt(j,k*5));
            l2.y1 = body_pt(j,k*5-3) + lW/2*cos(body_pt(j,k*5));
            l2.x2 = body_pt(j,k*5-2) - lW/2*sin(body_pt(j,k*5));
            l2.y2 = body_pt(j,k*5-1) + lW/2*cos(body_pt(j,k*5));
            l3.x1 = body_pt(j,k*5-4) + lW/2*sin(body_pt(j,k*5));
            l3.y1 = body_pt(j,k*5-3) - lW/2*cos(body_pt(j,k*5));
            l3.x2 = body_pt(j,k*5-2) + lW/2*sin(body_pt(j,k*5));
            l3.y2 = body_pt(j,k*5-1) - lW/2*cos(body_pt(j,k*5));
            
            crs_rst = line_crs(l1,l3);
            if crs_rst.flag ==1
                if abs(crs_rst.x-x_mid)<3 && abs(crs_rst.y-y_mid)<3
                    boundL_temp = ((crs_rst.x - x_mid)^2 + (crs_rst.y - y_mid)^2)^0.5;
                    if boundL_temp > boundL.max
                        boundL.max = boundL_temp;
                        boundL.x = crs_rst.x;
                        boundL.y = crs_rst.y;
                        boundL.j = j;
                        boundL.cab_id = k;
                    end
                end
            end
            
            crs_rst = line_crs(l1,l2);
            if crs_rst.flag ==1
                if abs(crs_rst.x-x_mid)<3 && abs(crs_rst.y-y_mid)<3
                    boundR_temp = ((crs_rst.x - x_mid)^2 + (crs_rst.y - y_mid)^2)^0.5;
                    if boundR_temp > boundR.max
                        boundR.max = boundR_temp;
                        boundR.x = crs_rst.x;
                        boundR.y = crs_rst.y;
                        boundR.j = j;
                        boundR.cab_id = k;
                    end
                end
            end
        end
    end
    boundL_final.max(index_i) = boundL.max;
    boundL_final.x(index_i) = boundL.x;
    boundL_final.y(index_i) = boundL.y;
    boundL_final.j(index_i) = boundL.j;
    boundL_final.cab_id(index_i) = boundL.cab_id;
    
    boundR_final.max(index_i) = boundR.max;

    boundR_final.x(index_i) = boundR.x;
    boundR_final.y(index_i) = boundR.y;
    boundR_final.j(index_i) = boundR.j;
    boundR_final.cab_id(index_i) = boundR.cab_id;
end
num = 0;
mag_slct = zeros(length(body_pt),6);
mag_time = 1:length(body_pt);
mag_time = mag_time/(1000/5/20/rec_step);
for k=1:rec_step: length(pos)-1     % 14100
    if (skippt(k, 5) == 1)
        num = num + 1;
        mag_slct(num,1) = smooth(mag.dev1(k)/1000);
        mag_slct(num,2) = smooth(mag.dev2(k)/1000);
        mag_slct(num,3) = smooth(mag.dev3(k)/1000);
        mag_slct(num,4) = smooth(mag.dev4(k)/1000);
        mag_slct(num,5) = smooth(mag.dev5(k)/1000);
        mag_slct(num,6) = smooth(mag.dev6(k)/1000);
    end
end
bound_total_max = boundR_final.max + boundL_final.max;
veh_limit = figure(102);
veh_limit.Position = [100 1 1400 700];
plot(mag_time,smooth(boundL_final.max),'k--', 'linewidth', 1.5);
hold on 
plot(mag_time,smooth(boundR_final.max),'k:', 'linewidth', 1.5);
plot(mag_time,smooth(bound_total_max),'k', 'linewidth', 1.5);
% plot(mag_time,mag_slct(:,1),'r:', 'linewidth', 1.5);
% plot(mag_time,mag_slct(:,2),'r--', 'linewidth', 1.5);
% % plot(mag(:,3));
% % plot(mag(:,4));
% plot(mag_time,mag_slct(:,5),'b:', 'linewidth', 1.5);
% plot(mag_time,mag_slct(:,6),'b--', 'linewidth', 1.5);
% plot(mag_time,error(:,1)*10,'m', 'linewidth', 1.5);
% plot(mag_time,error(:,2)*10,'m--', 'linewidth', 1.5);
% plot(mag_time,error(:,3)*10,'m:', 'linewidth', 1.5);
xlabel('时间/秒');
ylabel('限界宽度/米');
legend('左侧限界','右侧限界','总限界');
% legend('左侧限界','右侧限界','总限界','磁Bar1','磁Bar2','磁Bar5','磁Bar6','控制点2偏差*10','控制点3偏差*10','控制点4偏差*10');
title({file_name ; strcat('转向系数-' , num2str(ctr_ratio)) ; '车辆限界'}); 
set(gca,'ytick',[1:0.2:4.4]);
axis([-inf,inf,1,4.4])
grid on;
saveas(gcf,[ddir , file_name , '-转向系数[' , num2str(ctr_ratio) , ']-车辆限界' , '.jpg']);

time_step = 0:0.01*pi:pi/2; 
for fig_num = 1001:1004
    veh_spec = figure(fig_num);
    veh_spec.Position = [100 1 750 650];
    plot(pos(TRJ,1), pos(TRJ, 2), 'b:', 'linewidth', 1.5);
    hold on;
    plot(bnd(:, 1), bnd(:, 2), 'k:', 'linewidth', 1.5);
    plot(bnd(:, 3), bnd(:, 4), 'k:', 'linewidth', 1.5);
    plot(boundL_final.x,boundL_final.y,'m:','linewidth', 1.5);
    plot(boundR_final.x,boundR_final.y,'m:','linewidth', 1.5);
    [maxF,indexF] = max(bound_total_max);
    [maxL,indexL] = max(boundL_final.max);
    [maxR,indexR] = max(boundR_final.max);
    s1 = text(boundL_final.x(indexF), boundL_final.y(indexF), ...
            ['左限界',':',num2str(boundL_final.max(indexF),'%.2f'),'米'], ...
            'FontSize', 10);
    s2 = text(boundR_final.x(indexF), boundR_final.y(indexF), ...
            ['右限界',':',num2str(boundR_final.max(indexF),'%.2f'),'米'], ...
            'FontSize', 10);
    lx = [boundL_final.x(indexF) , boundR_final.x(indexF) , boundL_final.x(indexL) , boundR_final.x(indexR)];
    ly = [boundL_final.y(indexF) , boundR_final.y(indexF) , boundL_final.y(indexL) , boundR_final.y(indexR)];

    switch fig_num
        case 1001
            k = (boundR_final.j(indexF)+10) * rec_step; 
            s3 = plot(lx(1:2) , ly(1:2), 'or', 'MarkerSize', 48/5);
            axis([boundL_final.x(indexF)-30,boundL_final.x(indexF)+30, ...
                boundL_final.y(indexF)-30, boundL_final.y(indexF)+30]);
        case 1002
            k = (boundL_final.j(indexF)+10) * rec_step; 
            s3 = plot(lx(1:2) , ly(1:2), 'or', 'MarkerSize', 48/5);
            axis([boundL_final.x(indexF)-30,boundL_final.x(indexF)+30, ...
                boundL_final.y(indexF)-30, boundL_final.y(indexF)+30]);
        case 1003
            k = (boundL_final.j(indexL)+10) * rec_step; 
            delete(s1);delete(s2);
            s3 = plot(lx(3) , ly(3), 'or', 'MarkerSize', 48/5);
            s4 = text(boundL_final.x(indexL), boundL_final.y(indexL), ...
            ['左限界',':',num2str(boundL_final.max(indexL),'%.2f'),'米'], ...
            'FontSize', 10);
            axis([boundL_final.x(indexL)-30,boundL_final.x(indexL)+30, ...
                boundL_final.y(indexL)-30, boundL_final.y(indexL)+30]);
        case 1004 
            delete(s1);delete(s2);
            k = (boundR_final.j(indexR)+10) * rec_step;   
            s3 = plot(lx(4) , ly(4), 'or', 'MarkerSize', 48/5);
            s4 = text(boundR_final.x(indexR), boundR_final.y(indexR), ...
            ['右限界',':',num2str(boundR_final.max(indexR),'%.2f'),'米'], ...
            'FontSize', 10);
            axis([boundR_final.x(indexR)-30,boundR_final.x(indexR)+30, ...
                boundR_final.y(indexR)-30, boundR_final.y(indexR)+30]);
    end
    lx = [pos(k,1), pos(k,3), pos(k,5), pos(k,7)];
    ly = [pos(k,2), pos(k,4), pos(k,6), pos(k,8)];
    vangle = atan2(ly(2:4)-ly(1:3), lx(2:4)-lx(1:3));
    ext = [-2.1, -0.2, 1.0, -1.0, 0.2, 2.1];
    lW = 2.5; %车身宽度
    clear i;
    for q=1:3
            if q==1
                vx = [pos(k,q*2-1) + cos(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+1) + cos(vangle(q))*ext(q*2)];
                vy = [pos(k,q*2) + sin(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+2) + sin(vangle(q))*ext(q*2)];
                hc(q*6-5) = line(vx - lW/2*sin(vangle(q)), ...
                        vy + lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % left
                hc(q*6-4) = line(vx + lW/2*sin(vangle(q)), ...
                        vy - lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % right
                vxx = [vx(1) + (lW/2-0.65)*sin(vangle(q)) - 0.65*cos(vangle(q)), ...
                        vx(1) - (lW/2-0.65)*sin(vangle(q))- 0.65*cos(vangle(q))];
                vyy = [vy(1) - (lW/2-0.65)*cos(vangle(q)) - 0.65*sin(vangle(q)), ...
                        vy(1) + (lW/2-0.65)*cos(vangle(q))- 0.65*sin(vangle(q))];            
                hc(q*6-3) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                vxx = [vx(2) + lW/2*sin(vangle(q)), vx(2) - lW/2*sin(vangle(q))];
                vyy = [vy(2) - lW/2*cos(vangle(q)), vy(2) + lW/2*cos(vangle(q))];
                hc(q*6-2) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                z = vx(1) - (lW/2 - 0.65)*sin(vangle(q)) + 0.65*cos(time_step + vangle(q) + pi/2) + ...
                        i*(vy(1) + (lW/2 - 0.65)*cos(vangle(q)) + 0.65*sin(time_step + vangle(q) + pi/2));
                hc(q*6-1) = polar(angle(z),abs(z), 'r');  
                hc(q*6-1).LineWidth = 1.5;
                z = vx(1) + (lW/2 - 0.65)*sin(vangle(q)) + 0.65*cos(time_step + vangle(q) + pi) + ...
                        i*(vy(1) - (lW/2 - 0.65)*cos(vangle(q)) + 0.65*sin(time_step + vangle(q) + pi));
                hc(q*6) = polar(angle(z),abs(z), 'r'); 
                hc(q*6).LineWidth = 1.5;
                hc(q*6-5).Color = 'r';
                hc(q*6-4).Color = 'r';
                hc(q*6-3).Color = 'r';
                hc(q*6-2).Color = 'r';
            end
            if q==2
                vx = [pos(k,q*2-1) + cos(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+1) + cos(vangle(q))*ext(q*2)];
                vy = [pos(k,q*2) + sin(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+2) + sin(vangle(q))*ext(q*2)];
                hc(q*6-5) = line(vx - lW/2*sin(vangle(q)), vy + lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % 2.5m width
                hc(q*6-4) = line(vx + lW/2*sin(vangle(q)), vy - lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % 2.5m width
                vxx = [vx(1) + lW/2*sin(vangle(q)), vx(1) - lW/2*sin(vangle(q))];
                vyy = [vy(1) - lW/2*cos(vangle(q)), vy(1) + lW/2*cos(vangle(q))];            
                hc(q*6-3) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                vxx = [vx(2) + lW/2*sin(vangle(q)), vx(2) - lW/2*sin(vangle(q))];
                vyy = [vy(2) - lW/2*cos(vangle(q)), vy(2) + lW/2*cos(vangle(q))];
                hc(q*6-2) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                hc(q*6-5).Color = 'r';
                hc(q*6-4).Color = 'r';
                hc(q*6-3).Color = 'r';
                hc(q*6-2).Color = 'r';
            end
            if q==3
                vx = [pos(k,q*2-1) + cos(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+1) + cos(vangle(q))*ext(q*2)];
                vy = [pos(k,q*2) + sin(vangle(q))*ext(q*2-1), ...
                        pos(k,q*2+2) + sin(vangle(q))*ext(q*2)];
                hc(q*6-5) = line(vx - lW/2*sin(vangle(q)), ...
                        vy + lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % left              
                hc(q*6-4) = line(vx + lW/2*sin(vangle(q)), ...
                        vy - lW/2*cos(vangle(q)), 'LineWidth', 1.5);       % right
                vxx = [vx(1) + lW/2*sin(vangle(q)), vx(1) - lW/2*sin(vangle(q))];
                vyy = [vy(1) - lW/2*cos(vangle(q)), vy(1) + lW/2*cos(vangle(q))];
                hc(q*6-3) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                vxx = [vx(2) + (lW/2-0.65)*sin(vangle(q)) + 0.65*cos(vangle(q)), ...
                        vx(2) - (lW/2-0.65)*sin(vangle(q))+ 0.65*cos(vangle(q))];
                vyy = [vy(2) - (lW/2-0.65)*cos(vangle(q)) + 0.65*sin(vangle(q)), ...
                        vy(2) + (lW/2-0.65)*cos(vangle(q))+ 0.65*sin(vangle(q))];    
                hc(q*6-2) = line(vxx, vyy, 'LineWidth', 1.5);       % 2.5m width
                z = vx(2) - (lW/2 - 0.65)*sin(vangle(q)) + 0.65*cos(time_step + vangle(q)) + ...
                        i*(vy(2) + (lW/2 - 0.65)*cos(vangle(q)) + 0.65*sin(time_step + vangle(q)));
                hc(q*6-1) = polar(angle(z),abs(z), 'r');  
                hc(q*6-1).LineWidth = 1.5;
                z = vx(2) + (lW/2 - 0.65)*sin(vangle(q)) + 0.65*cos(time_step + vangle(q)-pi/2) + ...
                        i*(vy(2) - (lW/2 - 0.65)*cos(vangle(q)) + 0.65*sin(time_step + vangle(q)-pi/2));
                hc(q*6) = polar(angle(z),abs(z), 'r');  
                hc(q*6).LineWidth = 1.5;
                hc(q*6-5).Color = 'r';
                hc(q*6-4).Color = 'r';
                hc(q*6-3).Color = 'r';
                hc(q*6-2).Color = 'r';
            end
        end

        u = [3,3,5,5]; v = [4,4,6,6]; n = [1,2,2,3]; x = [2,2,3,3];
        cnx = zeros(2,4); cny = zeros(2,4); 
        for q=1:4
            cnx(1,q) = pos(k,u(q)) + cos(vangle(n(q)))*ext(q+1) + sin(vangle(n(q)))*lW/2;
            cny(1,q) = pos(k,v(q)) + sin(vangle(n(q)))*ext(q+1) - cos(vangle(n(q)))*lW/2;
            cnx(2,q) = pos(k,u(q)) + cos(vangle(n(q)))*ext(q+1) - sin(vangle(n(q)))*lW/2;
            cny(2,q) = pos(k,v(q)) + sin(vangle(n(q)))*ext(q+1) + cos(vangle(n(q)))*lW/2;
        end

        nJ = 4;
        for q=1:nJ-1
            vx = [cnx(1,1)*(1-q/nJ)+cnx(1,2)*(q/nJ), cnx(2,1)*(1-q/nJ)+cnx(2,2)*(q/nJ)];
            vy = [cny(1,1)*(1-q/nJ)+cny(1,2)*(q/nJ), cny(2,1)*(1-q/nJ)+cny(2,2)*(q/nJ)];

            hc(18+q) = line(vx, vy, 'LineWidth', 1.5);

            vx = [cnx(1,3)*(1-q/nJ)+cnx(1,4)*(q/nJ), cnx(2,3)*(1-q/nJ)+cnx(2,4)*(q/nJ)];
            vy = [cny(1,3)*(1-q/nJ)+cny(1,4)*(q/nJ), cny(2,3)*(1-q/nJ)+cny(2,4)*(q/nJ)];

            hc(18+nJ-1+q) = line(vx, vy,  'LineWidth', 1.5);
            hc(18+q).Color = 'r';
            hc(18+nJ-1+q).Color = 'r';
        end
    % [max2,index2] = max(bound_total_max(200:length(bound_total_max)));
    % s1 = text(boundL_final.x(index2), boundL_final.y(index2), ...
    %         ['左限界',':',num2str(boundL_final.max(index2),'%.2f'),'米'], ...
    %         'FontSize', 10);
    % s2 = text(boundR_final.x(index2), boundR_final.y(index2), ...
    %         ['右限界',':',num2str(boundR_final.max(index2),'%.2f'),'米'], ...
    %         'FontSize', 10);
    % lx = [boundL_final.x(index2) , boundR_final.x(index2)];
    % ly = [boundL_final.y(index2) , boundR_final.y(index2)];
    % s3 = plot(lx , ly, 'o', 'MarkerSize', 48/5);
    % axis([boundL_final.x(index2)-30,boundL_final.x(index2)+30, boundL_final.y(index2)-30, boundL_final.y(index2)+30]);
            xlabel('大地坐标系东西方向/米');
            ylabel('大地坐标系南北方向/米');
            legend('1轴轨迹','左侧车道','右侧车道','左侧限界','右侧限界');
    switch fig_num
        case 1001
            title({file_name ; strcat('转向系数-' , num2str(ctr_ratio)) ; '最大限界处车辆左侧极限位置示意图'}); 
            saveas(gcf,[ddir , file_name , '-转向系数[' , num2str(ctr_ratio) ,...
                ']-车辆最大限界处左侧位置示意图' , '.jpg']);
        case 1002
       
            title({file_name ; strcat('转向系数-' , num2str(ctr_ratio)) ; '最大限界处车辆右侧极限位置示意图'});
            saveas(gcf,[ddir , file_name , '-转向系数[' , num2str(ctr_ratio) ,...
                ']-车辆最大限界处右侧位置示意图' , '.jpg']);
        case 1003
            title({file_name ; strcat('转向系数-' , num2str(ctr_ratio)) ; '左侧最大限界位置示意图'});
            saveas(gcf,[ddir , file_name , '-转向系数[' , num2str(ctr_ratio) ,...
                ']-左侧最大限界位置示意图' , '.jpg']);
        case 1004
            title({file_name ; strcat('转向系数-' , num2str(ctr_ratio)) ; '右侧最大限界位置示意图'});
            saveas(gcf,[ddir , file_name ,'-转向系数[' , num2str(ctr_ratio) ,...
                ']-右侧最大限界位置示意图' , '.jpg']);
    end
    grid on
end


function pt = line_crs(line1, line2)
    k1 = (line1.y1 - line1.y2)/(line1.x1 - line1.x2);
    b1 = line1.y1 - k1*line1.x1;
    k2 = (line2.y1 - line2.y2)/(line2.x1 - line2.x2);
    b2 = line2.y1 - k2*line2.x1;
    pt.x = -(b1 - b2)/(k1 - k2);
    pt.y = -(-b2*k1 + b1*k2)/(k1 - k2);
%       min(line1.x1,line1.x2)<=pt.x && pt.x<=max(line1.x1,line1.x2) && ...
%         min(line1.y1,line1.y2)<=pt.y && pt.y<=max(line1.y1,line1.y2)   
    if  min(line2.x1,line2.x2)<=pt.x && pt.x<=max(line2.x1,line2.x2) && ...
        min(line2.y1,line2.y2)<=pt.y && pt.y<=max(line2.y1,line2.y2)
        pt.flag = 1;
    else 
        pt.flag = 2;
    end
end