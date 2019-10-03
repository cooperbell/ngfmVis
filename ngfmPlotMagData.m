ngfmPlotXYZ;

ngfmPlotSpectra;

% if (strcmp(spectra,'psd'))
%     [Px, f, ENBW] = welchPSDSpectrum( magData(1,:), assumedSamplingRate, nfft );
%     [Py, f, ENBW] = welchPSDSpectrum( magData(2,:), assumedSamplingRate, nfft );
%     [Pz, f, ENBW] = welchPSDSpectrum( magData(3,:), assumedSamplingRate, nfft );
% 
%     ref500pt = ((0.500)^2)./f;
%     ref300pt = ((0.300)^2)./f;
%     ref200pt = ((0.200)^2)./f;
%     ref100pt = ((0.100)^2)./f;
%     ref50pt = ((0.050)^2)./f;
%     ref30pt = ((0.030)^2)./f;
%     ref20pt = ((0.020)^2)./f;
%     ref17pt = ((0.017)^2)./f;
%     ref15pt = ((0.015)^2)./f;
%     ref13pt = ((0.013)^2)./f;
%     ref12pt = ((0.012)^2)./f;
%     ref11pt = ((0.011)^2)./f;
%     ref10pt = ((0.010)^2)./f;
%     ref9pt = ((0.009)^2)./f;
%     ref8pt = ((0.008)^2)./f;
%     ref7pt = ((0.007)^2)./f;
%     ref6pt = ((0.006)^2)./f;
%     ref5pt = ((0.005)^2)./f;
%     ref4pt = ((0.004)^2)./f;
%     ref3pt = ((0.003)^2)./f;
%     ref2pt = ((0.002)^2)./f;
%     ref1pt = ((0.001)^2)./f;
% 
%     subplot('position', [0.55 0.10 0.39 0.85]);
%     plotHandles.pw = loglog(f(3:nfft/2,:),Px(3:nfft/2,:),'red',f(3:nfft/2,:),Py(3:nfft/2,:),'green',f(3:nfft/2,:),Pz(3:nfft/2,:),'blue', ...
%         f(3:nfft/2,:), ref100pt(3:nfft/2,:), ... 
%         f(3:nfft/2,:), ref50pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref20pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref17pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref15pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref13pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref12pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref11pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref10pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref9pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref8pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref7pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref6pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref5pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref4pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref3pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref2pt(3:nfft/2,:), ...
%         f(3:nfft/2,:), ref1pt(3:nfft/2,:) );
%     xlabel('Frequency (Hz)');
%     ylabel('$$\textrm{PSD }nT^2/Hz$$','Interpreter','LaTex');
% 
%     axis([0.1 assumedSamplingRate/2 1e-6 1e1])
%     %xlabel('$$\sqrt{f}$$','Interpreter','latex','FontSize',13)
%     h=legend('X', 'Y', 'Z', ... 
%         '$$\textrm{100 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{50 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{20 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{17 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{15 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{13 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{12 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{11 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{10 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{9 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{8 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{7 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{6 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{5 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{4 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{3 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{2 pT}/\sqrt{\textrm{Hz}}$$', ...
%         '$$\textrm{1 pT}/\sqrt{\textrm{Hz}}$$');
%     set(h,'Interpreter','latex')
% % amplitude
% else
%     [Ax, f, ENBW] = welchAmpSpectrum( magData(1,:), assumedSamplingRate, nfft );
%     [Ay, f, ENBW] = welchAmpSpectrum( magData(2,:), assumedSamplingRate, nfft );
%     [Az, f, ENBW] = welchAmpSpectrum( magData(3,:), assumedSamplingRate, nfft );
%     
%     [maxValx, maxIndexx] = max(Ax(3:nfft/2,:));
%     [maxValy, maxIndexy] = max(Ay(3:nfft/2,:));
%     [maxValz, maxIndexz] = max(Az(3:nfft/2,:));
%     
%     subplot('position', [0.55 0.10 0.39 0.85]);
%     plotHandles.pw = loglog(f(3:nfft/2,:),Ax(3:nfft/2,:),'red',f(3:nfft/2,:),Ay(3:nfft/2,:),'green',f(3:nfft/2,:),Az(3:nfft/2,:),'blue');
%     
%     xlabel('Fequency (Hz)');
%     ylabel('Amplitude (nT RMS)');
%     grid on;
%     axis([0.1 assumedSamplingRate/2 1e-2 1e4])
%     text(0.11, 1.2e-4, ['ENBW = ', num2str(ENBW), ' Signal amplitude is correct. Noise floor varies with NFFT'], 'BackgroundColor',[.7 .9 .7]);
% 
% 
%     h=legend('X', 'Y', 'Z' );
% %     set(h,'Interpreter','latex')
% %     
% %     vline(f(maxIndexx+2),'red');
% %     hline(maxValx,'red');
% % 
% %     vline(f(maxIndexy+2),'green');
% %     hline(maxValy,'green');
% %   
% %     vline(f(maxIndexz+2),'blue');
% %     hline(maxValz,'blue');
% 
% set(plotHandles.xamp,'String',sprintf('%3.3f',maxValx));
% set(plotHandles.yamp,'String',sprintf('%3.3f',maxValy));
% set(plotHandles.zamp,'String',sprintf('%3.3f',maxValz));
% 
% set(plotHandles.xfreq,'String',sprintf('%3.3f',f(maxIndexx+2)));
% set(plotHandles.yfreq,'String',sprintf('%3.3f',f(maxIndexy+2)));
% set(plotHandles.zfreq,'String',sprintf('%3.3f',f(maxIndexz+2)));
% 
% % set(plotHandles.xstddev,'String',sprintf('%5.3f',std(magData(1,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
% % set(plotHandles.ystddev,'String',sprintf('%5.3f',std(magData(2,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
% % set(plotHandles.zstddev,'String',sprintf('%5.3f',std(magData(3,numSamplesToStore-numSamplesToDisplay+1:numSamplesToStore))));
%     
% end

grid on;