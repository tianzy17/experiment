%对求解器解算数据进行侧偏刚度拟合，先去除离群点拟合，再按离直线一定距离拟合
neighbor=zeros((row-1),6);
Boundary=[0.35 0.35 0.35 0.35 0.35 0.35];
vaild=zeros(1,6);
for t=1:1:6
    for i=start:1:(row-1)%与求解方程保持一致
        for j=start:1:(row-1)
            if sqrt(((Fty(i,t)-Fty(j,t))/1e4)^2+((alpha(i,t)-alpha(j,t))*1e2)^2)<Boundary(t)
                neighbor(i,t)=neighbor(i,t)+1;
            end
        end
    end
end
neighbor_box=[200 200 200 200 200 200];
for t=1:1:6
    for i=start:1:(row-1)%与求解方程保持一致
        if neighbor(i,t)>neighbor_box(t)
            vaild(t)=vaild(t)+1;
        end
    end
end

%%
new_alpha1=zeros(1,vaild(1));
new_Fty1=zeros(1,vaild(1));
order=1;
for i=start:1:(row-1)
    if neighbor(i,1)>200
        new_alpha1(order)=alpha(i,1);
        new_Fty1(order)=Fty(i,1);
        order=order+1;
    end
end
figure(8)
hold on
plot(alpha(:,1),Fty(:,1),'*')
% plot(new_alpha1,new_Fty1,'o')

p1=polyfit(new_alpha1*10,new_Fty1/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,1)*10*p1(1)+p1(2)-Fty(i,1)/100)/sqrt(p1(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty1=zeros(1,vaild0);
new1_alpha1=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,1)*10*p1(1)+p1(2)-Fty(i,1)/100)/sqrt(p1(1)^2+1)<0.035
        new1_alpha1(order)=alpha(i,1);
        new1_Fty1(order)=Fty(i,1);
        order=order+1;
    end
end
p1=polyfit(new1_alpha1,new1_Fty1,1);
plot(new1_alpha1,new1_Fty1,'o')
alphaX=-0.06:0.001:0.02;
Fty1=alphaX*p1(1)+p1(2);
figure(8)
hold on
plot(alphaX,Fty1)

%%
new_alpha2=zeros(1,vaild(2));
new_Fty2=zeros(1,vaild(2));
order=1;
for i=start:1:(row-1)
    if neighbor(i,2)>200
        new_alpha2(order)=alpha(i,2);
        new_Fty2(order)=Fty(i,2);
        order=order+1;
    end
end
figure(9)
hold on
plot(alpha(:,2),Fty(:,2),'*')
% plot(new_alpha2,new_Fty2,'o')
p2=polyfit(new_alpha2*10,new_Fty2/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,2)*10*p2(1)+p2(2)-Fty(i,2)/100)/sqrt(p2(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty2=zeros(1,vaild0);
new1_alpha2=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,2)*10*p2(1)+p2(2)-Fty(i,2)/100)/sqrt(p2(1)^2+1)<0.035
        new1_alpha2(order)=alpha(i,2);
        new1_Fty2(order)=Fty(i,2);
        order=order+1;
    end
end
p2=polyfit(new1_alpha2,new1_Fty2,1);
plot(new1_alpha2,new1_Fty2,'o')

alphaX=-0.06:0.001:0.02;
Fty2=alphaX*p2(1)+p2(2);
figure(9)
hold on
plot(alphaX,Fty2)
%%
new_alpha3=zeros(1,vaild(3));
new_Fty3=zeros(1,vaild(3));
order=1;
for i=start:1:(row-1)
    if neighbor(i,3)>200
        new_alpha3(order)=alpha(i,3);
        new_Fty3(order)=Fty(i,3);
        order=order+1;
    end
end
figure(10)
hold on
plot(alpha(:,3),Fty(:,3),'*')
% plot(new_alpha3,new_Fty3,'o')
% 
% p3=polyfit(new_alpha3,new_Fty3,1);
p3=polyfit(new_alpha3*10,new_Fty3/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,3)*10*p3(1)+p3(2)-Fty(i,3)/100)/sqrt(p3(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty3=zeros(1,vaild0);
new1_alpha3=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,3)*10*p3(1)+p3(2)-Fty(i,3)/100)/sqrt(p3(1)^2+1)<0.035
        new1_alpha3(order)=alpha(i,3);
        new1_Fty3(order)=Fty(i,3);
        order=order+1;
    end
