clc
clear all
close all
omega = [0:0.1:9];

T1 = 5.82;
T2 = 1.797;
omega1 = (2*pi/T1);
omega2 = (2*pi/T2);
f1 = omega1/(2*pi);
f2 = omega2/(2*pi);
zeta12 = 0.8/100;

alpha = 2* ((omega1*omega2)/(omega1 + omega2)) * zeta12;
beta = ((2)/(omega1 + omega2)) * zeta12;

zeta = 0.5*((beta*omega) + (alpha./omega)); 
Zeta_08_X = [0 max(omega/(2*pi))];
Zeta_08_Y = [0.8 0.8];

f1X = [f1 f1];
f1Y = [0 10];

f2X = [f2 f2];
f2Y = [0 10];

figure(1)
subplot(221)
p1 = plot(omega/(2*pi),zeta*100,'-k')
hold on
p2 = plot(f1X,f1Y,'--k')
p3 = plot(f2X,f2Y,'-.k')
plot(Zeta_08_X,Zeta_08_Y,':k')
%grid minor
xlabel('Response frequency [Hz]','FontSize',10)
ylabel('Damping ratio [%]','FontSize',10)
ax = gca;
ax.FontSize = 10;
xlim([0 max(omega/(2*pi))]);
ylim([0 4]);
xticks([0 f1 0.4 f2 0.8 1.0 1.2 1.4])
xticklabels({'0','f_1','0.4','f_2','0.8','1.0','1.2','1.4'})
yticks([0 zeta12*100 1.2 2.4 3.6 4.8])
yticklabels({'0','\zeta_*','1.2','2.4','3.6','4.8'})

legend([p1 p2 p3],{'\zeta_j','f_1','f_2'},'FontSize',10,'Location','Northeast')
str = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/RayleighDamping');
print(str,'-depsc')
%print(str,'-dpng')

%'/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/Temp/SineLoadResponseBeats.xlsx');




