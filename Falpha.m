clf;
%%
% ax视为0
Fzero=[-2305.42850454237 -221.480509988400 254.465588582915 259.415376668433 -1393.19474043004 -1644.30543285986
    -5145.97221304272 -625.151318228854 1716.41780956032 2431.30168724778 -2197.48993006200 -5534.43473143050
    -10021.4338689226 -1767.85330545057 3496.72826036460 3551.34743943795 -4218.65010486664 -9863.58131767345
    -18725.6042206633 -3753.46194850338 5204.04730358388 8281.04001563753 -6772.57189626497 -22132.1648765061
    -4080.58464315530 -1647.37181365586 5847.13585732036 7641.43847934738 -137.972316761010 -11453.7815689354
    -11946.7135849683 -3820.34569370337 12949.6880414451 16260.2817351692 -1753.43919078601 -24927.3762534041
    -20247.3873414751 -5514.27232077874 20778.1617638798 25483.6322696300 -3924.24452236951 -39923.9734665792];
alpha=[0.00985864195846794	0.00375614445149155	-0.0279650815866541	-0.0285090499417430	0.0236275448994929	0.00703149913388738
    0.0152154765271583	0.00708576199946294	-0.0196000196018925	-0.0277633804908945	0.0249073947164512	0.0163640723775652
    0.0211552115856662	0.0152048091763310	-0.0173996664769294	-0.0176714506787195	0.0362834233069230	0.0208219854061901
    0.0301051187059094	0.0259160240812140	-0.00641019886409637	-0.0102003518041082	0.0467616666329441	0.0355818398687899
    -0.0133988073359412	-0.0176069293129401	-0.0418634769956110	-0.0547100652010742	-0.00147463299312050	-0.0376090746622652
    -0.0236968186286336	-0.0296399652952158	-0.0485045947553304	-0.0609048166757125	-0.0136039722394305	-0.0494445195964069
    -0.0354619101459265	-0.0411893074832410	-0.0539809628616987	-0.0662056163947786	-0.0293124649760632	-0.0699241011130396]*180/pi;
%%
%ay对比
% alpha=[0.00985864195846794	0.00375614445149155	-0.0279650815866541	-0.0285090499417430	0.0236275448994929	0.00703149913388738
%     0.0152154765271583	0.00708576199946294	-0.0196000196018925	-0.0277633804908945	0.0249073947164512	0.0163640723775652
%     0.0211552115856662	0.0152048091763310	-0.0173996664769294	-0.0176714506787195	0.0362834233069230	0.0208219854061901
%     0.0301051187059094	0.0259160240812140	-0.00641019886409637	-0.0102003518041082	0.0467616666329441	0.0355818398687899
%     -0.0133988073359412	-0.0176069293129401	-0.0418634769956110	-0.0547100652010742	-0.00147463299312050	-0.0376090746622652
%     -0.0236968186286336	-0.0296399652952158	-0.0485045947553304	-0.0609048166757125	-0.0136039722394305	-0.0494445195964069
%     -0.0354619101459265	-0.0411893074832410	-0.0539809628616987	-0.0662056163947786	-0.0293124649760632	-0.0699241011130396]*180/pi;
%%
% ax视为正
Fpositive=[-2303.34262944652	-221.565718930066	273.412512958203	278.730850917410	-1393.73073634847	-1642.81771994852
   -5145.21414598270	-625.253177266912	1693.47861639206	2398.80837545420	-2197.84797811196	-5533.61943890810
   -10023.1220732070	-1767.70081307708	3331.10226364801	3383.13435121745	-4218.28621043862	-9865.24293021881
   -18728.0600136775	-3753.05839516338	5033.27020209972	8009.28767968720	-6771.84374341657	-22135.0674272197
   -4073.53168294856	-1717.01011665244	5868.06507696636	7668.79022013949	-143.804732928446	-11433.9846347491
   -11941.4844771043	-3827.00526293915	13311.9348654660	16715.1371260789	-1756.49575964862	-24916.4654754511
   -20239.6596686870	-5520.32952561018	21476.2939869393	26339.8651284460	-3928.55514605617	-39908.7359745440];
%%
%ax视为负
Fnegative=[-2307.51437963822	-221.395301046735	235.518664207625	240.099902419457	-1392.65874451161	-1645.79314577119
    -5146.73028010275	-625.049459190795	1739.35700272858	2463.79499904136	-2197.13188201205	-5535.25002395290
    -10023.1220732070	-1767.70081307708	3331.10226364801	3383.13435121745	-4218.28621043862	-9865.24293021881
    -18723.1484276491	-3753.86550184339	5374.82440506805	8552.79235158786	-6773.30004911336	-22129.2623257926
    -4087.63760336200	-1577.73351065974	5826.20663767388	7614.08673855464	-132.139900593613	-11473.5785031217
    -11951.9426928322	-3813.68612446760	12587.4412174242	15805.4263442595	-1750.38262192340	-24938.2870313571
    -20255.1150142631	-5508.21511594730	20080.0295408203	24627.3994108140	-3919.93389868285	-39939.2109586143];
F_all=cat(3,Fzero,Fpositive,Fnegative);
% figure(1)
% title('R20')
% for i=1:1:6
%     subplot(2,3,i);
%     hold on
%     plot(alpha(1:4,i),F(1:4,i),'*');
%     title(['第',num2str(i),'轴']);
%     set(gca,'YDir','reverse');
%     xlabel('侧偏角(°)')
%     ylabel('侧偏力(N)')
% end
% for i=1:1:6
%     subplot(2,3,i);
%     hold on
%     plot(alpha(1:4,i),F(1:4,i));
%     title(['第',num2str(i),'轴']);
%     set(gca,'YDir','reverse');
%     xlabel('侧偏角(°)')
%     ylabel('侧偏力(N)')
% end
% 
% figure(2)
% title('R20')
% for i=1:1:6
%     subplot(2,3,i);
%     hold on
%     plot(alpha(5:7,i),F(5:7,i),'*');
%     title(['第',num2str(i),'轴']);
%     set(gca,'YDir','reverse');
%     xlabel('侧偏角(°)')
%     ylabel('侧偏力(N)')
% end
% for i=1:1:6
%     subplot(2,3,i);
%     hold on
%     plot(alpha(5:7,i),F(5:7,i));
%     title(['第',num2str(i),'轴']);
%     set(gca,'YDir','reverse');
%     xlabel('侧偏角(°)')
%     ylabel('侧偏力(N)')
% end

figure(1)
title('R20')
for i=1:1:6
    subplot(2,3,i);
    hold on
    for j=1:1:3
%       Target=[line line line];
      F=F_all(:,:,j); 
%       plot(alpha(1:4,i),F(1:4,i));
      plot(alpha(1:4,i),F(1:4,i),'o-');
      title(['第',num2str(i),'轴']);
      set(gca,'YDir','reverse');
      xlabel('侧偏角(°)')
      ylabel('侧偏力(N)')
    end
    legend('a_x为零','a_x为正','a_x为负')
end

figure(2)
title('R20')
for i=1:1:6
    subplot(2,3,i);
    hold on
    for j=1:1:3
%       Target=[line line line];
      F=F_all(:,:,j); 
%       plot(alpha(5:7,i),F(5:7,i));
      plot(alpha(5:7,i),F(5:7,i),'o-');
      title(['第',num2str(i),'轴']);
      set(gca,'YDir','reverse');
      xlabel('侧偏角(°)')
      ylabel('侧偏力(N)')
    end
    legend('a_x为零','a_x为正','a_x为负')
end