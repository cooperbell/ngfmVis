[Ax, f, ENBW] = welchAmpSpectrum( magData(1,:), assumedSamplingRate, nfft );
[Ay, f, ENBW] = welchAmpSpectrum( magData(2,:), assumedSamplingRate, nfft );
[Az, f, ENBW] = welchAmpSpectrum( magData(3,:), assumedSamplingRate, nfft );

[maxValx, maxIndexx] = max(Ax(3:nfft/2,:));
[maxValy, maxIndexy] = max(Ay(3:nfft/2,:));
[maxValz, maxIndexz] = max(Az(3:nfft/2,:));

% this seems redundant vvv
plotHandles.pw = loglog(f(3:nfft/2,:),Ax(3:nfft/2,:),'red',f(3:nfft/2,:),Ay(3:nfft/2,:),'green',f(3:nfft/2,:),Az(3:nfft/2,:),'blue');

xlabel('Fequency (Hz)');
ylabel('Amplitude (nT RMS)');
grid on;
axis([0.1 assumedSamplingRate/2 1e-2 1e4])
text(0.11, 1.2e-4, ['ENBW = ', num2str(ENBW), ' Signal amplitude is correct. Noise floor varies with NFFT'], 'BackgroundColor',[.7 .9 .7]);

h=legend('X', 'Y', 'Z' );
% ^^^

% This does the actual updating
set(plotHandles.xamp,'String',sprintf('%3.3f',maxValx));
set(plotHandles.yamp,'String',sprintf('%3.3f',maxValy));
set(plotHandles.zamp,'String',sprintf('%3.3f',maxValz));

set(plotHandles.xfreq,'String',sprintf('%3.3f',f(maxIndexx+2)));
set(plotHandles.yfreq,'String',sprintf('%3.3f',f(maxIndexy+2)));
set(plotHandles.zfreq,'String',sprintf('%3.3f',f(maxIndexz+2)));