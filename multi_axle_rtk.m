%% multi-axle deviation data analysis

close all;
clear;clc
ctr_ratio = 1;
HEAD_FLAG = 2;%1表示mc1，2表示mc2
rec_step = 5;
run_flag = 2;
MCU_RTK = 1;    % 1: MCU storage; 0: card storage  
VREC = 1;   % 1: recording;  
USE_MAP = 0;

%% read table RTK data
ddir = 'Fwh/';
file_name = '0.8';
rtk_all = readtable([ddir, file_name, '.csv']);   
% rtk_all = readtable([ddir, file_name, '.xlsx']); 
mag.dev1 = rtk_all.mag1_dev(1:5:end);
mag.dev2 = rtk_all.mag2_dev(1:5:end);
mag.dev3 = rtk_all.mag3_dev(1:5:end);
mag.dev4 = rtk_all.mag4_dev(1:5:end);
mag.dev5 = rtk_all.mag5_dev(1:5:end);
mag.dev6 = rtk_all.mag6_dev(1:5:end);

if HEAD_FLAG ==1
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
elseif HEAD_FLAG ==2
    rtk4.Var5 = rtk_all.rtk1_timestamp(1:5:end);
    rtk3.Var5 = rtk_all.rtk2_timestamp(1:5:end);
    rtk2.Var5 = rtk_all.rtk3_timestamp(1:5:end);
    rtk1.Var5 = rtk_all.rtk4_timestamp(1:5:end);
    
    rtk4.Var9 = rtk_all.rtk1_lat(1:5:end);
    rtk3.Var9 = rtk_all.rtk2_lat(1:5:end);
    rtk2.Var9 = rtk_all.rtk3_lat(1:5:end);
    rtk1.Var9 = rtk_all.rtk4_lat(1:5:end);

    rtk4.Var7 = rtk_all.rtk1_lon(1:5:end);
    rtk3.Var7 = rtk_all.rtk2_lon(1:5:end);
    rtk2.Var7 = rtk_all.rtk3_lon(1:5:end);
    rtk1.Var7 = rtk_all.rtk4_lon(1:5:end);

    rtk4.Var11 = rtk_all.rtk1_flag(1:5:end);
    rtk3.Var11 = rtk_all.rtk2_flag(1:5:end);
    rtk2.Var11 = rtk_all.rtk3_flag(1:5:end);
    rtk1.Var11 = rtk_all.rtk4_flag(1:5:end);
end
%% time alignment for 4 asynchronous RTK receivers 
tm1 = hms2tm(rtk1.Var5);
tm2 = hms2tm(rtk2.Var5);
tm3 = hms2tm(rtk3.Var5);
tm4 = hms2tm(rtk4.Var5);

ts = max([tm1(1), tm2(1), tm3(1), tm4(1)]);
te = min([tm1(end), tm2(end), tm3(end), tm4(end)]);
tline = (ts:te);

% start and end index of each array
ds1 = find(tm1 == ts);  de1 = find(tm1 == te);
ds2 = find(tm2 == ts);  de2 = find(tm2 == te);
ds3 = find(tm3 == ts);  de3 = find(tm3 == te);
ds4 = find(tm4 == ts);  de4 = find(tm4 == te);
skippt = ones(te-ts+1, 4);
% to skip vehicle-stop duration  
% the nomove duration should be specified for each data gruop 

% to skip unvalid-data duration
miss1tp = find(diff(tm1(ds1:de1))>1.1);
for h=1:length(miss1tp)
    aa = tm1(miss1tp(h)) - ts + 2;
    bb = tm1(miss1tp(h)+1) - ts;
    skippt(aa:bb, 1) = 0;
end
nan1 = find(isnan(tm1(ds1:de1))); % deal with some error data 
for h=1:length(nan1)
    aa = tm1(nan1(h)+ds1-2) - ts + 2;
    bb = tm1(nan1(h)+ds1) - ts;
    skippt(aa:bb, 1) = 0;
end

