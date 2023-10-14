% syms a b x y
% f=sqrt((a*cos(b)+x)^2+(a*sin(b)+y)^2);
% diff(f,1,b)
% 
% -(2*a*sin(b)*(x + a*cos(b)) - 2*a*cos(b)*(y + a*sin(b)))/(2*((x + a*cos(b))^2 + (y + a*sin(b))^2)^(1/2))

% figure(1)
% T=out.trajectory.Data;
% plot(out.trajectory.Data(:,1),out.trajectory.Data(:,2))
% hold on
% grid on
% axis equal
% plot(out.trajectory.Data(:,3),out.trajectory.Data(:,4))
% plot(out.trajectory.Data(:,9),out.trajectory.Data(:,10))
% [m n]=size(T);
% for i=1:floor(m/10):m
%     plot(T(i,[1 3 9]),T(i,[2 4 10]),'o-')
%     plot(T(i,11),T(i,12),'*')
% end

file_name = 'tttdayuan15-1';
data = readtable([file_name, '.csv']); 
[row,col]=size(data);
n=fix(row/5);
PositionAxle1=zeros(n,2);
PositionAxle2=zeros(n,2);
PositionAxle3=zeros(n,2);
PositionAxle4=zeros(n,2);


for i=1:1:n
    PositionAxle1(i,:)=[data.rtk1_lon(5*i-4)-data.rtk1_lon(1) data.rtk1_lat(5*i-4)-data.rtk1_lat(1)];
    PositionAxle2(i,:)=[data.rtk2_lon(5*i-4)-data.rtk1_lon(1) data.rtk2_lat(5*i-4)-data.rtk1_lat(1)];
    PositionAxle3(i,:)=[data.rtk3_lon(5*i-4)-data.rtk1_lon(1) data.rtk3_lat(5*i-4)-data.rtk1_lat(1)];
    PositionAxle4(i,:)=[data.rtk4_lon(5*i-4)-data.rtk1_lon(1) data.rtk4_lat(5*i-4)-data.rtk1_lat(1)];
end

figure(1)
plot(PositionAxle1(:,1),PositionAxle1(:,2))
hold on
plot(PositionAxle2(:,1),PositionAxle2(:,2))
plot(PositionAxle3(:,1),PositionAxle3(:,2))
plot(PositionAxle4(:,1),PositionAxle4(:,2))

axis equal

DistanceAxle1_Axle2=sqrt((PositionAxle1(:,1)-PositionAxle2(:,1)).^2 ...
    +(PositionAxle1(:,2)-PositionAxle2(:,2)).^2);
DistanceAxle2_Axle3=sqrt((PositionAxle2(:,1)-PositionAxle4(:,1)).^2 ...
    +(PositionAxle2(:,2)-PositionAxle4(:,2)).^2);
DistanceAxle3_Axle4=sqrt((PositionAxle3(:,1)-PositionAxle4(:,1)).^2 ...
    +(PositionAxle3(:,2)-PositionAxle4(:,2)).^2);

figure(2)
hold on
for i=1:floor(n/5):n
    
    plot([PositionAxle1(i,1),PositionAxle2(i,1)],[PositionAxle1(i,2),PositionAxle2(i,2)],'b','LineWidth',1)
    plot([PositionAxle2(i,1),PositionAxle4(i,1)],[PositionAxle2(i,2),PositionAxle4(i,2)],'y','LineWidth',1)
    plot([PositionAxle3(i,1),PositionAxle4(i,1)],[PositionAxle3(i,2),PositionAxle4(i,2)],'k','LineWidth',1)
    axis equal

end