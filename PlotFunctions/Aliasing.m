clc
clear all
close all


% Specify time
   Fs = 100;                   % Number of samples per second
   dt = 1/Fs;                   % Time step
   StopTime = 2;             % Total time, seconds 
   t = (0:dt:StopTime-dt)';     % Discrete time, seconds
   t_times = t(1:20:end);       % Times to fit
   Fc4 = 4;                     % Signal frequency 
   x4 = sin(2*pi*Fc4*t);        % 4 hertz signal
   x_times = sin(2*pi*Fc4*t_times); % Signals to fit

data = [t_times(1,1) x_times(1,1); t_times(2,1) x_times(2,1);...,
    t_times(3,1) x_times(3,1); t_times(4,1) x_times(4,1); t_times(5,1) x_times(5,1),...
    ; t_times(6,1) x_times(6,1); t_times(7,1) x_times(7,1)];
xdat = data(:,1);
ydat = data(:,2);
yumax = max(ydat);
ylmin = min(ydat);
yrange = (yumax-ylmin);                   %  y range
yzero = ydat-yumax+(yrange/2);
zxcross = xdat(yzero(:) .* circshift(yzero(:),[1 0]) <= 0);     % Find zero-crossings
per_est = 2*mean(diff(zxcross));                     % Period estimation
ymean = mean(ydat);                    % Offset estimation
fit_func = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % fit function
fcn = @(b) sum((fit_func(b,xdat) - ydat).^2);            % least squares cost function
s_mini = fminsearch(fcn, [yrange;  per_est;  -1;  ymean])     % minimisation of least squares
xp_plot = linspace(min(xdat),max(xdat));

figure(1)
plot(t,x4,'k-')
hold on
plot(xp_plot,fit_func(s_mini,xp_plot), 'k--')
plot(xdat,ydat,'ok')
grid minor
xlim([0 1])
ylim([-1.7 1.7])
xlabel('Time [s]','FontSize',21)
ylabel('Response [-]','FontSize',21)
ax = gca;
ax.FontSize = 21;
legend({'4 Hz signal','Aliased signal'},'FontSize',21,'Location','Northwest')
strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/ValidationCases/Aliasing');
print(strprint,'-depsc')