miss2tp = find(diff(tm2(ds2:de2))>1.1);
for h=1:length(miss2tp)
    aa = tm2(miss2tp(h)+ds2-1) - ts + 2;
    bb = tm2(miss2tp(h)+ds2) - ts;
    skippt(aa:bb, 2) = 0;
end
nan2 = find(isnan(tm2(ds2:de2))); % deal with some error data 
for h=1:length(nan2)
    aa = tm1(nan2(h)+ds2-2) - ts + 2;
    bb = tm1(nan2(h)+ds2) - ts;
    skippt(aa:bb, 2) = 0;
end

miss3tp = find(diff(tm3(ds3:de3))>1.1);
for h=1:length(miss3tp)
    aa = tm3(miss3tp(h)+ds3-1) - ts + 2;
    bb = tm3(miss3tp(h)+ds3) - ts;
    skippt(aa:bb, 3) = 0;
end
nan3 = find(isnan(tm3(ds3:de3))); % deal with some error data
for h=1:length(nan3)
    aa = tm3(nan3(h)+ds3-2) - ts + 2;
    bb = tm3(nan3(h)+ds3) - ts;
    skippt(aa:bb, 3) = 0;
end

miss4tp = find(diff(tm4(ds4:de4))>1.1);
for h=1:length(miss4tp)
    aa = tm4(miss4tp(h)+ds4-1) - ts + 2;
    bb = tm4(miss4tp(h)+ds4) - ts;
    skippt(aa:bb, 4) = 0;
end
nan4 = find(isnan(tm4(ds4:de4))); % deal with some error data 
for h=1:length(nan4)
    aa = tm1(nan4(h)+ds4-2) - ts + 2;
    bb = tm1(nan4(h)+ds4) - ts;
    skippt(aa:bb, 4) = 0;
end

skippt(:, 5) = sum(skippt(:, 1:4), 2) == 4;

