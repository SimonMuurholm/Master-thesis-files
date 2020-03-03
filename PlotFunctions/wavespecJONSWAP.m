function S = wavespecJONSWAP(SpecType,Par,W,PlotFlag)
%Function to evaluate different type of wave spectra.
%
%Use:  S = wavespec(SpecType,Par,W,PlotFlag)
%
%Input:
% SpecType	- Spectrum type
% Par		- Spectrum parameters
% W			- Column vector of wave frequencies [rad/s]
% PlotFlag	- 1 to plot the spectrum, 0 for no plot
%
%Output:
% S			- Column vector of wave spectrum values [m^2 s]; evaluated at W(k) 
%     
%SpecType and Par =[p1,p2,p3,...pn]:

% SpecType =7, JONSWAP (p1=Hs,p2=w0,p3=gamma)
 
%
%
%JONSWAP (Hs,w0, gamma):
% p1 = Hs - Significant wave height (Hs = 4 sqrt(m0)) [m]
% p2 = w0 - Modal Freq. [rad/sec] (Recomended 1.25<w0*sqrt(Hc)<1.75)
% p3 = gamma - Peakedness factor (Recommended between 1 and 5; usually 3.3, set to zero to use DNV formula)
% alpha=0.2*Hc^2*w0^4/g^2;
% g=9.81 [m/s^2]
% sigma=0.07  if w<w0, sigma=0.09 otherwise;
% S(w)=S1*S2  [m^2 s]  
%with,
% S1=alpha*g^2*(W^-5)*exp(-(5/4)*(w0/w)^4);
% S2=gamma^(exp(-(w-w0)^2/(2*(sigma*w0)^2))); 
% Reference [3]
%


S=[];
[m,n] = size(W);
if n>m
   disp('Error: W must be a column vector')
   return
end

switch SpecType,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 7,%JONSWAP (gamma,Hs,w0):
    Hs	  = Par(1);
    w0    = Par(2);
    gamma = Par(3);
    g=9.81;
%     alpha=0.2*Hs^2*w0^4/g^2
     alpha=0.0087;
    if gamma<1 | gamma > 7,  %DNV recommeded values when gamma is unknown.
		if gamma ~= 0
			% Display warning if gamma is outside validity range and not
			% set to zero
			disp('Warning: gamma value in wave_spectrum function outside validity range, using DNV formula')
		end
		%k=2*pi/(w0*sqrt(Hs));
        fm = 0.0803;
        Tp = 1/fm;
        k = Tp/sqrt(Hs);
       if k <= 3.6
           gamma = 5;
       elseif k <= 5
		   gamma = exp(5.75-1.15*k);
	   else % k > 5
		   gamma = 1;
       end
       
    end
    for k=1:1:length(W),
            if  W(k) < w0,
                 sigma=0.07;
            else
                 sigma=0.09;
            end
%             S1=alpha*g^2*(W(k)^-5)*exp(-(5/4)*(w0/W(k))^4);
%             S2=gamma^(exp(-(W(k)-w0)^2/(2*(sigma*w0)^2)));
            S1=((alpha*g^2*(W(k)^-5))/(16*pi^4))*exp(-(5/4)*(W(k)/w0)^-4);
            S2=gamma^(exp(-(1/(2*sigma^2)) * ((W(k)/w0)-1)^2 ));    
            % DNV conversion factor from <Environmenatal conditions and environmental
            % loads. April 2007, DNV-RP-C205>            
            %Conv_factor =  1-0.287*log(gamma);
            Conv_factor =  1;
            S=[S;Conv_factor*S1*S2];
    end
    TitleStr='JONSWAP Spectrum';
    L1Str = ['\gamma =',num2str(gamma),...
        ' H_s =',num2str(Hs),' [m],','  f_m =',num2str(w0),' [Hz]'];
    
    
    str = {['H_s = ',num2str(Hs),' [m]'];
      ['f_m = ',num2str(w0),' [Hz]'];
      ['T_p = 12.45 [s]'];
      ['\gamma = ',num2str(gamma)]
     }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
otherwise
    disp('Wrong spectrum type identifier, SpecType=1,2,..,8')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fmlinex = [w0 w0];
