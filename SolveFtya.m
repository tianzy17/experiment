function Ftya=SolveFtya(DirectionAccX,DirectionAccY,Aycena,Axa,Thetaa,Deltaa,Alphaa)
%     syms Fx1 Fx2 Fx3 Fx4 Fx5 Fx6 Fy1 Fy2 Fy3 Fy4 Fy5 Fy6 Ftx1 Ftx2 Ftx3 Ftx4 Ftx5 Ftx6 Fty1 Fty2 Fty3 Fty4 Fty5 Fty6 
%     syms FJ11x FJ11y FJ12x FJ12y FJ22x FJ22y FJ23x FJ23y f k16 k25 k34
    a1=(3400-967)/1000;
    b1=(3600+967)/1000;
    c1=(4500+967)/1000;
    % d1=0;
    a2=(3600+10)/1000;
    b2=(3600-10)/1000;
    c2=(4500-10)/1000;
    d2=(4500+10)/1000;
    a3=(3600+967)/1000;
    b3=(3400-967)/1000;
    %c3=0;
    d3=(4500+967)/1000;
    G1=(7041+6958);
    G6=7158+6296;
    G2=4829;%
    G3=5635;%
    G4=5773;
    G5=4395;
    m1=G1+G2;%
    m2=G3+G4;
    m3=G5+G6;%
    Ftya=zeros(7,6);
    for i=1:1:7
        aycena=DirectionAccY.*abs(Aycena(i,:));
        axa=DirectionAccX.*abs(Axa(i,:));
        thetaa=Thetaa(i,:);
        alphaa=Alphaa(i,:);
        [delta1a,delta3a,delta4a,delta5a,delta6a,delta8a]=deal(Deltaa(i,1),Deltaa...
            (i,2),Deltaa(i,3),Deltaa(i,4),Deltaa(i,5),Deltaa(i,6));

        %     feq1=Fx1+Fx2+FJ11x==0;
            A1=zeros(1,36);
            A1([1 2 25])=[1 1 1];
            B1=m1*axa(1);
        %     feq2=Fy1+Fy2+FJ11y-m1*aycena(1)==0;
            A2=zeros(1,36);
            A2([7 8 26])=[1 1 1];
            B2=m1*aycena(1);
        %     feq3=Fy1*a1-Fy2*b1-FJ11y*c1==0;
            A3=zeros(1,36);
            A3([7 8 26])=[a1 -b1 -c1];
            B3=0;
        %     feq4=Fx3+Fx4+FJ12x+FJ22x==0;
            A4=zeros(1,36);
            A4([3 4 27 29])=[1 1 1 1];
            B4=m2*axa(2);
        %     feq5=Fy3+Fy4+FJ12y+FJ22y-m2*aycena(2)==0;
            A5=zeros(1,36);
            A5([9 10 28 30])=[1 1 1 1];
            B5=m2*aycena(2);
        %     feq6=Fy3*a2-Fy4*b2+FJ12y*d2-FJ22y*c2==0;
            A6=zeros(1,36);
            A6([9 10 28 30])=[a2 -b2 d2 -c2];
            B6=0;
        %     feq7=Fx5+Fx6+FJ23x==0;
            A7=zeros(1,36);
            A7([5 6 31])=[1 1 1];
            B7=m3*axa(3);
        %     feq8=Fy5+Fy6+FJ23y-m3*aycena(3)==0;
            A8=zeros(1,36);
            A8([11 12 32])=[1 1 1];
            B8=m3*aycena(3);
        %     feq9=Fy5*a3-Fy6*b3-FJ23y*d3==0;
            A9=zeros(1,36);
            A9([11 12 32])=[a3 -b3 -d3];
            B9=0;
            
        %     feq10=FJ12x+FJ11x*cosd(thetaa(1))-FJ11y*sind(thetaa(1))==0;
            A10=zeros(1,36);
            A10([25 26 27])=[cosd(thetaa(1)) -sind(thetaa(1)) 1];
            B10=0;
        %     feq11=FJ12y+FJ11x*sind(thetaa(1))+FJ11y*cosd(thetaa(1))==0;
            A11=zeros(1,36);
            A11([25 26 28])=[sind(thetaa(1)) cosd(thetaa(1)) 1];
            B11=0;
        %     feq12=FJ23x+FJ22x*cosd(thetaa(2))-FJ22y*sind(thetaa(2))==0;
            A12=zeros(1,36);
            A12([29 30 31])=[cosd(thetaa(2)) -sind(thetaa(2)) 1];
            B12=0;
        %     feq13=FJ23y+FJ22x*sind(thetaa(2))+FJ22y*cosd(thetaa(2))==0;
            A13=zeros(1,36);
            A13([29 30 32])=[sind(thetaa(2)) cosd(thetaa(2)) 1];
            B13=0;
            
        %     feq14=Ftx2+f*G2==0;
            A14=zeros(1,36);
            A14([14 33])=[1 G2];
            B14=0;
        %     feq15=Ftx3+f*G3==0;
            A15=zeros(1,36);
            A15([15 33])=[1 G3];
            B15=0;
        %     feq16=Ftx4+f*G4==0;
            A16=zeros(1,36);
            A16([16 33])=[1 G4];
            B16=0;
        %     feq17=Ftx5+f*G5==0;
            A17=zeros(1,36);
            A17([17 33])=[1 G5];
            B17=0;
        %     feq18=Ftx6+f*G6==0;
            A18=zeros(1,36);
            A18([18 33])=[1 G6];
            B18=0;
        
        %     feq19=Fty1-k16*alphaa(1)==0;
            A19=zeros(1,36);
            A19([19 34])=[1 -alphaa(1)];
            B19=0;
        %     feq20=Fty2-k25*alphaa(2)==0;
            A20=zeros(1,36);
            A20([20 35])=[1 -alphaa(2)];
            B20=0;
        %     feq21=Fty3-k34*alphaa(3)==0;
            A21=zeros(1,36);
            A21([21 36])=[1 -alphaa(3)];
            B21=0;
        %     feq22=Fty6-k16*alphaa(6)==0;
            A22=zeros(1,36);
            A22([24 34])=[1 -alphaa(6)];
            B22=0;
        %     feq23=Fty5-k25*alphaa(5)==0;
            A23=zeros(1,36);
            A23([23 35])=[1 -alphaa(5)];
            B23=0;
        %     feq24=Fty4-k34*alphaa(4)==0;
            A24=zeros(1,36);
            A24([22 36])=[1 -alphaa(4)];
            B24=0;
            
        %     feq25=Fx1-Ftx1*cosd(delta1a)+Fty1*sind(delta1a)==0;
            A25=zeros(1,36);
            A25([1 13 19])=[1 -cosd(delta1a) sind(delta1a)];
            B25=0;
        %     feq26=Fy1-Ftx1*sind(delta1a)-Fty1*cosd(delta1a)==0;
            A26=zeros(1,36);
            A26([7 13 19])=[1 -sind(delta1a) -cosd(delta1a)];
            B26=0;
        %     feq27=Fx2-Ftx2*cosd(delta3a)+Fty2*sind(delta3a)==0;
            A27=zeros(1,36);
            A27([2 14 20])=[1 -cosd(delta3a) sind(delta3a)];
            B27=0;
        %     feq28=Fy2-Ftx2*sind(delta3a)-Fty2*cosd(delta3a)==0;
            A28=zeros(1,36);
            A28([8 14 20])=[1 -sind(delta3a) -cosd(delta3a)];
            B28=0;
        %     feq29=Fx3-Ftx3*cosd(delta4a)+Fty3*sind(delta4a)==0;
            A29=zeros(1,36);
            A29(3)=1;A29(15)=-cosd(delta4a);A29(21)=sind(delta4a);
            B29=0;
        %     feq30=Fy3-Ftx3*sind(delta4a)-Fty3*cosd(delta4a)==0;
            A30=zeros(1,36);
            A30(9)=1;A30(15)=-sind(delta4a);A30(21)=-cosd(delta4a);
            B30=0;
        %     feq31=Fx4-Ftx4*cosd(delta5a)+Fty4*sind(delta5a)==0;
            A31=zeros(1,36);
            A31(4)=1;A31(16)=-cosd(delta5a);A31(22)=sind(delta5a);
            B31=0;
        %     feq32=Fy4-Ftx4*sind(delta5a)-Fty4*cosd(delta5a)==0;
            A32=zeros(1,36);
            A32(10)=1;A32(16)=-sind(delta5a);A32(22)=-cosd(delta5a);
            B32=0;
        %     feq33=Fx5-Ftx5*cosd(delta6a)+Fty5*sind(delta6a)==0;
            A33=zeros(1,36);
            A33(5)=1;A33(17)=-cosd(delta6a);A33(23)=sind(delta6a);
            B33=0;
        %     feq34=Fy5-Ftx5*sind(delta6a)-Fty5*cosd(delta6a)==0;
            A34=zeros(1,36);
            A34(11)=1;A34(17)=-sind(delta6a);A34(23)=-cosd(delta6a);
            B34=0;
        %     feq35=Fx6-Ftx6*cosd(delta8a)+Fty6*sind(delta8a)==0;
            A35=zeros(1,36);
            A35(6)=1;A35(18)=-cosd(delta8a);A35(24)=sind(delta8a);
            B35=0;
        %     feq36=Fy6-Ftx6*sind(delta8a)-Fty6*cosd(delta8a)==0;
            A36=zeros(1,36);
            A36(12)=1;A36(18)=-sind(delta8a);A36(24)=-cosd(delta8a);
            B36=0;
        
        %     allanswer=solve([feq1 feq2 feq3 feq4 feq5 feq6 feq7 feq8 feq9 feq10 feq11 feq12 feq13 feq14 feq15 ...
        %         feq16 feq17 feq18 feq19 feq20 feq21 feq22 feq23 feq24 feq25 feq26 feq27 feq28 feq29 feq30 ...
        %         feq31 feq32 feq33 feq34 feq35 feq36],[Fx1 Fx2 Fx3 Fx4 Fx5 Fx6 Fy1 Fy2 Fy3 Fy4 Fy5 Fy6 Ftx1 ...
        %         Ftx2 Ftx3 Ftx4 Ftx5 Ftx6 Fty1 Fty2 Fty3 Fty4 Fty5 Fty6 FJ11x FJ11y FJ12x FJ12y FJ22x...
        %         FJ22y FJ23x FJ23y f k16 k25 k34]);
        
            A=[A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;A11;A12;A13;A14;A15;A16;A17;A18;A19;...
                A20;A21;A22;A23;A24;A25;A26;A27;A28;A29;A30;A31;A32;A33;A34;A35;A36];
            B=[B1;B2;B3;B4;B5;B6;B7;B8;B9;B10;B11;B12;B13;B14;B15;B16;B17;B18;B19;...
                B20;B21;B22;B23;B24;B25;B26;B27;B28;B29;B30;B31;B32;B33;B34;B35;B36];    
           temp0=A\B; 
        %     ka(:)=[double(allanswer.k16) double(allanswer.k25) double(allanswer.k34)];
        %     Ftya(:)=[double(allanswer.Fty1) double(allanswer.Fty2) double(allanswer.Fty3) double(allanswer.Fty4) ...
        %         double(allanswer.Fty5) double(allanswer.Fty6)];
    %         ka(:)=temp0(34:36);
            Ftya(i,:)=temp0(19:24);
    end

end