end
p3=polyfit(new1_alpha3,new1_Fty3,1);
plot(new1_alpha3,new1_Fty3,'o')
alphaX=-0.06:0.001:0.02;
Fty3=alphaX*p3(1)+p3(2);
figure(10)
hold on
plot(alphaX,Fty3)
%%
new_alpha4=zeros(1,vaild(4));
new_Fty4=zeros(1,vaild(4));
order=1;
for i=start:1:(row-1)
    if neighbor(i,4)>200
        new_alpha4(order)=alpha(i,4);
        new_Fty4(order)=Fty(i,4);
        order=order+1;
    end
end
figure(11)
hold on
plot(alpha(:,4),Fty(:,4),'*')
% plot(new_alpha4,new_Fty4,'o')
% 
% p4=polyfit(new_alpha4,new_Fty4,1);
p4=polyfit(new_alpha4*10,new_Fty4/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,4)*10*p4(1)+p4(2)-Fty(i,4)/100)/sqrt(p4(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty4=zeros(1,vaild0);
new1_alpha4=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,4)*10*p4(1)+p4(2)-Fty(i,4)/100)/sqrt(p4(1)^2+1)<0.035
        new1_alpha4(order)=alpha(i,4);
        new1_Fty4(order)=Fty(i,4);
        order=order+1;
    end
end
p4=polyfit(new1_alpha4,new1_Fty4,1);
plot(new1_alpha4,new1_Fty4,'o')
alphaX=-0.06:0.001:0.02;
Fty4=alphaX*p4(1)+p4(2);
figure(11)
hold on
plot(alphaX,Fty4)
%%
new_alpha5=zeros(1,vaild(5));
new_Fty5=zeros(1,vaild(5));
order=1;
for i=start:1:(row-1)
    if neighbor(i,5)>200
        new_alpha5(order)=alpha(i,5);
        new_Fty5(order)=Fty(i,5);
        order=order+1;
    end
end
figure(12)
hold on
plot(alpha(:,5),Fty(:,5),'*')
% plot(new_alpha5,new_Fty5,'o')
% 
% p5=polyfit(new_alpha5,new_Fty5,1);
p5=polyfit(new_alpha5*10,new_Fty5/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,5)*10*p5(1)+p5(2)-Fty(i,5)/100)/sqrt(p5(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty5=zeros(1,vaild0);
new1_alpha5=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,5)*10*p5(1)+p5(2)-Fty(i,5)/100)/sqrt(p5(1)^2+1)<0.035
        new1_alpha5(order)=alpha(i,5);
        new1_Fty5(order)=Fty(i,5);
        order=order+1;
    end
end
p5=polyfit(new1_alpha5,new1_Fty5,1);
plot(new1_alpha5,new1_Fty5,'o')
alphaX=-0.06:0.001:0.02;
Fty5=alphaX*p5(1)+p5(2);
figure(12)
hold on
plot(alphaX,Fty5)
%%
new_alpha6=zeros(1,vaild(6));
new_Fty6=zeros(1,vaild(6));
order=1;
for i=start:1:(row-1)
    if neighbor(i,6)>200
        new_alpha6(order)=alpha(i,6);
        new_Fty6(order)=Fty(i,6);
        order=order+1;
    end
end
figure(13)
hold on
plot(alpha(:,6),Fty(:,6),'*')
% plot(new_alpha6,new_Fty6,'o')
% 
% p6=polyfit(new_alpha6,new_Fty6,1);
p6=polyfit(new_alpha6*10,new_Fty6/100,1);
vaild0=0;
for i=start:1:(row-1)
    if abs(alpha(i,6)*10*p6(1)+p6(2)-Fty(i,6)/100)/sqrt(p6(1)^2+1)<0.035
        vaild0=vaild0+1;
    end
end
new1_Fty6=zeros(1,vaild0);
new1_alpha6=zeros(1,vaild0);
order=1;
for i=start:1:(row-1)
    if abs(alpha(i,6)*10*p6(1)+p6(2)-Fty(i,6)/100)/sqrt(p6(1)^2+1)<0.035
        new1_alpha6(order)=alpha(i,6);
        new1_Fty6(order)=Fty(i,6);
        order=order+1;
    end
end
p6=polyfit(new1_alpha6,new1_Fty6,1);
plot(new1_alpha6,new1_Fty6,'o')
alphaX=-0.06:0.001:0.02;
Fty6=alphaX*p6(1)+p6(2);
figure(13)
hold on
plot(alphaX,Fty6)