fmliney = [0 max(S*1.2)];
%Plot Spectrum
if PlotFlag==1,
    figure(1)
    subplot(221)
    set(gcf,'windowstyle','docked')
	p = plot(W, S,'k','linewidth',1)
    hold on
    plot(fmlinex, fmliney,':k','linewidth',1)
    grid minor
    ax = gca;
    ax.FontSize = 7;
	%title(TitleStr)
    %legend(L1Str)
    %dim = [.77 .58 .3 .3]; % For non sub plot
    dim = [.37 .61 .3 .3]; % For sub plot
    t = annotation('textbox');
    t.Position = dim;
    t.FontSize = 7;
    t.String = str;
    t.FitBoxToText = 'on';
    t.BackgroundColor = 'white';


    xticks([0 0.05 w0 0.1 0.15 0.2])
    xticklabels({'0','0.05','f_m','0.1','0.15','0.2'})
    xlim([0 0.2])
    ylim([0 max(S)*1.05])
    xlabel('f [Hz]','FontSize',7)
	ylabel('S(f) [m^2/Hz]','FontSize',7)
    strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/JONSWAP_MATLAB');
    print(strprint,'-depsc')
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Plot with P1 and P3 %%%%%%%%%%%%%%%%%%%
    
    f1 = 0.145; % first natural frequency of integrated WTG Hz
    f1X = [f1 f1];
    f1Y = [0 max(S)*1.05];
    P1rpm1 = 4; 
    P1rpm2 = 7.81;
    P3rpm1 = 3*P1rpm1;
    P3rpm2 = 3*P1rpm2;
    P1freq1 = P1rpm1/60
    P1freq2 = P1rpm2/60
    P3freq1 = P3rpm1/60
    P3freq2 = P3rpm2/60
    Lim1P1X = [P1freq1 P1freq1];
    Lim1P1Y = [0 max(S)*1.05];
    Lim1P3X = [P3freq1 P3freq1];
    Lim1P3Y = [0 max(S)*1.05];
    
    Lim2P1X = [P1freq2 P1freq2];
    Lim2P1Y = [0 max(S)*1.05];
    Lim2P3X = [P3freq2 P3freq2];
    Lim2P3Y = [0 max(S)*1.05];
    
    % Horizontal line in 1P top
    Horiz1PX = [P1freq1 P1freq2];
    Horiz1PY = [max(S)*1.05 max(S)*1.05];
    Horiz3PX = [P3freq1 P3freq2];
    Horiz3PY = [max(S)*1.05 max(S)*1.05];
    
    
    
    figure(2)
    subplot(221)
    set(gcf,'windowstyle','docked')
	p = plot(W, S,'k','linewidth',1)
    hold on
    %plot(fmlinex, fmliney,':k','linewidth',1)
    plot(Lim1P1X, Lim1P1Y,'-k','linewidth',1)
    plot(Lim2P1X, Lim2P1Y,'-k','linewidth',1)
    plot(Horiz1PX, Horiz1PY,'-k','linewidth',1)
    plot(Lim1P3X, Lim1P3Y,'-k','linewidth',1)
    plot(Lim2P3X, Lim2P3Y,'-k','linewidth',1)
    plot(Horiz3PX, Horiz3PY,'-k','linewidth',1)
    %plot(f1X, f1Y,'-b','linewidth',1)

    ax = gca;
    ax.FontSize = 16;
	%title(TitleStr)
    %legend(L1Str)
    %dim = [.77 .58 .3 .3]; % For non sub plot
    
    str1P = {'1P'};
    text(0.08,max(S)*1.13,str1P,'FontSize',16)
    str3P = {'3P'};
    text(0.28,max(S)*1.13,str3P,'FontSize',16)
    

    %xticks([0 0.05 0.1 0.2])
    %xticklabels({'','','','',''})
    %yticks([0 50 100 150 200])
    %yticklabels({'','','','',''})
    xlim([0 0.4])
    ylim([0 max(S)*1.25])
    xlabel('f [Hz]','FontSize',16)
	ylabel('S [m^2/Hz]','FontSize',16)
    
    
    strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/JONSWAP_1P_3P_v2');
    print(strprint,'-depsc')
    
    %%%%%%%%%%%%%%%%%% Soft-soft etc plot %%%%%%%%%%%
    
    figure(3)
    subplot(221)
    set(gcf,'windowstyle','docked')
	p = plot(W, S,'k','linewidth',1)
    hold on
    %plot(fmlinex, fmliney,':k','linewidth',1)
    plot(Lim1P1X, Lim1P1Y,'-k','linewidth',1)
    plot(Lim2P1X, Lim2P1Y,'-k','linewidth',1)
    plot(Horiz1PX, Horiz1PY,'-k','linewidth',1)
    plot(Lim1P3X, Lim1P3Y,'-k','linewidth',1)
    plot(Lim2P3X, Lim2P3Y,'-k','linewidth',1)
    plot(Horiz3PX, Horiz3PY,'-k','linewidth',1)
    %plot(f1X, f1Y,'-b','linewidth',1)

    ax = gca;
    ax.FontSize = 7;
	%title(TitleStr)
    %legend(L1Str)
    %dim = [.77 .58 .3 .3]; % For non sub plot
    
    str1P = {'1P'};
    text(0.09,max(S)*1.11,str1P,'FontSize',7)
    str3P = {'3P'};
    text(0.29,max(S)*1.11,str3P,'FontSize',7)
    
    % Create doublearrow

    ar = annotation('doublearrow');
    ar.X = [0.133928571428571 0.169642857142857];
    ar.Y = [0.863285714285714 0.864285714285714];
    ar.HeadSize = 5;
    
    str = {'Soft-soft'};
    text(0.009,max(S)*0.93,str,'FontSize',7)
    
    ar = annotation('doublearrow');
    ar.X = [0.223214285714285 0.258928571428571];
    ar.Y = [0.863285714285714 0.863285714285714];
    ar.HeadSize = 5;
    
    str = {'Soft-stiff'};
    text(0.14,max(S)*0.93,str,'FontSize',7)
    
    ar = annotation('doublearrow');
    ar.X = [0.396428571428571 0.455357142857143];
    ar.Y = [0.863285714285714 0.863285714285714];
    ar.HeadSize = 5;
    
    str = {'Stiff-stiff'};
    text(0.42,max(S)*0.93,str,'FontSize',7)



    xticks([0 0.05 0.1 0.2])
    xticklabels({'','','',''})
    yticks([0 50 100 150 200])
    yticklabels({'','','','',''})
    xlim([0 0.5])
    ylim([0 max(S)*1.25])
    xlabel('Frequency','FontSize',7)
	ylabel('Power spectral density','FontSize',7)
    
    strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/Soft-soft');
    print(strprint,'-depsc')
    
    
    figure(10)
    subplot(221)
    %set(gcf,'windowstyle','docked')
	p = plot(W, S,'k','linewidth',1)
    hold on
    %plot(fmlinex, fmliney,':k','linewidth',1)
    plot(Lim1P1X, Lim1P1Y,'-k','linewidth',1)
    plot(Lim2P1X, Lim2P1Y,'-k','linewidth',1)
    plot(Horiz1PX, Horiz1PY,'-k','linewidth',1)
    plot(Lim1P3X, Lim1P3Y,'-k','linewidth',1)
    plot(Lim2P3X, Lim2P3Y,'-k','linewidth',1)
    plot(Horiz3PX, Horiz3PY,'-k','linewidth',1)
    %plot(f1X, f1Y,'-b','linewidth',1)

    ax = gca;
    ax.FontSize = 10;
	%title(TitleStr)
    %legend(L1Str)
    %dim = [.77 .58 .3 .3]; % For non sub plot
    
    str1P = {'1P'};
    text(0.09,max(S)*1.11,str1P,'FontSize',10)
    str3P = {'3P'};
    text(0.29,max(S)*1.11,str3P,'FontSize',10)
    
    % Create doublearrow

    ar = annotation('doublearrow');
    ar.X = [0.133928571428571 0.169642857142857];
    ar.Y = [0.863285714285714 0.864285714285714];
    ar.HeadSize = 5;
    
    str = {'A'};
    text(0.023,max(S)*0.93,str,'FontSize',10)
    
    ar = annotation('doublearrow');
    ar.X = [0.223214285714285 0.258928571428571];
    ar.Y = [0.863285714285714 0.863285714285714];
    ar.HeadSize = 5;
    
    str = {'B'};
    text(0.155,max(S)*0.93,str,'FontSize',10)
    
    ar = annotation('doublearrow');
    ar.X = [0.396428571428571 0.455357142857143];
    ar.Y = [0.863285714285714 0.863285714285714];
    ar.HeadSize = 5;
    
    str = {'C'};
    text(0.43,max(S)*0.93,str,'FontSize',10)



    xticks([0 0.05 0.1 0.2])
    xticklabels({'','','',''})
    yticks([0 50 100 150 200])
    yticklabels({'','','','',''})
    xlim([0 0.5])
    ylim([0 max(S)*1.25])
    xlabel('Frequency','FontSize',10)
	ylabel('Power spectral density','FontSize',10)
    
    %strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/Soft-soft-small');
    %print(strprint,'-depsc')
    
    
    
    %%%%%%%%%%%%%%%% Frequencies f1 in plot %%%%%%%%%%%%%%%%
    
    f1 = 0.145; % first natural frequency of integrated WTG Hz
    f1X = [f1 f1];
    f1Y = [0 max(S)*1.05];
    
    T1_vals = [6.348 6.127 5.813 5.730 5.695 5.702 5.759 5.821];
    f1_vals = 1./T1_vals
    
    
    figure(4)
    subplot(221)
    set(gcf,'windowstyle','docked')
	p = plot(W, S,'k','linewidth',1)
    hold on
    %plot(fmlinex, fmliney,':k','linewidth',1)
    plot(Lim1P1X, Lim1P1Y,'-k','linewidth',1)
    plot(Lim2P1X, Lim2P1Y,'-k','linewidth',1)
    plot(Horiz1PX, Horiz1PY,'-k','linewidth',1)
    plot(Lim1P3X, Lim1P3Y,'-k','linewidth',1)
    plot(Lim2P3X, Lim2P3Y,'-k','linewidth',1)
    plot(Horiz3PX, Horiz3PY,'-k','linewidth',1)
    p1 = plot([f1_vals(1,1) f1_vals(1,1)],[0 max(S)*1.05],'-','linewidth',0.1)
    p2 = plot([f1_vals(1,2) f1_vals(1,2)],[0 max(S)*1.05],'-','linewidth',0.1)
    p3 = plot([f1_vals(1,3) f1_vals(1,3)],[0 max(S)*1.05],'-','linewidth',0.1)
    p4 = plot([f1_vals(1,4) f1_vals(1,4)],[0 max(S)*1.05],'-','linewidth',0.1)
    p5 = plot([f1_vals(1,5) f1_vals(1,5)],[0 max(S)*1.05],'-','linewidth',0.1)
    p6 = plot([f1_vals(1,6) f1_vals(1,6)],[0 max(S)*1.05],'-','linewidth',0.1)
    p7 = plot([f1_vals(1,7) f1_vals(1,7)],[0 max(S)*1.05],'-','linewidth',0.1)
    p8 = plot([f1_vals(1,8) f1_vals(1,8)],[0 max(S)*1.05],'-','linewidth',0.1)
    
    grid minor
    ax = gca;
    ax.FontSize = 7;
    %dim = [.77 .58 .3 .3]; % For non sub plot
    
    str1P = {'1P'};
    text(0.09,max(S)*1.11,str1P,'FontSize',7)
    str3P = {'3P'};
    text(0.29,max(S)*1.11,str3P,'FontSize',7)
    

    %xticks([0 0.05 0.1 0.2])
    %xticklabels({'','','','',''})
    %yticks([0 50 100 150 200])
    %yticklabels({'','','','',''})
    xlim([0 0.54])
    ylim([0 max(S)*1.25])
    xlabel('f [Hz]','FontSize',7)
	ylabel('S [m^2/Hz]','FontSize',7)
    legend([p1 p2 p3 p4 p5 p6 p7 p8],{'l = 25 m','l = 30 m','l = 40 m','l = 50 m','l = 60 m','l = 70 m','l = 80 m','l = 90 m'},'FontSize',7,'Location','Northeast')

    strprint = sprintf('/Users/simonmuurholmhansen/Dropbox (WoodThilsted)/!E - Employees drive/SMH/Master Thesis/DynamicAnalysisOfBuoyancyGuyedMonopiles/FIGURES/OrcaFlexModels/JONSWAP_f1_vals');
    print(strprint,'-depsc')
    
    
end            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of Function wave_spectrum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = S';
