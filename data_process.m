clc;clear;
close all
ddir = 'data0425/';
file_name = 'R25-沪城环路-临港大道';;
head_conv = 1;
rtk_all = readtable([ddir,file_name, '.csv']);    

rtk1.Var5 = rtk_all.rtk1_timestamp(1:5:end);
rtk2.Var5 = rtk_all.rtk2_timestamp(1:5:end);
rtk3.Var5 = rtk_all.rtk3_timestamp(1:5:end);
rtk4.Var5 = rtk_all.rtk4_timestamp(1:5:end);

rtk1.Var9 = rtk_all.rtk1_lat(1:5:end);
rtk2.Var9 = rtk_all.rtk2_lat(1:5:end);
rtk3.Var9 = rtk_all.rtk3_lat(1:5:end);
rtk4.Var9 = rtk_all.rtk4_lat(1:5:end);

rtk1.Var7 = rtk_all.rtk1_lon(1:5:end);
rtk2.Var7 = rtk_all.rtk2_lon(1:5:end);
rtk3.Var7 = rtk_all.rtk3_lon(1:5:end);
rtk4.Var7 = rtk_all.rtk4_lon(1:5:end);

rtk1.Var11 = rtk_all.rtk1_flag(1:5:end);
rtk2.Var11 = rtk_all.rtk2_flag(1:5:end);
rtk3.Var11 = rtk_all.rtk3_flag(1:5:end);
rtk4.Var11 = rtk_all.rtk4_flag(1:5:end);



x1=rtk1.Var9; 
x2=rtk2.Var9; 
x3=rtk3.Var9; 
x4=rtk4.Var9; 
y1=rtk1.Var7; 
y2=rtk2.Var7; 
y3=rtk3.Var7; 
y4=rtk4.Var7; 
if head_conv == 1
    x4=rtk1.Var9; 
    x3=rtk2.Var9; 
    x2=rtk3.Var9; 
    x1=rtk4.Var9; 
    y4=rtk1.Var7; 
    y3=rtk2.Var7; 
    y2=rtk3.Var7; 
    y1=rtk4.Var7; 
end

matrix_size = size(x1,1);
%坐标零点计算

x=[x1;x2;x3;x4];
y=[y1;y2;y3;y4];
xmin=min(x);ymin=min(y);
x1=x1-min(x)+10;x2=x2-min(x)+10;x3=x3-min(x)+10;x4=x4-min(x)+10;
y1=y1-min(y)+10;y2=y2-min(y)+10;y3=y3-min(y)+10;y4=y4-min(y)+10;

STEP = 10;
for h=1+STEP:length(x1)
    mov(h)= sqrt((x1(h)-x1(h-STEP))^2 + (y1(h)-y1(h-STEP))^2);
end
odo = cumsum(mov) / STEP;

grid on
 for h=1:10:length(x1)
  text(x1(h,1), y1(h,1), num2str(odo(h)));
end




dis=zeros(matrix_size,1);
for i = 1: size(x1,1)-1
dis(i+1)=dis(i)+sqrt((x1(i+1)-x1(i))^2+(y1(i+1)-y1(i))^2);
end

%第二轴偏移量
error=zeros(matrix_size,3);
for i=1:size(x2,1)
    min=100;
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x2(i),y2(i),x1(j),y1(j),x1(j+1),y1(j+1));
      if  min_new<min
        min=min_new;
      end
    end
    error(i,1)=min;
end

%第三轴偏移量
for i=1:size(x3,1)
    min=100;
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x3(i),y3(i),x1(j),y1(j),x1(j+1),y1(j+1));
      if  min_new<min
        min=min_new;
      end
    end
    error(i,2)=min;
end

%第四轴偏移量
for i=1:size(x4,1)
    min=100;
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x4(i),y4(i),x1(j),y1(j),x1(j+1),y1(j+1));
      if  min_new<min
        min=min_new;
      end
    end
    error(i,3)=min;
end

%原图
plot(x1,y1,x2,y2,x3,y3,x4,y4);
legend('控制点1','控制点2','控制点3','控制点4');
xlabel('东西方向/米');
ylabel('南北方向/米');
% set(gca,'xtick',[0:15:700]);
% set(gca,'ytick',[0:10:600]);
grid on
 for h=1:200:length(x1)
  text(x1(h,1), y1(h,1), num2str(odo(h)));
 end
saveas(gcf,[ddir,'车辆轨迹坐标_',file_name,'.jpg']);
%偏移图
figure
plot(dis,error(:,1),dis,error(:,2),dis,error(:,3))
legend('控制点2偏移','控制点3偏移','控制点4偏移');
xlabel('控制点1里程');
ylabel('偏移量/米');
set(gca,'ylim',[0,1]);
set(gca,'ytick',[0:0.1:2.5])
grid on;
saveas(gcf,[ddir,'车辆横向偏移',file_name,'.jpg']);


function d = point_line_dist(lat0, lng0, lat1, lng1, lat2, lng2)
      a = [lat1, lng1, 0] - [lat2, lng2, 0];
      b = [lat0, lng0, 0] - [lat2, lng2, 0];
      d = norm(cross(a,b)) / norm(a) ;
%      d = sqrt((lat0-lat1)^2+(lng0-lng1)^2);
end