pos = zeros(te-ts+2, 11);
posflg = zeros(te-ts+2, 4);
tmphh = floor((ts:te+1)'/36000);
tmpmm = floor(((ts:te+1)'-36000*tmphh)/600);
tmpsss = (ts:te+1)'/10-3600*tmphh-60*tmpmm;
pos(:, 9) = tmphh * 10000 + tmpmm * 100 + tmpsss; 
clear tmphh; clear tmpmm; clear tmpsss; 

%% combine 4 coordinates into a big array
earthR = 6378245.0;
dgr2m = 1/180*pi*earthR;
min_lon = min(rtk1.Var9) - 5; max_lon = max(rtk1.Var9) + 5;
min_lat = min(rtk1.Var7) - 5; max_lat = max(rtk1.Var7) + 5;
lim.min_lon = min_lon;
lim.max_lon = max_lon;
lim.min_lat = min_lat;
lim.max_lat = max_lat;

% for coordinate in meter 
max_x = max_lon-min_lon;       % [m]
max_y = max_lat-min_lat;       % [m] 

effind = tm1(ds1:de1)-ts+1;
% effind(find(isnan(effind))) =  te-ts+2; 
% pos(effind,1) = (rtk1.Var9(ds1:de1)-min_lon)/1e4 .* cosd(rtk1.Var7(ds1:de1)/1e4) * dgr2m;
% pos(effind,2) = (rtk1.Var7(ds1:de1)-min_lat)/1e4 * dgr2m;
pos(effind,1) = (rtk1.Var9(ds1:de1)-min_lon);
pos(effind,2) = (rtk1.Var7(ds1:de1)-min_lat);
posflg(effind,1) = rtk1.Var11(ds1:de1);

effind = tm2(ds2:de2)-ts+1;
effind(find(isnan(effind))) =  te-ts+2; 
% pos(effind,3) = (rtk2.Var9(ds2:de2)-min_lon)/1e4 .* cosd(rtk2.Var7(ds2:de2)/1e4) * dgr2m;
% pos(effind,4) = (rtk2.Var7(ds2:de2)-min_lat)/1e4 * dgr2m;
pos(effind,3) = (rtk2.Var9(ds2:de2)-min_lon);
pos(effind,4) = (rtk2.Var7(ds2:de2)-min_lat);
posflg(effind,2) = rtk2.Var11(ds2:de2);

effind = tm3(ds3:de3)-ts+1;
effind(find(isnan(effind))) =  te-ts+2; 
% pos(effind,5) = (rtk3.Var9(ds3:de3)-min_lon)/1e4 .* cosd(rtk2.Var7(ds3:de3)/1e4) * dgr2m;
% pos(effind,6) = (rtk3.Var7(ds3:de3)-min_lat)/1e4 * dgr2m;
pos(effind,5) = (rtk3.Var9(ds3:de3)-min_lon);
pos(effind,6) = (rtk3.Var7(ds3:de3)-min_lat);
posflg(effind,3) = rtk3.Var11(ds3:de3);

effind = tm4(ds4:de4)-ts+1;
effind(find(isnan(effind))) =  te-ts+2; 
% pos(effind,7) = (rtk4.Var9(ds4:de4)-min_lon)/1e4 .* cosd(rtk2.Var7(ds4:de4)/1e4) * dgr2m;
% pos(effind,8) = (rtk4.Var7(ds4:de4)-min_lat)/1e4 * dgr2m;
pos(effind,7) = (rtk4.Var9(ds4:de4)-min_lon);
pos(effind,8) = (rtk4.Var7(ds4:de4)-min_lat);
posflg(effind,4) = rtk4.Var11(ds4:de4);
%% creat moving limitation 

if USE_MAP == 0
% trajectory for valid and moving data for vehicle head (#1)
TRJ = find(skippt(:,1) == 1);

bnd_len = length(TRJ)-10; % length(TRJ); % 5100;         % specify before run
bnd = zeros(bnd_len, 4);      
bnd_lat = 1.75;

for pp = 11:length(TRJ)-10
% determine the track direction first    
aa = polyfit(pos(TRJ(pp-10:pp+10),2), pos(TRJ(pp-10:pp+10),1), 1);
% find the left&right-side points perpendicular to the track  
bnd(pp, 1) = pos(TRJ(pp),1) + bnd_lat * cos(atan(aa(1)));
bnd(pp, 2) = pos(TRJ(pp),2) - bnd_lat * sin(atan(aa(1)));
bnd(pp, 3) = pos(TRJ(pp),1) - bnd_lat * cos(atan(aa(1)));
bnd(pp, 4) = pos(TRJ(pp),2) + bnd_lat * sin(atan(aa(1)));
end

bnd(1:10,1) = bnd(11,1); bnd(1:10,2) = bnd(11,2);
bnd(1:10,3) = bnd(11,3); bnd(1:10,4) = bnd(11,4);

else
    TRJ = R.TRJ;
    bnd = R.bnd;
end

% hp = figure(99);
% hp.Position = [0 0 500 500];
% plot(pos(TRJ(pp-10:pp+10),1) , pos(TRJ(pp-10:pp+10),2));
% hold on;
% line([pos(TRJ(pp),1), bnd(1, 1)]', [pos(TRJ(pp),2), bnd(1, 2)]');
% line([pos(TRJ(pp),1), bnd(1, 3)]', [pos(TRJ(pp),2), bnd(1, 4)]');
%% calculate the angle between cars

car1 = [pos(:,1)-pos(:,3), pos(:,2)-pos(:,4)];
car1(:, 3) = vecnorm(car1')';       % 8.48
car2 = [pos(:,3)-pos(:,5), pos(:,4)-pos(:,6)];
car2(:, 3) = vecnorm(car2')';       % 8.98
car3 = [pos(:,5)-pos(:,7), pos(:,6)-pos(:,8)];
car3(:, 3) = vecnorm(car3')';       % 8.76

for k=1:length(pos)-1
    if (skippt(k, 5) == 1)
        CosTheta = max(min(dot(car1(k,1:2),car2(k,1:2))/(car1(k,3)*car2(k,3)),1),-1);
        pos(k,10) = real(acosd(CosTheta));
        CosTheta = max(min(dot(car2(k,1:2),car3(k,1:2))/(car2(k,3)*car3(k,3)),1),-1);
        pos(k,11) = real(acosd(CosTheta));
    end
end

%% plot the overview figure

hp = figure(101);
hp.Position = [100 1 800 700];

if USE_MAP == 1
    h0 = plot(R.pos(R.TRJ,1), R.pos(R.TRJ, 2), ':', 'linewidth', 1.5);
    
%     axis([0 max_x 0 max_y]);
    %axis([min_lon max_lon min_lat max_lat]);
    hold on;
    plot(R.bnd(:, 1), R.bnd(:, 2), 'r:', 'linewidth', 1.5);
    plot(R.bnd(:, 3), R.bnd(:, 4), 'r:', 'linewidth', 1.5);
    
else
    h0 = plot(pos(TRJ,1), pos(TRJ, 2), ':', 'linewidth', 1.5);
    axis([0 max_x 0 max_y]);
    axis equal
    hold on;
    plot(bnd(:, 1), bnd(:, 2), 'k:', 'linewidth', 1.5);
    plot(bnd(:, 3), bnd(:, 4), 'k:', 'linewidth', 1.5);
end
%% plot and making video

if VREC
    fname = [ddir,file_name,'-转向系数[' , num2str(ctr_ratio) , ']-动态视频' , '.mp4'];     % the video file name 

    saveas(gcf,[ddir , file_name ,'-转向系数[' , num2str(ctr_ratio) ,...
                ']-右侧最大限界位置示意图' , '.jpg']);
    vmag = VideoWriter(fname, 'MPEG-4');
    vmag.FrameRate = 15;
    open(vmag);
    
    for f=1:30      % stay 3s at homepage frame
        F = getframe(gcf);
        writeVideo(vmag, F);
    end
end

h1 = plot(11, max_y+5, 'g.');
pause(0.5);
h2 = plot(13, max_y+5, 'g.');
pause(0.5);
h3 = plot(15, max_y+5, 'g.');
pause(0.5);
h4 = h3; h5 = h3; h6 = h3; 
hc(1:24) = h3;  
%h7 = h3; h8 = h3; h9 = h3;
%
for circle = 1:run_flag
    num=0;
    time_step = 0:0.01*pi:pi/2;
    body_pt = zeros(ceil(length(pos)/rec_step),15);
    if circle ==2 
        VREC = 0;
        rec_step = 1;
    end
for k=11:rec_step: length(pos)-11     % 14100
if (skippt(k, 5) == 1)
    num = num + 1;
    for d=1:24
        delete(hc(d));
    end
    delete(h1); delete(h2); delete(h3);
    delete(h4); delete(h5); delete(h6); 
% %    delete(h7); delete(h8); delete(h9);
    lx = [pos(k,1), pos(k,3), pos(k,5), pos(k,7)];
    ly = [pos(k,2), pos(k,4), pos(k,6), pos(k,8)];
    vangle = atan2(ly(2:4)-ly(1:3), lx(2:4)-lx(1:3));
    ext = [-2.1, -0.2, 1.0, -1.0, 0.2, 2.1];
    lW = 2.5; %车身宽度
    % determine the track direction first    
    qqqq = polyfit(pos(k-10:k+10,1), pos(k-10:k+10,2), 1);
    body_pt(num,16) = atan(qqqq(1));

 
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
        %parameter transfer
            hc(q*6) = polar(angle(z),abs(z), 'r'); 
            hc(q*6).LineWidth = 1.5;
            hc(q*6-5).Color = 'r';
            hc(q*6-4).Color = 'r';
            hc(q*6-3).Color = 'r';
            hc(q*6-2).Color = 'r';
            body_pt(num,q*5-4) = vx(1);
            body_pt(num,q*5-3) = vy(1);
            body_pt(num,q*5-2) = vx(2);
            body_pt(num,q*5-1) = vy(2);
            body_pt(num,q*5) = vangle(q);
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
            body_pt(num,q*5-4) = vx(1);
            body_pt(num,q*5-3) = vy(1);
            body_pt(num,q*5-2) = vx(2);
            body_pt(num,q*5-1) = vy(2);
            body_pt(num,q*5) = vangle(q);
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
            body_pt(num,q*5-4) = vx(1);
            body_pt(num,q*5-3) = vy(1);
            body_pt(num,q*5-2) = vx(2);
            body_pt(num,q*5-1) = vy(2);
            body_pt(num,q*5) = vangle(q);
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
    
    h2 = plot(lx, ly, 'o', 'MarkerSize', 0.5*(48/4.5));
    
    axis([mean(lx(1:4))-30, mean(lx(1:4))+30, mean(ly(1:4))-30, mean(ly(1:4))+30]);
    
    tc = k; %+ts;
    hh = floor(tc/36000);
    mm = floor((tc-hh*36000)/600);
    sss = (tc-hh*36000-mm*600)/10;
    %h3 = text(max_x-20, 5, ...
    h3 = text(mean(lx(1:4))+23, mean(ly(1:4))+31, ...
        [num2str(hh,'%02d'),':',num2str(mm,'%02d'),':',num2str(sss,'%02.1f')], ...
        'FontSize', 13.5);
    
    flgstr = {' ', ' ', ' ', ' '};
    
    for h=1:4
        if (posflg(k,h)~=3) 
            flgstr(h) = {'E'};
        end
    end
    
    h4 = text(mean(lx(1:4))-8, mean(ly(1:4))+32, ...
        [file_name], 'FontSize', 12);
    h5 = text(mean(lx(1:4))-29, mean(ly(1:4))+28, ...
        ['车间夹角Mc1-T: ', num2str(pos(k,10),'%.1f'), '^o'], 'FontSize', 12);
    if abs(pos(k,10)) > 28.0
        h5.Color = 'r';
    end
    h6 = text(mean(lx(1:4))-29, mean(ly(1:4))+26, ...
        ['车间夹角T-Mc2: ', num2str(pos(k,11),'%.1f'), '^o'], 'FontSize', 12);
    if abs(pos(k,11)) > 28.0
        h6.Color = 'r';
    end
    
if VREC 
    F = getframe(gcf);
    writeVideo(vmag, F);
else        
    pause(0.001);
end
end
end
        if VREC
            close(vmag);
        end
end

% axis([min_lon-10 max_lon+10 min_lat-20 max_lat+20]);
plot(bnd(:, 1), bnd(:, 2), 'k:', 'linewidth', 1.5);
plot(bnd(:, 3), bnd(:, 4), 'k:', 'linewidth', 1.5);




%坐标零点计算

% x=[x1;x2;x3;x4];
% y=[y1;y2;y3;y4];
% xmin=min(x);ymin=min(y);
% x1=x1-min(x)+10;x2=x2-min(x)+10;x3=x3-min(x)+10;x4=x4-min(x)+10;
% y1=y1-min(y)+10;y2=y2-min(y)+10;y3=y3-min(y)+10;y4=y4-min(y)+10;
% 
% STEP = 10;
% for h=1+STEP:length(x1)
%     mov(h)= sqrt((x1(h)-x1(h-STEP))^2 + (y1(h)-y1(h-STEP))^2);
% end
% odo = cumsum(mov) / STEP;

% grid on
%  for h=1:10:length(x1)
%   text(x1(h,1), y1(h,1), num2str(odo(h)));
% end

x1 = pos(effind,1) ;
y1 = pos(effind,2) ;
x2 = pos(effind,3) ;
y2 = pos(effind,4) ;
x3 = pos(effind,5) ;
y3 = pos(effind,6) ;
x4 = pos(effind,7) ;
y4 = pos(effind,8) ;
% 
% dis=zeros(matrix_size,1);
% for i = 1: size(x1,1)-1
% dis(i+1)=dis(i)+sqrt((x1(i+1)-x1(i))^2+(y1(i+1)-y1(i))^2);
% end

%第二轴偏移量
error=zeros(length(body_pt),3);
num = 0;
for k=1:length(body_pt)-1 
    i = k *rec_step;
    num = num + 1; 
    min=100;
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x2(i),y2(i),x1(j),y1(j),x1(j+1),y1(j+1),0);
      if  min_new<min
        min=min_new;
      end
    end
    error(num,1)=min;
end
%第三轴偏移量
num = 0;
for  k=1:length(body_pt)-1 
      i = k *rec_step;
    min=100;
    num = num + 1; 
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x3(i),y3(i),x1(j),y1(j),x1(j+1),y1(j+1),0);
      if  min_new<min
        min=min_new;
      end
    end
    error(num,2)=min;
end
%第四轴偏移量
num = 0;
for k=1:length(body_pt)-1 
      i = k *rec_step;
    min=100;
    num = num + 1; 
    for j=1:size(x1,1)-1
        min_new=point_line_dist(x4(i),y4(i),x1(j),y1(j),x1(j+1),y1(j+1),0);
      if  min_new<min
        min=min_new;
      end
    end
    error(num,3)=min;
end

%原图
% plot(x1,y1,x2,y2,x3,y3,x4,y4);
% legend('控制点1','控制点2','控制点3','控制点4');
% xlabel('东西方向/米');
% ylabel('南北方向/米');
% set(gca,'xtick',[0:15:700]);
% set(gca,'ytick',[0:10:600]);
grid on
%  for h=1:200:length(x1)
%   text(x1(h,1), y1(h,1), num2str(odo(h)));
%  end
% saveas(gcf,[ddir,'车辆轨迹坐标_',file_name,'.jpg']);
%偏移图
% figure
% plot(dis,error(:,1),dis,error(:,2),dis,error(:,3))
% legend('控制点2偏移','控制点3偏移','控制点4偏移');
% xlabel('控制点1里程');
% ylabel('偏移量/米');
% set(gca,'ylim',[0,1]);
% set(gca,'ytick',[0:0.1:2.5])
% grid on;
% saveas(gcf,[ddir,'车辆横向偏移',file_name,'.jpg']);
limi_vehicle;
% hold on;
% 
% for k=2500:10000% length(rtk2.Var1)
%     lx = [pos(k,1), pos(k,3), pos(k,5), pos(k,7)];
%     ly = [pos(k,2), pos(k,4), pos(k,6), pos(k,8)];
%     
%     plot(lx, ly, '.', 'LineWidth', 1);
% end
% axis([min_lon-10 max_lon+10 min_lat-10 max_lat+10]);

%% local function converting 'hmmss' to continous second 
% function d = point_line_dist(lat0, lng0, lat1, lng1, lat2, lng2)
%       a = [lat1, lng1, 0] - [lat2, lng2, 0];
%       b = [lat0, lng0, 0] - [lat2, lng2, 0];
%       d = norm(cross(a,b)) / norm(a) ;
% %      d = sqrt((lat0-lat1)^2+(lng0-lng1)^2);
% end


function tm_arr = hms2tm(hms_arr)

hour = floor(hms_arr/10000);
min = floor((hms_arr-hour*10000)/100);
sec = hms_arr-hour*10000-min*100;
tm_arr = hour*3600 + min*60 + sec; 
tm_arr = round(tm_arr * 10);       % integer by 0.1sec

end

% local function
function d = point_line_dist(lat0, lng0, lat1, lng1, lat2, lng2, isLatLon)

      a = [lat1, lng1, 0] - [lat2, lng2, 0];
      b = [lat0, lng0, 0] - [lat2, lng2, 0];
      d = norm(cross(a,b)) / norm(a) ;

      if isLatLon
        earthR = 6378245.0; 
        d = d/180*pi * earthR;
      end
%      d = sqrt((lat0-lat1)^2+(lng0-lng1)^2);
end