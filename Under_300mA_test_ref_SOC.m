clc,clear

filename = '2019-10-17_14-52-16.txt'; %1A discharge current '20190920_12VBattery500mADischarge.txt'

delimiterIn = '	';
headerlinesIn=1;
Dat = importdata(filename,delimiterIn,headerlinesIn);

I=5; %discharge current

A_c1=Dat.data(:,1);

%individual battery NO1-3 voltage
B_c1=Dat.data(:,30);
B_c2=Dat.data(:,31);
B_c3=Dat.data(:,32);

%Battery volume
B_c4=Dat.data(:,40);

ti_cnt= length(A_c1);
%ti_len= ti_cnt*0.2/60;

dnb = datevec('2014-08-12 14:52:00');
dna = datevec('2014-08-12 18:15:00'); %8:24:57
ti_len=fix(etime(dna,dnb)/60)  %unit:min

ti1=0:ti_len/(ti_cnt-1):ti_len;

SOC_ref=B_c4(1)-I*(ti1./60)/16*100;
%SOC_ref(SOC_ref==0)=1e-10;

%error=(B_c4-SOC_ref')./SOC_ref';
error=B_c4-SOC_ref';

delta_SOC=error(54401)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%figure 1
figure(1);

subplot(211)
plot(ti1,B_c1,ti1,B_c2,ti1,B_c3,'linewidth',3)

grid on
xlabel('Discharging Time (min)'),ylabel('Individual Battery Voltage (V)')
legend('NO.1 Battery','NO.2 Battery','NO.3 Battery')
ylim([3.1 4.2]);

set(gca,'FontSize',20,'linewidth',2)

subplot(212)
plot(ti1,B_c4,'linewidth',2)


grid on
xlabel('Discharge Time (min)'),ylabel('Battery Volume (%)')
legend('Battery Volume')

set(gca,'FontSize',20,'linewidth',2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%figure 2
figure(2)
plot(B_c4,B_c1,B_c4,B_c2,B_c4,B_c3,'linewidth',3)

SOC=[
    1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 1400, 1450, ...
    1500, 1550, 1600, 1650, 1700, 1750, 1800, 1850, 1900, 1950, ...
    2000
    ];


VOL=[
    3103, 3397, 3511, 3547, 3577, 3601, 3625, 3655, 3681, 3697, ...
    3722, 3748, 3779, 3816, 3863, 3913, 3963, 4013, 4065, 4121, ...
    4200
    ];

SOC = (SOC*0.1)-100;

xxi=0:0.1:100;

f0=interp1(SOC,VOL./1000,xxi,'spline');

hold on
plot(SOC,VOL./1000,'*b','linewidth',2)
plot(xxi,f0,'r','linewidth',2)

box on
title('Standard OCV And Test OCV')
xlabel('SOC (%)'),ylabel('Individual Battery OCV (V)')
legend('NO1 Battery','NO2 Battery','NO3 Battery','Reference Point','Standard OCV','Location','SouthEast')
grid on
set(gca,'FontSize',20,'linewidth',2)

figure(3)
hold on
plot(ti1,B_c4,'linewidth',2)
plot(ti1,SOC_ref,'linewidth',2)

box on
title('Standard SOC And Calculated SOC(0.5A Discharging Current)')
xlabel('Discharging Time (min)'),ylabel('SOC (%)')
ylim([-5,100]);
legend('Calculated SOC','Standard SOC','Location','SouthEast')
grid on
set(gca,'FontSize',20,'linewidth',2)

figure(4)

plot(ti1,error,'linewidth',2)

box on
title('SOC Absolute Error (0.5A Discharge Current)')
xlabel('Discharge Time (min)'),ylabel('SOC Error')

legend('SOC Absolute Error','Location','SouthEast')
grid on

ylim([-15 5])
set(gca,'FontSize',20,'linewidth',2)

% 
% alldatacursors = findall(gcf,'type','hggroup')
% set(alldatacursors,'FontSize',10)





